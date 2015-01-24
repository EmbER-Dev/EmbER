###############################################################################
#
## Kodi Open Subtitles Addon
#
###############################################################################
OPENSUBTITLES_VERSION = 0e3f3f6dff76cd2e94c14b441ece2660e2fc37da
OPENSUBTITLES_SOURCE = opensubtitles-$(OPENSUBTITLES_VERSION).tar.gz
OPENSUBTITLES_SITE = https://github.com/amet/service.subtitles.opensubtitles.git
OPENSUBTITLES_SITE_METHOD = git
OPENSUBTITLES_INSTALL_STAGING = NO
OPENSUBTITLES_INSTALL_TARGET = YES

define OPENSUBTITLES_INSTALL_TARGET_CMDS
	cp -rf $(@D)/service.subtitles.opensubtitles $(TARGET_DIR)/usr/share/kodi/addons/
endef

$(eval $(call kodi-addon,package/thirdparty/kodiaddons,opensubtitles))
