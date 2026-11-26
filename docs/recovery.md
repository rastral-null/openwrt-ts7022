# Восстановление и возврат на заводскую прошивку / Recovery and return to stock

> **RU** ниже, **EN** — в конце.

> ⚠️ **Процедуры возврата на сток унаследованы от порта ELECTRA RX23302 и на
> TRANSERV TS-7022 отдельно не проверялись.** Сама разметка флеша ниже взята из
> реального лога загрузки TS-7022 (см. README), но копирование банков и команда
> возврата на сток проверены только на RX23302. Заводская копия во втором банке
> прошивкой OpenWrt не затирается — путь назад есть, но считайте его вероятным,
> а не гарантированным.

## Разметка флеша (16 МБ, XM25QH128C)

Данные из реального лога загрузки TS-7022 (`/proc/mtd`):

| Смещение | Размер | Раздел | Что там |
|---|---|---|---|
| 0x000000 | 0x030000 | boot | загрузчик Realtek и заводские настройки платы (MAC, калибровка) — **не трогать никогда** |
| 0x030000 | 0x240000 | kernel | ядро OpenWrt |
| 0x270000 | 0x390000 | rootfs | корневая система OpenWrt |
| 0x600000 | 0x1A0000 | rootfs_data | настройки OpenWrt (overlay) |
| 0x7A0000 | 0x060000 | cfg | раздел настроек заводской прошивки, только чтение |
| 0x800000 | 0x800000 | stock | **банк 2: заводская прошивка, OpenWrt его не трогает** |

Отличие от RX23302: у TS-7022 ядро занимает `0x30000..0x270000`, а корневая
система начинается с `0x270000` (у RX23302 — `0x2d0000`/`0x300000`), и подпись
ядра — `KM70`, а не `KE32`.

Заводская прошивка — dual-image: два банка по 8 МБ. OpenWrt пишется только в
банк 1, заводская копия в банке 2 (с `0x800000`) остаётся нетронутой.

## Как загрузчик защищает от кирпича

При каждом включении загрузчик проверяет банк 1 (заголовок ядра и сумму rootfs).
Если банк 1 негоден, он **сам копирует банк 2 в банк 1** и загружает заводскую
прошивку:

```
Checking bank2...
Flash read from 00830000 to 80800000 with 007D0000 bytes ?
Flash Program from 80800000 to 00030000 with 007D0000 bytes ?
Copy bank2 to bank1 successfully!
Jump to image start=0x80a00000...
Linux version 3.10.90-pre5 (abudeev@honor) ...
```

*(лог с RX23302, 20.10.2026; на TS-7022 смещения банка 2 и подпись ядра могут
отличаться — см. предупреждение выше)*

Поэтому:
- оборванная прошивка (выключили свет во время sysupgrade) — роутер поднимется
  на **заводской** прошивке, а не превратится в кирпич;
- возврат на сток делается одной командой (ниже).

## Вернуть заводскую прошивку (проверено на RX23302 20.10.2026; на TS-7022 — нет)

Из OpenWrt (SSH или UART):

```sh
mtd erase kernel && reboot
```

Загрузчик не найдёт ядра в банке 1, скопирует заводскую прошивку из банка 2 и
загрузит её (копирование ~1–2 мин, потом обычная загрузка стока). UART для этого
**не нужен**.

Проверено на RX23302: после возврата банк 1 побайтно совпадал с заводским дампом
флеша, загрузчик и заводские настройки платы не тронуты. На TS-7022 эта команда
отдельно не проверялась.

> Заводская прошивка поднимет свои заводские настройки (раздел `cfg` OpenWrt не
> трогает). Хотите вернуть ещё и их — сделайте сброс кнопкой Reset на стоке.

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
> below comes from a real TS-7022 boot log (see README), but the bank copy and the
> return-to-stock command were only verified on the RX23302. The stock copy in the
> second bank is not written by OpenWrt — there is a way back, but treat it as
> likely, not guaranteed.

**Flash layout (16 MB):** see the table above. TS-7022 kernel occupies
`0x30000..0x270000`, rootfs starts at `0x270000` (RX23302 used
`0x2d0000`/`0x300000`), and the kernel signature is `KM70`, not `KE32`. OpenWrt
lives in bank 1; the **stock firmware in bank 2 (from 0x800000) is never written**.
The bootloader (0x0–0x30000) is never written.

**Brick protection:** on every boot the bootloader validates bank 1 (kernel header
and rootfs checksum). If bank 1 is invalid it **copies bank 2 over bank 1 by
itself** and boots the stock firmware (`Copy bank2 to bank1 successfully!`, real
log above — from RX23302). An interrupted sysupgrade therefore ends in stock
firmware, not a brick.

**Return to stock (verified on RX23302 2026-10-20, not verified on TS-7022):** from
OpenWrt run

```sh
mtd erase kernel && reboot
```

The bootloader restores the stock firmware from bank 2 (~1–2 min) and boots it. No
UART needed. On the RX23302, after the restore bank 1 matched the original stock
flash dump byte for byte.

**OpenWrt does not boot:** hold Reset while powering on (~10 s) and send
`…-squashfs-tftp-factory.bin` to 192.168.1.6 over TFTP ([install-tftp.md](install-tftp.md)); no case
opening needed. Fallback: UART, Esc until `<RealTek>`, `tools/flash-uart-ts7022.py`
([install-uart.md](install-uart.md)).

Never send bootloader commands without arguments; answer `(Y)es, (N)o` with `Y` **and** Enter.
