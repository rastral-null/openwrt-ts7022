#
# RTL8197F device profiles
#

# ELECTRA RX23302 — роутер Ростелекома на RTL8197FH-VG.
#
# Адреса подтверждены выводом собственного bootcode устройства:
#   "Jump to image start=0x80a00000"   → CVIMG_LOADER_START_ADDR
#   dual boot utility: linux_offset=0x30000 → CVIMG_KERNEL_BURN_ADDR
# IMAGE_SIZE = банк 8 МБ минус 0x30000 под bootcode+hwconfig.
define Device/electra_rx23302
  SOC := rtl8197f
  DEVICE_VENDOR := ELECTRA
  DEVICE_MODEL := RX23302
  IMAGE_SIZE := 7936k
  CVIMG_KERNEL_BURN_ADDR := 0x30000
  CVIMG_LOADER_START_ADDR := 0x80A00000
  CVIMG_CUSTOM_SIGNATURE := KE32
endef
TARGET_DEVICES += electra_rx23302

# TRANSERV TS-7022 (МТС) — RTL8197F-VG, 128 МБ ОЗУ, 16 МБ SPI-NOR.
#
# Сигнатура "KM70" и адрес rootfs 0x270000 сняты с полного дампа флеша
# (0x30000 и 0x270000 соответственно). Раздел kernel — 0x240000, rootfs —
# 0x390000; сумма 0x5d0000 совпадает с эталонным профилем RX23302.
define Device/transerv_ts7022
  SOC := rtl8197f
  DEVICE_VENDOR := TRANSERV
  DEVICE_MODEL := TS-7022
  IMAGE_SIZE := 5952k
  CVIMG_KERNEL_BURN_ADDR := 0x30000
  CVIMG_LOADER_START_ADDR := 0x80A00000
  CVIMG_CUSTOM_SIGNATURE := KM70
  # full.bin — один файл под флеш с 0x30000 (ядро KM70 | 0xFF до 0x270000 |
  # rootfs с суммой загрузчика), tftp-factory.bin — тот же набор блоками
  # KM70 + RM70 для аварийного TFTP (Reset при включении, 192.168.1.6).
  # sysupgrade.bin — full.bin плюс метаданные fwtool; пишется из работающей
  # системы, порядок и адреса — в base-files/lib/upgrade/platform.sh.
  IMAGES := sysupgrade.bin kernel.bin rootfs.bin full.bin tftp-factory.bin
  IMAGE/sysupgrade.bin := ts7022-full | append-metadata
  IMAGE/full.bin := ts7022-full
  IMAGE/tftp-factory.bin := ts7022-tftp
endef
TARGET_DEVICES += transerv_ts7022
