###############################################################################
#
## Xbmc Yahoo Weather Addon
#
###############################################################################
WEATHER_YAHOO_VERSION = 2.0.3
WEATHER_YAHOO_SOURCE = weather.yahoo-$(WEATHER_YAHOO_VERSION).zip
WEATHER_YAHOO_SITE = http://mirrors.xbmc.org/addons/gotham/weather.yahoo/
WEATHER_YAHOO_INSTALL_STAGING = NO
WEATHER_YAHOO_INSTALL_TARGET = YES

define WEATHER_YAHOO_EXTRACT_CMDS
unzip -q $(DL_DIR)/$(WEATHER_YAHOO_SOURCE) -d $(@D)
endef

define WEATHER_YAHOO_INSTALL_TARGET_CMDS
cp -rf $(@D)/weather.yahoo $(TARGET_DIR)/usr/share/xbmc/addons/
endef

$(eval $(call xbmc-addon,package/thirdparty/xbmcaddons,weather_yahoo))
