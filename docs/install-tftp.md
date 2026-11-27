# Установка без UART: кнопка Reset + TFTP / Installing without UART: Reset + TFTP

> **RU** ниже, **EN** — в конце.

> ⚠️ **Процедура унаследована от порта ELECTRA RX23302 и на TRANSERV TS-7022
> отдельно не проверялась.** Имена файлов, подписи и смещения ниже приведены
> к TS-7022 по исходникам этого репозитория, но сам вход в TFTP-режим,
> адрес загрузчика и запись на живой TS-7022 не подтверждены. Если что-то
> пойдёт не так, используйте UART — [install-uart.md](install-uart.md).
>
> Образ TS-7022 при этом собран и проверен на железе: OpenWrt загружается.

> ⚠️ Только для **TRANSERV TS-7022 с RTL8197F-VG** (загрузчик семейства
> `v3.4T-pre4.6`). Другие ревизии и двойники не проверялись — см. README.

## Как это работает

В заводском загрузчике Realtek есть аварийный режим. Если при включении питания
**зажата кнопка Reset**, загрузчик не запускает прошивку, а поднимает TFTP-сервер
на адресе **192.168.1.6**. Принятый файл он проверяет (подписи `KM70`/`RM70`,
контрольные суммы), сам пишет во флеш и перезагружается. Разбирать корпус и паять
не нужно.

Файл для этого способа — **`openwrt-…-transerv_ts7022-squashfs-tftp-factory.bin`**.
Это тот же `full.bin`, только разложенный на два блока с заголовками, которые
понимает загрузчик: ядро ложится с 0x30000, корневая система — с 0x270000.
Во флеше получается то же самое, что после установки через UART.

**Начиная с v0.2 второй банк (0x800000) отдан под overlay** — заводской копии
на устройстве больше нет, путь назад только через TFTP (эта страница) или UART,
см. [recovery.md](recovery.md).

## Что понадобится

- Компьютер с проводом Ethernet и TFTP-клиентом (Linux: `tftp-hpa`, `atftp` или
  `busybox tftp`; Windows: встроенный «Клиент TFTP» или tftpd64).
- Скрепка для кнопки Reset.

## Шаги

1. Компьютер — проводом в одно из гнёзд **LAN** роутера (не в синий WAN).
2. На компьютере вручную задайте адрес **192.168.1.10**, маска **255.255.255.0**.
   Этот адрес не должен пересекаться с адресом LAN самой OpenWrt (192.168.1.1).
3. Выключите роутер. **Зажмите Reset**, затем, **не отпуская**, включите питание.
   Держите ~10 секунд.
   - Если до этого уже было включено, а вы зажали кнопку потом, — не сработает:
     загрузчик смотрит на кнопку один раз, в первые секунды.
4. Проверьте, что режим включился: `ping 192.168.1.6` **не отвечает** (так и
   должно быть), но `arp -a` показывает адрес 192.168.1.6. Надёжнее всего —
   сразу пробовать шаг 5.
5. Отправьте файл (двоичный режим):
   ```sh
   # Linux, busybox:
   busybox tftp -p -l openwrt-…-tftp-factory.bin -r tftp-factory.bin 192.168.1.6
   # Linux, tftp-hpa:
   tftp 192.168.1.6 -m binary -c put openwrt-…-tftp-factory.bin
   # Windows:
   tftp -i 192.168.1.6 PUT openwrt-…-tftp-factory.bin
   ```
   Передача — секунды. **Не выключайте питание** минимум 3 минуты: загрузчик
   пишет ядро, затем корневую систему (в логе UART, если он подключён,
   `Flash Write Successed!`) и сам перезагрузится.
6. После перезагрузки — OpenWrt: **192.168.1.1**, LuCI в браузере, Wi-Fi
   `TS-7022` / `TS-7022-5G`, пароль по умолчанию `1234567890` (смените).
7. **Раздел настроек TFTP не стирает.** Если на роутере уже стояла OpenWrt —
   сбросьте настройки: держите Reset 5+ секунд в работающей OpenWrt, или LuCI
   «Восстановить заводские», или `firstboot -y && reboot`. Если раньше была
   заводская прошивка — ничего делать не нужно.

## Если что-то пошло не так

- Загрузчик **не трогает** себя и заводские данные (0x0–0x30000), поэтому
  повторить шаги 3–5 можно всегда. Если и это не помогает —
  [install-uart.md](install-uart.md).
- Если в файле испорчена сумма, загрузчик ничего не пишет («checksum error»).
- Не дописывайте к файлу ничего своего: посторонний хвост может быть принят
  за данные и испортить область заводских настроек.

---

## English

> ⚠️ **This procedure is inherited from the ELECTRA RX23302 port and has not
> been separately verified on the TRANSERV TS-7022.** Filenames, signatures and
> offsets below are adapted to the TS-7022 from this repository's sources, but
> entering TFTP mode, the loader address and flashing on a live TS-7022 are
> unconfirmed. If it does not work, use UART — see [install-uart.md](install-uart.md).
> The TS-7022 image itself has been built and booted on hardware.

> For **TRANSERV TS-7022 with RTL8197F-VG** only (loader family `v3.4T-pre4.6`).

The stock bootloader has a recovery mode: hold **Reset while applying power**
(keep it ~10 s) and it starts a TFTP server at **192.168.1.6** instead of booting.
It checks the received file (`KM70`/`RM70` signatures, checksums), writes it to
flash and reboots. No disassembly, no soldering.

Use **`openwrt-…-transerv_ts7022-squashfs-tftp-factory.bin`** — the same content
as `full.bin` split into two bootloader-understood blocks (kernel → 0x30000,
rootfs → 0x270000). Since **v0.2** the second bank (0x800000) belongs to the
overlay — there is no stock copy on the device any more, so the way back is TFTP
or UART only, see [recovery.md](recovery.md).

1. PC cable into a router **LAN** port; set PC address **192.168.1.10/24**.
2. Power off, **hold Reset, power on**, keep holding ~10 s (pressing after
   power-on does not work).
3. `tftp -i 192.168.1.6 PUT openwrt-…-tftp-factory.bin` (binary mode). `ping` to
   .6 does not answer — expected.
4. Do not cut power for at least 3 minutes; it reboots by itself into OpenWrt
   (**192.168.1.1**), Wi-Fi `TS-7022` / `TS-7022-5G`, default password
   `1234567890`.
5. TFTP does not erase the settings partition: if OpenWrt was installed before,
   factory-reset it (hold Reset 5+ s, LuCI, or `firstboot -y && reboot`).