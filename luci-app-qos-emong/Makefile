# 
# Copyright (C) 2006-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-qos-emong
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-qos-emong
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  DEPENDS:=+tc +iptables-mod-conntrack +iptables-mod-conntrack-extra +iptables-mod-filter +iptables-mod-ipopt +iptables-mod-nat +kmod-sched +iptables-mod-iprange +iptables-mod-hashlimit +iptables-mod-connlimit
  TITLE:=luci-app-qos-emong
  URL:=http://sutuo.tk/luci-app-qos-emong.ipk
  PKGARCH:=all
endef

define Package/luci-app-qos-emong/description
   luci-app-qos-emong  by sutuo QQ270204069.
endef



define Package/luci-app-qos-emong/postinst
#!/bin/sh 
[ -n "$${IPKG_INSTROOT}" ] || {
	( . /etc/uci-defaults/luci-qos-emong ) && rm -f /etc/uci-defaults/luci-qos-emong
	/etc/init.d/qos-emong enable
	exit 0
}
endef

define Package/luci-app-qos-emong/conffiles
  /etc/config/qos-emong
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-qos-emong/install
	$(INSTALL_DIR) $(1)
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,luci-app-qos-emong))
