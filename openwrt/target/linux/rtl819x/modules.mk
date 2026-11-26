# SPDX-License-Identifier: GPL-2.0-only
#
# Модуль вендорского драйвера Wi-Fi (RTL8197F 2.4 ГГц + RTL8812FE 5 ГГц).
# Сам драйвер лежит в files-6.18/drivers/net/wireless/rtl8192fe и собирается
# как часть дерева ядра (CONFIG_RTL8192FE_RX23302=m). Без этого описания
# rtl8192cd.ko собирается, но в образ не попадает - OpenWrt кладёт в rootfs
# только модули, объявленные через KernelPackage.

define KernelPackage/rtl8192cd
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek RTL8192FE/RTL8812FE vendor Wi-Fi driver
  DEPENDS:=@TARGET_rtl819x
  FILES:=$(LINUX_DIR)/drivers/net/wireless/rtl8192fe/rtl8192cd.ko
  AUTOLOAD:=$(call AutoLoad,60,rtl8192cd)
endef

define KernelPackage/rtl8192cd/description
 Vendor Wi-Fi driver for the RTL8197F built-in 2.4 GHz radio and the
 RTL8812FE 5 GHz PCIe radio.
endef

$(eval $(call KernelPackage,rtl8192cd))