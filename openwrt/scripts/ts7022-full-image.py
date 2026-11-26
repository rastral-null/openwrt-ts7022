#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
"""Собирает ОДИН файл прошивки TRANSERV TS-7022 под флеш с адреса 0x30000.

    ядро (cvimg KM70)  | 0xFF до 0x240000 | rootfs (squashfs + сумма загрузчика)
    флеш 0x030000 ...                       флеш 0x270000 ...

Раздел kernel = 0x30000..0x270000 (0x240000), rootfs = 0x270000..0x600000
(0x390000). Загрузчик ищет ядро на 0x30000 и корневую систему ровно на
0x270000, поэтому rootfs нельзя класть сразу за ядром.

Пишется целиком: из работающей системы `mtd write full.bin firmware` или
загрузчиком через UART: XMOD в ОЗУ, затем FLW 30000 <адрес в ОЗУ> <длина>.

Сумма rootfs — тем же способом, что scripts/rtl819x-rootfs-chksum.py
(по разбору загрузчика).
"""
import os
import struct
import subprocess
import sys

KERNEL_MAX = 0x240000           # раздел kernel 0x30000..0x270000
ROOTFS_MAX = 0x390000           # раздел rootfs 0x270000..0x600000
SIGNATURE = b"KM70"
LOAD_ADDR = 0x80A00000
BURN_ADDR = 0x30000


def summa(d):
    s = 0
    for i in range(0, len(d) - 1, 2):
        s = (s + ((d[i] << 8) | d[i + 1])) & 0xFFFF
    return s


def main():
    if len(sys.argv) != 4:
        sys.exit("использование: ts7022-full-image.py <kernel.bin> <rootfs.squashfs> <выход>")
    kern_p, root_p, out_p = sys.argv[1:]

    kern = open(kern_p, "rb").read()
    if kern[:4] != SIGNATURE:
        sys.exit("ядро без подписи KM70: %r" % kern[:4])
    if len(kern) < 16:
        sys.exit("ядро короче заголовка cvimg")
    sig, load, burn, klen = struct.unpack(">4sIII", kern[:16])
    if sig != SIGNATURE or load != LOAD_ADDR or burn != BURN_ADDR:
        sys.exit("неверный заголовок cvimg: %r load=%#x burn=%#x" %
                 (sig, load, burn))
    if 16 + klen > len(kern):
        sys.exit("длина в заголовке %#x больше файла %#x" % (klen, len(kern)))
    if len(kern) > KERNEL_MAX:
        sys.exit("ядро %d байт больше раздела %d" % (len(kern), KERNEL_MAX))

    # rootfs: копия, к которой применяем ту же сумму, что для rootfs.bin
    tmp = out_p + ".rootfs"
    with open(root_p, "rb") as f, open(tmp, "wb") as g:
        g.write(f.read())
    chk = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                       "rtl819x-rootfs-chksum.py")
    subprocess.run([sys.executable, chk, tmp], check=True)
    root = open(tmp, "rb").read()
    os.unlink(tmp)
    if root[:4] not in (b"hsqs", b"sqsh"):
        sys.exit("rootfs не squashfs")
    if len(root) > ROOTFS_MAX:
        sys.exit("rootfs %d байт больше раздела %d" % (len(root), ROOTFS_MAX))
    if summa(root) != 0:
        sys.exit("сумма rootfs не ноль")

    img = kern + b"\xff" * (KERNEL_MAX - len(kern)) + root
    open(out_p, "wb").write(img)
    print("ts7022-full: ядро %d (запас %d), rootfs %d (запас %d), итого %d байт"
          % (len(kern), KERNEL_MAX - len(kern), len(root),
             ROOTFS_MAX - len(root), len(img)))


if __name__ == "__main__":
    main()
