#############################################################
#
# libass
#
#############################################################
LIBASS_VERSION = 0.10.2
LIBASS_SITE = http://libass.googlecode.com/files
LIBASS_SOURCE = libass-$(LIBASS_VERSION).tar.gz
LIBASS_INSTALL_STAGING = YES
LIBASS_INSTALL_TARGET = YES
LIBASS_DEPENDENCIES += libenca
LIBASS_DEPENDENCIES += fontconfig

$(eval $(call autotools-package,package/thirdparty,libass))
