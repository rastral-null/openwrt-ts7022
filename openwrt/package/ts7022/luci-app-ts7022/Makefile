# SPDX-License-Identifier: GPL-2.0-only
#
# luci-app-ts7022 — страница Status -> Thermals для TRANSERV TS-7022.
# Показывает температуру SoC (RTL8197F) и датчики PA обоих диапазонов,
# которые драйвер rtl8192fe отдаёт в /proc/wlanN/mib_rf.
#
# Собственный пакет (не из фида), поэтому luci.mk берётся по пути фида.

include $(TOPDIR)/rules.mk

LUCI_TITLE:=TS-7022 thermal sensors
LUCI_DEPENDS:=+luci-base

PKG_LICENSE:=GPL-2.0-only
PKG_MAINTAINER:=rastral-null

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
