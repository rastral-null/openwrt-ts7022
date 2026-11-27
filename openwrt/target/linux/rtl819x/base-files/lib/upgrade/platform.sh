# SPDX-License-Identifier: GPL-2.0-only
#
# sysupgrade для плат на RTL8197F: ELECTRA RX23302 и TRANSERV TS-7022.
#
# Образ sysupgrade.bin = full.bin + метаданные fwtool:
#   0x000000  ядро с заголовком (cvimg), добито 0xFF до конца раздела kernel
#   K         rootfs (squashfs + 2 байта суммы загрузчика)
# Во флеше это разделы kernel (0x30000) и rootfs (K), настройки живут
# отдельно, в rootfs_data, а не за rootfs:
#
#   плата    сигнатура  kernel (0x30000)  rootfs
#   RX23302  KE32       0x2d0000          0x300000
#   TS-7022  KM70       0x240000          0x270000
#
# Порядок записи выбран так, чтобы прерванное обновление (выключили свет)
# не оставляло "новое ядро со старым rootfs":
#   1. стереть kernel - с этой секунды набор 1 для загрузчика негоден;
#   2. записать rootfs;
#   3. записать kernel - последним.
# Если запись оборвётся на шагах 1-3, годного ядра не останется и устройство
# поднимают по TFTP или UART (docs/install-tftp.md, docs/install-uart.md).
# Старое ядро с новым rootfs (или наоборот) не загрузится никогда.
#
# Копирования второго банка поверх первого на TS-7022 НЕТ: в bootcode этой
# платы нет строк "Checking bank2"/"Copy bank2" (проверено по дампу
# 0x0..0x30000 и по логу загрузки), а единственное упоминание банка в
# заводском логе печатает пользовательская утилита "dual boot utility".
# С v0.2 второго банка нет и в разметке: 0x600000..0x1000000 отдан под
# rootfs_data, поэтому platform_do_upgrade заодно стирает старые cfg/stock.
#
# sysupgrade for the RTL8197F boards. The image is full.bin plus fwtool
# metadata. Order: erase kernel, write rootfs, write kernel last. An
# interrupted upgrade leaves no valid kernel and the board is recovered over
# TFTP/UART - the TS-7022 bootcode does not copy bank 2 over bank 1 (no such
# strings in its bootcode, none in the boot log; only the stock userspace
# "dual boot utility" mentions banks). Since v0.2 there is no bank 2 in the
# layout at all: 0x600000..0x1000000 belongs to rootfs_data.

REQUIRE_IMAGE_METADATA=1

# Переменные платы: KERNEL_SIZE, ROOTFS_SIZE, MAGIC (первые 4 байта образа),
# SIG (та же сигнатура текстом) и MODEL (имя профиля для сообщений).
platform_vars() {
	case "$(board_name)" in
	electra,rx23302)
		KERNEL_SIZE=$((0x2d0000))
		ROOTFS_SIZE=$((0x300000))
		MAGIC="4b453332"
		SIG="KE32"
		MODEL="electra_rx23302"
		;;
	transerv,ts7022)
		KERNEL_SIZE=$((0x240000))
		ROOTFS_SIZE=$((0x390000))
		MAGIC="4b4d3730"
		SIG="KM70"
		MODEL="transerv_ts7022"
		;;
	*)
		return 1
		;;
	esac
}

# Размер образа без хвоста метаданных fwtool.
platform_image_size() {
	fwtool -q -T -i /dev/null "$1" | wc -c
}

platform_check_image() {
	local img="$1"
	local size magic burn sq

	[ "$#" -gt 1 ] && return 1

	platform_vars || {
		v "Unsupported board: $(board_name)."
		return 1
	}

	magic=$(get_magic_long "$img")
	[ "$magic" = "$MAGIC" ] || {
		v "Not a $SIG image: no $SIG kernel header (got $magic)."
		v "Use openwrt-*-$MODEL-squashfs-sysupgrade.bin."
		return 1
	}

	# Адрес записи ядра из заголовка (байты 8..11) - только 0x30000.
	burn=$(dd if="$img" bs=1 skip=8 count=4 2>/dev/null | hexdump -v -n 4 -e '1/1 "%02x"')
	[ "$burn" = "00030000" ] || {
		v "Kernel burn address $burn is not 00030000 - wrong image."
		return 1
	}

	sq=$(dd if="$img" bs=4096 skip=$((KERNEL_SIZE / 4096)) count=1 2>/dev/null | \
		hexdump -v -n 4 -e '1/1 "%02x"')
	case "$sq" in
	68737173|73717368) ;;
	*)
		v "No squashfs at offset 0x$(printf '%x' "$KERNEL_SIZE") (got $sq) - this is not a full image."
		return 1
		;;
	esac

	size=$(platform_image_size "$img")
	[ "$size" -gt "$KERNEL_SIZE" ] && \
	[ "$size" -le $((KERNEL_SIZE + ROOTFS_SIZE)) ] || {
		v "Image size $size is out of range."
		return 1
	}

	return 0
}

platform_do_upgrade() {
	local img="$1"
	local kblocks

	platform_vars || exit 1
	kblocks=$((KERNEL_SIZE / 4096))

	# Хвост метаданных во флеш не нужен.
	fwtool -q -t -i /dev/null "$img"

	sync
	echo 3 > /proc/sys/vm/drop_caches

	v "Invalidating kernel (interrupted upgrade -> recover over TFTP/UART)..."
	mtd erase kernel || exit 1

	# Настройки: rootfs_data - отдельный раздел, mtd write его не трогает.
	# Стираем всегда и до записи ядра, иначе старый overlay перекроет
	# новую систему.
	v "Erasing rootfs_data..."
	mtd erase rootfs_data || exit 1

	v "Writing rootfs..."
	dd if="$img" bs=4096 skip=$kblocks 2>/dev/null | mtd write - rootfs || exit 1

	v "Writing kernel..."
	dd if="$img" bs=4096 count=$kblocks 2>/dev/null | mtd write - kernel || exit 1

	# v0.2: хвост флеша от 0x600000 отдан под rootfs_data. На системе v0.1
	# там ещё живут разделы cfg (0x7A0000) и stock (0x800000) - стираем их
	# последними, когда ядро уже записано: если питание пропадёт, банк 1
	# останется годным, а негодной окажется только память под overlay.
	if [ "$MODEL" = "transerv_ts7022" ]; then
		for p in cfg stock; do
			grep -q "\"$p\"" /proc/mtd || continue
			v "Erasing $p (v0.2: отдан под rootfs_data)..."
			mtd erase "$p" || exit 1
		done
	fi
}

# Сохранённые настройки кладём в чистый rootfs_data файлом sysupgrade.tgz;
# mount_root перенесёт его в overlay, а preinit распакует при загрузке.
platform_copy_config() {
	v "Saving config to rootfs_data..."
	mtd jffs2write "$UPGRADE_BACKUP" rootfs_data
}
