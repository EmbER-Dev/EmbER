###############################################################################
#
## Xbmc Open Subtitles Addon
#
###############################################################################
OPENSUBTITLES_VERSION = 3e554d89ed6cca26438dc11c3e30b8cf50978a71
OPENSUBTITLES_SOURCE = opensubtitles-$(OPENSUBTITLES_VERSION).tar.gz
OPENSUBTITLES_SITE = https://github.com/amet/service.subtitles.opensubtitles.git
OPENSUBTITLES_SITE_METHOD = git
OPENSUBTITLES_INSTALL_STAGING = NO
OPENSUBTITLES_INSTALL_TARGET = YES

define OPENSUBTITLES_INSTALL_TARGET_CMDS
	cp -rf $(@D)/service.subtitles.opensubtitles $(TARGET_DIR)/usr/share/xbmc/addons/
endef

$(eval $(call xbmc-addon,package/thirdparty/xbmcaddons,opensubtitles))
