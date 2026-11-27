# Восстановление и возврат на заводскую прошивку / Recovery and return to stock

> **RU** ниже, **EN** — в конце.

> ⚠️ **Процедуры возврата на сток унаследованы от порта ELECTRA RX23302 и на
> TRANSERV TS-7022 отдельно не проверялись.** Разметка флеша ниже взята из
> реального лога загрузки TS-7022 (см. README). Копирования второго банка поверх
> первого на TS-7022 **нет**: в bootcode этой платы нет строк `Checking bank2` и
> `Copy bank2`, нет их и в логе загрузки. Поэтому «загрузчик сам восстановит
> заводскую прошивку» здесь не работает, а с **v0.2** второго банка нет и в
> разметке — он отдан под overlay.

## Разметка флеша (16 МБ, XM25QH128C)

Данные из реального лога загрузки TS-7022 (`/proc/mtd`):

| Смещение | Размер | Раздел | Что там |
|---|---|---|---|
| 0x000000 | 0x030000 | boot | загрузчик Realtek и заводские настройки платы (MAC, калибровка) — **не трогать никогда** |
| 0x030000 | 0x240000 | kernel | ядро OpenWrt |
| 0x270000 | 0x390000 | rootfs | корневая система OpenWrt |
| 0x600000 | 0x1A0000 | rootfs_data | настройки OpenWrt (overlay), **v0.1** |
| 0x7A0000 | 0x060000 | cfg | настройки заводской прошивки, только чтение, **v0.1** |
| 0x800000 | 0x800000 | stock | банк 2: заводская копия, **v0.1** |
| 0x600000 | 0xA00000 | rootfs_data | **v0.2: overlay 10 МБ** — `cfg` и банк 2 отданы под него |

Отличие от RX23302: у TS-7022 ядро занимает `0x30000..0x270000`, а корневая
система начинается с `0x270000` (у RX23302 — `0x2d0000`/`0x300000`), и подпись
ядра — `KM70`, а не `KE32`.

Заводская прошивка TS-7022 — dual-image: два банка по 8 МБ. На **v0.1** OpenWrt
писался только в банк 1, а копия в банке 2 (с `0x800000`) оставалась нетронутой.
На **v0.2** банк 2 и раздел `cfg` отданы под overlay: 1,7 МБ на настройки было
мало, а загрузчик TS-7022 банк 2 всё равно не восстанавливает (см. ниже).
Копию банка 1 в банк 2 на заводской прошивке делает утилита `dual boot utility`
из userspace — это не механизм восстановления, а подготовка к OTA.

**Перед переходом на v0.2 сохраните полный дамп флеша (16 МБ).** После v0.2
заводской копии на устройстве нет, и путь назад — только TFTP/UART с этим дампом.

## Как загрузчик защищает от кирпича

⚠️ Этот раздел — про **ELECTRA RX23302**. У TS-7022 такого механизма нет:
в его bootcode (дамп `0x0..0x30000`) нет строк `Checking bank2` / `Copy bank2`
и в логе загрузки они не появляются. Ниже — как это выглядит на RX23302,
для сравнения:

```
Checking bank2...
Flash read from 00830000 to 80800000 with 007D0000 bytes ?
Flash Program from 80800000 to 00030000 with 007D0000 bytes ?
Copy bank2 to bank1 successfully!
Jump to image start=0x80a00000...
Linux version 3.10.90-pre5 (abudeev@honor) ...
```

*(лог с RX23302, 20.10.2026)*

Поэтому на TS-7022:
- оборванная прошивка (выключили свет во время sysupgrade) **не** поднимется
  сама на заводской прошивке — устройство придётся поднимать по TFTP или UART;
- на v0.1 «вернуть сток» ещё можно было одной командой (ниже), на v0.2 — только
  прошивкой дампа через загрузчик.

## Вернуть заводскую прошивку

### v0.2 и новее: только TFTP/UART

Заводской копии в банке 2 больше нет. Порядок:

1. Полный дамп флеша, снятый до установки OpenWrt (16 МБ, sha256
   `208ff9c2f7ade10506e11a0c380e869ad39f9497fb722b55d9aa358c7dd67fa7`).
   Из него нужен кусок `0x30000..0x800000` — это ровно банк 1 заводской прошивки
   в том же виде, в каком его принимает `tools/flash-uart-ts7022.py`
   (ядро с `0x30000`, rootfs с `0x270000`).
2. Загнать этот кусок по UART тем же скриптом (или через TFTP, если поднимется
   аварийный загрузчик: Reset при включении).
3. После загрузки стока — сброс кнопкой Reset, чтобы заводская прошивка
   разложила свои настройки (раздел `cfg` к этому моменту стёрт).

