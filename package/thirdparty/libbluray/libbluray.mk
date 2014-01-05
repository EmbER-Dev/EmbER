#############################################################
#
# libbluray
#
#############################################################
LIBBLURAY_VERSION = 0.5.0
LIBBLURAY_SITE = ftp://ftp.videolan.org/pub/videolan/libbluray/$(LIBBLURAY_VERSION)
LIBBLURAY_SOURCE = libbluray-$(LIBBLURAY_VERSION).tar.bz2
LIBBLURAY_INSTALL_STAGING = YES
LIBBLURAY_INSTALL_TARGET = YES
LIBBLURAY_AUTORECONF = YES

$(eval $(call autotools-package,package/thirdparty,libbluray))
