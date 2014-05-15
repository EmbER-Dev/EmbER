###############################################################################
#
## Xbmc NetworkManager Addon
#
###############################################################################
NM_VERSION = 2c38cb0a11eb82ab71856a20f2d23ae0bb4398a9
NM_SOURCE = nm-$(NM_VERSION).tar.gz
NM_SITE = https://github.com/vikjon0/script.linux.nm.git
NM_SITE_METHOD = git
NM_INSTALL_STAGING = NO
NM_INSTALL_TARGET = YES

define NM_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/xbmc/addons/script.linux.nm
	cp -rf $(@D)/* $(TARGET_DIR)/usr/share/xbmc/addons/script.linux.nm/
endef

$(eval $(call xbmc-addon,package/thirdparty/xbmcaddons,nm))
