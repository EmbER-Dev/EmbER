###############################################################################
#
## Xbmc Weather Underground Addon
#
###############################################################################
WEATHER_UNDERGROUND_VERSION = f6c0624b695135918fc789a1b1a166a36b2c783a
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
