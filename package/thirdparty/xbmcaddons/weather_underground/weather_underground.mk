###############################################################################
#
## Xbmc Weather Underground Addon
#
###############################################################################
WEATHER_UNDERGROUND_VERSION = 46b0703a90fd26d88060c87a27b777534abe8c2b
WEATHER_UNDERGROUND_SOURCE = weather_underground-$(WEATHER_UNDERGROUND_VERSION).tar.gz
WEATHER_UNDERGROUND_SITE = https://github.com/XBMC-Addons/weather.wunderground.git
WEATHER_UNDERGROUND_SITE_METHOD = git
WEATHER_UNDERGROUND_INSTALL_STAGING = NO
WEATHER_UNDERGROUND_INSTALL_TARGET = YES

define WEATHER_UNDERGROUND_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/xbmc/addons/weather.wunderground
	cp -rf $(@D)/* $(TARGET_DIR)/usr/share/xbmc/addons/weather.wunderground/
endef

$(eval $(call xbmc-addon,package/thirdparty/xbmcaddons,weather_underground))
