###############################################################################
#
## Xbmc Open Subtitles Addon
#
###############################################################################
OPENSUBTITLES_VERSION = a5e1a9decd520e73b8e52b30ebb0008f0e556684
OPENSUBTITLES_SOURCE = opensubtitles-$(OPENSUBTITLES_VERSION).tar.gz
OPENSUBTITLES_SITE = https://github.com/amet/service.subtitles.opensubtitles.git
OPENSUBTITLES_SITE_METHOD = git
OPENSUBTITLES_INSTALL_STAGING = NO
OPENSUBTITLES_INSTALL_TARGET = YES

define OPENSUBTITLES_INSTALL_TARGET_CMDS
	cp -rf $(@D)/service.subtitles.opensubtitles $(TARGET_DIR)/usr/share/xbmc/addons/
endef

$(eval $(call xbmc-addon,package/thirdparty/xbmcaddons,opensubtitles))
