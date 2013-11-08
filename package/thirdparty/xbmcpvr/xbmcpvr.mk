XBMCPVR_VERSION = 56a77af4e56da9a2658b3748d19bc2db9c491791
XBMCPVR_SITE = git://github.com/opdenkamp/xbmc-pvr-addons.git
XBMCPVR_AUTORECONF = YES
XBMCPVR_INSTALL_STAGING = YES
XBMCPVR_INSTALL_TARGET = YES

XBMCPVR_CONF_ENV += MYSQL_CONFIG=$(TARGET_DIR)/usr/bin/mysql_config
XBMCPVR_CONF_OPT += --enable-addons-with-dependencies

$(eval $(call autotools-package,package/thirdparty,xbmcpvr))

