#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
"""full.bin -> tftp-factory.bin для аварийного TFTP заводского загрузчика TS-7022.
full.bin -> tftp-factory.bin for the TS-7022 stock bootloader TFTP recovery.

Наш загрузчик (RTL8197F-VG, v3.4T-pre4.6) принимает по TFTP файл из блоков
«16 байт заголовка + данные»: {подпись, адрес загрузки, адрес во флеше, длина}
(big-endian). Сумма 16-битных слов данных должна быть 0.

    [KM70 hdr | ядро] [RM70 hdr | rootfs]

Пары подписей взяты из самого загрузчика: в распакованном образе рядом лежат
KM70/RM70 (и KE32/RE32 у RX23302) и таблица типов образов "Linux kernel",
"Root filesystem", "Total Image". Наше ядро уже несёт KM70 с адресом 0x80A00000
и записи на 0x30000, поэтому первый блок — это kernel.bin как есть.

Внимание: заголовок RM70 ядро и Linux не читают (rootfs монтируется с 0x270000
по разделу), но длина в поле +8 у squashfs — время сборки, Linux его не
проверяет.
"""
import struct
import sys

KERNEL_PART = 0x240000      # 0x30000..0x270000
ROOTFS_FLASH = 0x270000


def sum16(d):
    return sum(struct.unpack(">%dH" % (len(d) // 2), d[: len(d) // 2 * 2])) & 0xFFFF


def main():
    if len(sys.argv) != 3:
        sys.exit("использование / usage: ts7022-tftp-image.py <full.bin> <out>")
    full = open(sys.argv[1], "rb").read()
    sig, load, burn, klen = struct.unpack(">4sIII", full[:16])
    if sig != b"KM70" or burn != 0x30000 or load != 0x80A00000:
        sys.exit("не full.bin TS-7022: %r load=%#x burn=%#x" % (sig, load, burn))
    if 16 + klen > KERNEL_PART or sum16(full[16:16 + klen]) != 0:
        sys.exit("ядро: размер или сумма / kernel size or checksum")
    if full[16 + klen:KERNEL_PART].strip(b"\xff"):
        sys.exit("между ядром и rootfs не 0xFF / gap is not 0xFF")
    root = full[KERNEL_PART:]
    if root[:4] != b"hsqs" or len(root) % 2 or sum16(root) != 0:
        sys.exit("rootfs: не squashfs или сумма не 0 / bad rootfs")
    out = full[:16 + klen]
    # RM70: поле +4 (field1) у заводского образа = 0xf0000. Панель/загрузчик
    # его не читают (панель берёт burn из +8 и длину из +12, сумму — по
    # payload), но держим ровно как в стоке для байтовой совместимости.
    out += struct.pack(">4sIII", b"RM70", 0xf0000, ROOTFS_FLASH, len(root)) + root
    open(sys.argv[2], "wb").write(out)
    print("ts7022-tftp: ядро %d, rootfs %d, итого %d байт" % (klen, len(root), len(out)))


if __name__ == "__main__":
    main()