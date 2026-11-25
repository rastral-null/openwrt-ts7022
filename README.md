# OpenWrt для Transerv 7022

<img width="500" height="474" alt="image" src="https://github.com/user-attachments/assets/b9a595e1-5ef5-4620-af26-ce6fa264cae6" />

### Характеристики

| | |
|---|---|
| SoC | Realtek RTL8197F-VG, MIPS 24Kc, 1 ГГц |
| ОЗУ / флеш | 128 МБ DDR2 / 16 МБ, JEDEC ID 0x204018, XMC XM25QH128C |
| Wi-Fi 2,4 ГГц | встроенный RTL8197G, 2×2 802.11n |
| Wi-Fi 5 ГГц | RTL8812FE (PCIe), 2×2 802.11ac, до 866 Мбит/с |
| Коммутатор | RTL836RB (chip id: 0x6367-0020): 1 WAN + 2 LAN, гигабит |
| Консоль | UART 38400 8N1 |

```text
Booting...
init_ram
bond:0x0000000b
MCM 128MB

 dram_init_clk_frequency ,ddr_freq=1066 (Mbps), 533 (MHZ) 

DRAM init disable

DRAM init enable

DRAM init is done , jump to DRAM
enable DRAM ODT 

SDR init done dev_map=0xb8142000

Detect page_size = 2KB (3)

Detect bank_size = 8 banks(0x00000002)

Detect dram size = 128MB (0x08000000)

DDR init OK
init ddr ok

DRAM Type: DDR2
	DRAM frequency: 533MHz
	DRAM Size: 128MB
JEDEC id 204018, EXT id 0x2040

>>>>>unrecognized JEDEC id 204018<<<<<

use JEDEC id 0xffffff (unknown) instead
found unknown

>>>>>No Flash Vendor support (0x00ffffff)<<<<<

use MXIC as flash vendor instead
unknown, size=4MB, erasesize=64KB, max_speed_hz=15000000Hz
auto_mode=0 addr_width=3 erase_opcode=0x000000d8
Write PLL1=80c00042
=>CPU Wake-up interrupt happen! GISR=89000080 
 
---Realtek RTL8197F-VG boot code at 2020.11.18-13:14+0300 v3.4T-pre4.6 (999MHz)
no sys signature at 00010000!
no sys signature at 00020000!
no rootfs signature at 00260000!
Jump to image start=0x80a00000...
decompressing kernel:
Uncompressing Linux... done, booting the kernel.
done decompressing kernel.
start address: 0x80514c20
[    0.000000] Linux version 3.10.90 (holixus@holixus-GS63-8RE) (gcc version 4.4.7 (Realtek MSDK-4.4.7 Build 2001) ) #23 Thu Feb 11 17:04:20 MSK 2021
[    0.000000] bootconsole [early0] enabled
[    0.000000] CPU revision is: 00019385 (MIPS 24Kc)
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 08000000 @ 00000000 (usable)
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0x07ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0x07ffffff]
[    0.000000] Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
[    0.000000] Primary data cache 32kB, 4-way, PIPT, no aliases, linesize 32 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8176
[    0.000000] Kernel command line: console=ttyS0,38400 root=/dev/mtdblock1
[    0.000000] PID hash table entries: 512 (order: -3, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 2, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 1, 32768 bytes)
[    0.000000] Writing ErrCtl register=0000000e
[    0.000000] Readback ErrCtl register=0000000e
[    0.000000] Memory: 114224k/131072k available (5225k kernel code, 16848k reserved, 2054k data, 192k init, 0k highmem)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:192
[    0.000000] Realtek GPIO IRQ init
[    0.000000] Calibrating delay loop... 666.41 BogoMIPS (lpj=3332096)
[    0.070000] pid_max: default: 32768 minimum: 301
[    0.080000] Mount-cache hash table entries: 2048
[    0.090000] NET: Registered protocol family 16
[    0.100000] <<<<<Register PCI Controller>>>>>
[    0.120000] Do MDIO_RESET
[    0.150000] 40MHz
[    0.490000] Find PCIE Port, Device:Vender ID=f81210ec
[    0.500000] Realtek GPIO controller driver init
[    0.520000] INFO: registering sheipa spi device
[    0.540000] bio: create slab <bio-0> at 0
[    0.550000] INFO: sheipa spi driver register
[    0.560000] INFO: sheipa spi probe
[    0.570000] Switching to clocksource MIPS
[    0.580000] NET: Registered protocol family 2
[    0.590000] TCP established hash table entries: 2048 (order: 0, 16384 bytes)
[    0.610000] TCP bind hash table entries: 2048 (order: -1, 8192 bytes)
[    0.630000] TCP: Hash tables configured (established 2048 bind 2048)
[    0.650000] TCP: reno registered
[    0.660000] UDP hash table entries: 1024 (order: 0, 16384 bytes)
[    0.680000] UDP-Lite hash table entries: 1024 (order: 0, 16384 bytes)
[    0.700000] NET: Registered protocol family 1
[    0.720000] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.740000] jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
[    0.760000] msgmni has been set to 223
[    0.770000] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.790000] io scheduler noop registered (default)
[    0.900000] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    0.940000] console [ttyS0] enabled, bootconsole disabled7) is a 16550A
[    0.940000] console [ttyS0] enabled, bootconsole disabled
[    0.980000] Realtek GPIO Driver for Flash Reload Default
[    1.000000] loop: module loaded
[    1.010000] m25p80 spi0.0: change speed to 15000000Hz, div 7
[    1.020000] JEDEC id 204018
[    1.030000] m25p80 spi0.0: 
[    1.030000] >>>>>unrecognized JEDEC id 204018<<<<<
[    1.030000] 
[    1.060000] use JEDEC id 0xffffff (unknown) instead
[    1.080000] m25p80 spi0.0: found unknown, expected m25p80
[    1.090000] 
[    1.090000] >>>>>No Flash Vendor support (0xffffff)<<<<<
[    1.090000] 
[    1.120000] use MXIC as flash vendor instead
[    1.130000] m25p80 spi0.0: unknown (16384 Kbytes) (15000000 Hz)
[    1.150000] 7 rtkxxpart partitions found on MTD device m25p80.0
[    1.160000] Creating 7 MTD partitions on "m25p80.0":
[    1.180000] 0x000000000000-0x000000270000 : "boot+cfg+linux"
[    1.200000] 0x000000270000-0x0000007a0000 : "rootfs"
[    1.210000] 0x0000007a0000-0x000000800000 : "jffs2 file"
[    1.230000] 0x000000800000-0x000000a70000 : "boot+cfg+linux2"
[    1.250000] 0x000000a70000-0x000000fa0000 : "rootfs2"
[    1.260000] 0x000000fa0000-0x000001000000 : "jffs2 file2"
[    1.280000] 0x000000000000-0x000001000000 : "wholeflash"
[    1.300000] IMQ driver loaded successfully. (numdevs = 2, numqueues = 1)
[    1.320000] 	Hooking IMQ before NAT on PREROUTING.
[    1.340000] 	Hooking IMQ after NAT on POSTROUTING.
[    1.350000] PPP generic driver version 2.4.2
[    1.360000] NET: Registered protocol family 24
[    1.380000] MPPE/MPPC encryption/compression module registered
[    1.400000] Realtek WLAN driver - version 3.8.0(2017-12-26)(SVN:)
[    1.410000] Adaptivity function - version 9.7.07
[    1.430000] MACHAL_version_init
[    1.440000] [MACFM_software_init 297]wifi hal support Mac function = 0x8108
[    1.470000] 
[    1.470000] 
[    1.470000] #######################################################
[    1.500000] SKB_BUF_SIZE=3032 MAX_SKB_NUM=400
[    1.520000] #######################################################
[    1.520000] 
[    1.540000] [MACFM_software_init 297]wifi hal support Mac function = 0x8108
[    1.560000] [MACFM_software_init 297]wifi hal support Mac function = 0x8108
[    1.580000] [MACFM_software_init 297]wifi hal support Mac function = 0x8108
[    1.610000] [MACFM_software_init 297]wifi hal support Mac function = 0x8108
[    1.630000] [MACFM_software_init 297]wifi hal support Mac function = 0x8108
[    1.670000] Do MDIO_RESET
[    1.700000] 40MHz
[    2.040000] Find PCIE Port, Device:Vender ID=f81210ec
[    2.050000] rtl8192cd_init_one(15519): vendor_deivce_id(f81210ec) sub(f81210ec)
[    2.080000] 
[    2.080000]  found 8812F !!! 
[    2.090000] IS_RTL8812F_SERIES value8 = 14 
[    2.100000] Hardware type = RTL8812FE
[    2.110000] MACHAL_version_init
[    2.120000] 11692M
[    2.120000] HALMAC_MAJOR_VER = 1
[    2.120000] HALMAC_PROTOTYPE_VER = 6
[    2.120000] HALMAC_MINOR_VER = 6
[    2.120000] HALMAC_PATCH_VER = 6
[    2.170000] [TRACE]halmac_init_adapter <===
[    2.180000] halmac_init_adapter Succss 
[    2.190000] [MACFM_software_init 297]wifi hal support Mac function = 0x11ff
[    2.240000] 
[    2.240000] 
[    2.240000] #######################################################
[    2.270000] SKB_BUF_SIZE=4432 MAX_SKB_NUM=1024
[    2.280000] #######################################################
[    2.280000] 
[    2.310000] [MACFM_software_init 297]wifi hal support Mac function = 0x11ff
[    2.330000] [MACFM_software_init 297]wifi hal support Mac function = 0x11ff
[    2.350000] [MACFM_software_init 297]wifi hal support Mac function = 0x11ff
[    2.370000] [MACFM_software_init 297]wifi hal support Mac function = 0x11ff
[    2.400000] [MACFM_software_init 297]wifi hal support Mac function = 0x11ff
[    2.420000] u32 classifier
[    2.430000] nf_conntrack version 0.5.0 (1784 buckets, 7136 max)
[    2.450000] nf_conntrack_rtsp v0.6.21 loading
[    2.460000] nf_nat_rtsp v0.6.21 loading
[    2.470000] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.490000] TCP: cubic registered
[    2.500000] NET: Registered protocol family 10
[    2.520000] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.530000] sit: IPv6 over IPv4 tunneling driver
[    2.550000] ip6_gre: GRE over IPv6 tunneling driver
[    2.560000] NET: Registered protocol family 17
[    2.580000] l2tp_core: L2TP core driver, V2.0
[    2.590000] 8021q: 802.1Q VLAN Support v1.8
[    2.610000] Realtek FastPath:v1.03
[    2.620000] 
[    2.620000] Probing RTL819X NIC-kenel stack size order[0]...
[    2.640000]   SoC: 8197FS-VG
[    6.320000] Switch API version: v1.3.11, chip id: 0x6367-0020
[    8.120000] Start to initiate QM
[    8.120000] INIT swCore descriptor count Failed : (0 [0])
[    8.180000] Netlink[Kernel] create socket for hw qos config ok.
[    8.190000] Netlink[Kernel] create socket for hw 83xx qos config ok.
[    8.230000] eth0 added. vid=9 Member port 0x2...
[    8.240000] eth1 added. vid=1 Member port 0x1...
[    8.260000] eth2 added. vid=9 Member port 0x4...
[    8.280000] eth3 added. vid=9 Member port 0x8...
[    8.290000] eth4 added. vid=9 Member port 0x10...
[    8.320000] [peth0] added, mapping to [eth1]...
[    8.340000] VFS: Mounted root (squashfs filesystem) readonly on device 31:1.
[    8.370000] Freeing unused kernel memory: 192K (80720000 - 80750000)
init started: BusyBox v1.13.4 (2021-02-10 19:02:07 MSK)
# 
TRANSERV-TS7022 V1.23.107 MTS -- 2021-02-11 17:06:11+03:00
Thu Feb 11 17:06:00 GMT 2021
flash[919]: customer hw setting offset is 0x23000 flash erasesize=0x10000!!!

flash[919]: current setting offset is 0x2c000 flash erasesize=0x10000!!!

flash[919]: customer hw setting offset is 0x23000 flash erasesize=0x10000!!!

flash[919]: current setting offset is 0x2c000 flash erasesize=0x10000!!!

Please refine linux/.config change offset to fit flash erease size!!!!!!!!!!!!!!!!!
[   10.210000] rtl83xx_setAsicReg: reg= 1b03, data= 200
reinitd[924]: Event [init] boot=1
reinitd[942]:init: copyFile(): open source '/etc/passwd_orig' failed: No such file or directory
reinitd[942]:init: copyFile(): open source '/etc/group_orig' failed: No such file or directory
[   10.950000] device eth0 entered promiscuous mode
[   10.970000] device eth2 entered promiscuous mode
[   10.990000] device wlan0 entered promiscuous mode
[   11.010000] device wlan0-va0 entered promiscuous mode
[   11.030000] device wlan0-va1 entered promiscuous mode
[   11.050000] device wlan0-va2 entered promiscuous mode
[   11.070000] device wlan0-va3 entered promiscuous mode
[   11.090000] device wlan0-vxd entered promiscuous mode
[   11.110000] device wlan1 entered promiscuous mode
[   11.120000] device wlan1-va0 entered promiscuous mode
[   11.140000] device wlan1-va1 entered promiscuous mode
[   11.160000] device wlan1-va2 entered promiscuous mode
[   11.180000] device wlan1-va3 entered promiscuous mode
[   11.200000] device wlan1-vxd entered promiscuous mode
reinitd[942]:init: update_bridge_lan_intf(delif)
[   11.240000] IPv6: ADDRCONF(NETDEV_UP): br0: link is not ready
reinitd[942]:init: (2)"RTNETLINK answers: Cannot assign requested address" < ip -6 address add ::/0 dev br0 
[   11.610000] chip_version=0x100f,WlanSupportAbility = 0x2
[   11.630000] PrepareRXBD88XX_V1 134 
[   11.640000] test 0x875d2c00,0x30,0x75d2e80,0x0, 
[   11.660000] test 0x875d2c80,0x30,0x75d2ec0,0x0, 
[   11.670000] test 0x875d2d00,0x30,0x75d2f00,0x0, 
[   11.690000] test 0x875d2d80,0x30,0x75d2f40,0x0, 
[   11.700000] test 0x875d2e00,0x30,0x75d2f80,0x0, 
[   11.850000] [97F] RFE type 0 PHY paratemters: DEFAULT
[   11.850000] clock 40MHz
[   11.850000] AP-mode enabled...
[   11.850000] RT_OP_MODE_AP...
[   11.890000] [GetHwReg88XX][rtl8197Gfw]
[   11.900000] [GetHwReg88XX][rtl8197Gfw size]
[   12.050000] InitMACTRX OK
[   12.050000] InitMACProtocolHandler OK
[   12.050000] InitMACSchedulerHandler OK
[   12.050000] InitMACWMACHandler OK
[   12.050000] InitMACSysyemCfgHandler OK
[   12.050000] InitMACFunctionHandler OK
[   12.120000] [GetHwReg88XX][PHY_REG_PG_8197Gmp_Type0] size = 0x872 *((pu4Byte)(val))=0 
[   12.140000] [GetHwReg88XX][PHY_REG_PG_8197Gmp_Type0 start ] 8068b150 
[   12.470000] start_addr=(0x0), end_addr=(0x10000), buffer_size=(0x10000), smp_number_max=(8192)
[   12.740000] chip_version=0x2001,WlanSupportAbility = 0x3
[   12.900000] clock 40MHz
[   12.900000] [TRACE]pre_init_system_cfg_8812f ===>
[   12.900000] [TRACE]set_hw_value_88xx ===>
[   12.900000] [TRACE]set_hw_value_88xx <===
[   12.900000] [TRACE]pre_init_system_cfg_8812f <===
[   12.900000] [TRACE]mac_pwr_switch_pcie_8812f ===>
[   12.900000] [TRACE]pwr = 1
[   12.900000] [TRACE]8812F pwr seq ver = V01
[   12.900000] [TRACE]mac_pwr_switch_pcie_8812f <===
[   12.900000] InitPON OK!!!
[   12.900000] REG_HCI_MIX_CFG = 2b 
[   12.900000] [TRACE]init_system_cfg_8812f ===>
[   12.900000] [TRACE]init_system_cfg_8812f <===
[   12.900000] InitMAC Page0 
[   12.900000] [TRACE]download_firmware_88xx ===>
[   12.900000] [TRACE]halmac h2c ver = f, fw h2c ver = e!!
[   12.900000] [TRACE]=== FW info ===
[   12.900000] [TRACE]ver : 3
[   12.900000] [TRACE]sub-ver : 3
[   12.900000] [TRACE]sub-idx : 0
[   12.900000] [TRACE]build : 2019/8/13 9:35
[   12.900000] [TRACE]Dlfw OK, enable CPU
[   12.900000] [TRACE]0x80=0xC078, cnt=5000
[   12.900000] [TRACE]download_firmware_88xx <===
[   12.900000] >>SetBeaconDownload88XX
[   12.900000] Init Download FW OK 
[   12.900000] [TRACE]cfg_la_mode_88xx ===>
[   12.900000] [TRACE]cfg_la_mode_88xx <===
[   12.900000] [TRACE]init_mac_cfg_88xx ===>
[   12.900000] [TRACE]init_trx_cfg_8812f ===>
[   12.900000] [TRACE]rqpn_parser_88xx done
[   12.900000] [TRACE]pg_num_parser_88xx done
[   12.900000] [TRACE]Set FIFO page
[   12.900000] [TRACE]h2c fs : 1024
[   12.900000] [TRACE]init_trx_cfg_8812f <===
[   12.900000] [TRACE]init_protocol_cfg_8812f ===>
[   12.900000] [TRACE]init_protocol_cfg_8812f <===
[   12.900000] [TRACE]init_edca_cfg_8812f ===>
[   12.900000] [TRACE]init_edca_cfg_8812f <===
[   12.900000] [TRACE]init_wmac_cfg_8812f ===>
[   12.900000] [TRACE]init_low_pwr_8812f ===>
[   12.900000] [TRACE]init_low_pwr_8812f <===
[   12.900000] [TRACE]init_wmac_cfg_8812f <===
[   12.900000] [TRACE]init_mac_cfg_88xx <===
[   12.900000] halmac_init_mac_cfg OK
[   12.900000] halmac_cfg_rx_aggregation OK
[   12.900000] [TRACE]cfg_mac_addr_88xx ===>
[   12.900000] [TRACE]cfg_mac_addr_88xx <===
[   12.900000] halmac_init_mac_cfg OK
[   12.900000] [TRACE]cfg_drv_info_8812f ===>
[   12.900000] [TRACE]drv info = 1
[   12.900000] [TRACE]set_hw_value_8812f ===>
[   12.900000] [TRACE]set_hw_value_88xx ===>
[   12.900000] [TRACE]cfg_rx_ignore_8812f ===>
[   12.900000] [TRACE]cfg_rx_ignore_8812f <===
[   12.900000] [TRACE]set_hw_value_8812f <===
[   12.900000] [TRACE]cfg_drv_info_8812f <===
[   13.570000] [GetHwReg88XX][size PHY_REG_PG_8812Fmp_Type0]
[   13.590000] [GetHwReg88XX][PHY_REG_PG_8812Fmp_Type0]
[   13.810000] start_addr=(0x20000), end_addr=(0x40000), buffer_size=(0x20000), smp_number_max=(16384)
[   13.810000] [set_8812F_trx_regs] +++ 
[   14.310000] RTL8812F: INIT GPIO over PCI is OK!
[   14.360000] br0: port 9(wlan1) entered forwarding state
[   14.380000] br0: port 9(wlan1) entered forwarding state
[   14.400000] br0: port 3(wlan0) entered forwarding state
[   14.410000] br0: port 3(wlan0) entered forwarding state
[   14.430000] br0: port 2(eth2) entered forwarding state
[   14.440000] br0: port 2(eth2) entered forwarding state
[   14.460000] br0: port 1(eth0) entered forwarding state
[   14.470000] br0: port 1(eth0) entered forwarding state
reinitd[942]:init: LAN static IP: 192.168.0.254/24

WiFi Simple Config v2.20-wps2.0 (2021.02.11-14:05+0000).

sysmond[904]: poll handler of `net` work overtime: 1637 > 500
sysmond[904]: poll: loop overtime: 2536 > 1000
Register to wlan0
Register to wlan1
iapp[1096]: IEEE 802.11f (IAPP) using interface br0 (v1.23)
iwcontrol RegisterPID to (wlan0)
iwcontrol RegisterPID to (wlan1)
timelycheck[1137]: #timelicheck v1.1.0
dual boot utility: start
dual boot utility: linux_offset=0x30000, rootfs_offset=0x270000, back_linux_offset=0x830000, back_rootfs_offset=0xA70000

# dual boot utility: image already copied to backup bank
timelycheck[1137]: Start wdscfgd
```

</details>

### Откуда код

Порт собран из работы многих людей — подробно, со ссылками и лицензиями:
[docs/sources.md](docs/sources.md).

### Лицензия

На репозиторий действует лицензия GPL v2.0