### v0.1: `mtd erase kernel && reboot` (на TS-7022 не проверялось)

Из OpenWrt (SSH или UART):

```sh
mtd erase kernel && reboot
```

На RX23302 загрузчик после этого копировал заводскую прошивку из банка 2 в банк 1
и грузил её (~1–2 мин). **На TS-7022 копирования банка нет** — команда оставит
устройство без ядра, и поднимать его придётся по TFTP/UART.

Проверено на RX23302: после возврата банк 1 побайтно совпадал с заводским дампом
флеша, загрузчик и заводские настройки платы не тронуты.

> На v0.1 заводская прошивка поднималась со своими настройками (раздел `cfg`
> OpenWrt не трогал). На v0.2 `cfg` стёрт — после возврата на сток сделайте сброс
> кнопкой Reset, чтобы прошивка разложила настройки заново.

## Если OpenWrt не загружается

**Без разборки:** выключите роутер, зажмите Reset, включите питание, держите ~10 с —
загрузчик поднимет аварийный TFTP на 192.168.1.6. Передайте
`…-squashfs-tftp-factory.bin` — [install-tftp.md](install-tftp.md). Так же OpenWrt
ставится заново после возврата на сток.

**Через UART** (если TFTP не помог):
1. Подключите UART (38400 8N1), включите роутер, жмите Esc до приглашения `<RealTek>`.
2. Прошейте образ заново: `tools/flash-uart-ts7022.py` (он сам ловит загрузчик) —
   [install-uart.md](install-uart.md).

Загрузчик живёт в отдельной области и прошивкой не затирается: пока он печатает
`<RealTek>`, устройство восстанавливается.

## Правила загрузчика

- Команды только **с полными аргументами**. `FLR` и `AUTOBURN` без аргументов вешают загрузчик до сброса питания.
- На вопрос `(Y)es, (N)o` — **`Y` и Enter**. Без Enter загрузчик молча ждёт бесконечно (выглядит как зависание).
- Пока `FLW`/`FLR` печатают точки — ничего не отправлять.
- Слово `<RealTek>` в выводе ещё не значит «готово» — ждите `Successed` или тишину.

---

## English

> ⚠️ **The recovery procedures are inherited from the ELECTRA RX23302 port and
> have not been separately verified on the TRANSERV TS-7022.** The flash layout
> comes from a real TS-7022 boot log (see README). The TS-7022 bootcode does **not**
> copy bank 2 over bank 1 (no `Checking bank2`/`Copy bank2` strings in its bootcode,
> none in the boot log), and since **v0.2** there is no bank 2 in the layout at all:
> it was given to the overlay.

**Flash layout (16 MB):** see the table above. TS-7022 kernel occupies
`0x30000..0x270000`, rootfs starts at `0x270000` (RX23302 used
`0x2d0000`/`0x300000`), and the kernel signature is `KM70`, not `KE32`. On v0.1
OpenWrt lived in bank 1 and the stock copy in bank 2 (from `0x800000`) was never
written. Since **v0.2** `rootfs_data` covers `0x600000..0x1000000` (10 MB overlay)
and the old `cfg`/bank-2 regions are erased by sysupgrade. The bootloader
(0x0–0x30000) is never written.

**Brick protection:** this is an **RX23302** feature, not a TS-7022 one. On the
RX23302 the bootloader validates bank 1 on every boot and, if it is invalid,
**copies bank 2 over bank 1 by itself** and boots the stock firmware
(`Copy bank2 to bank1 successfully!`). The TS-7022 bootcode has no such code, so an
interrupted sysupgrade leaves the board without a kernel and it must be recovered
over TFTP or UART.

**Return to stock (v0.2 and newer):** only over TFTP/UART. Keep the full 16 MB flash
dump taken before installing OpenWrt (sha256
`208ff9c2f7ade10506e11a0c380e869ad39f9497fb722b55d9aa358c7dd67fa7`); its
`0x30000..0x800000` slice is the stock bank 1 in the layout `tools/flash-uart-ts7022.py`
expects. On v0.1 `mtd erase kernel && reboot` still worked on the RX23302 (the
bootloader restored bank 2), but on the TS-7022 it only leaves the board without a
kernel.

**OpenWrt does not boot:** hold Reset while powering on (~10 s) and send
`…-squashfs-tftp-factory.bin` to 192.168.1.6 over TFTP ([install-tftp.md](install-tftp.md)); no case
opening needed. Fallback: UART, Esc until `<RealTek>`, `tools/flash-uart-ts7022.py`
([install-uart.md](install-uart.md)).

Never send bootloader commands without arguments; answer `(Y)es, (N)o` with `Y` **and** Enter.
