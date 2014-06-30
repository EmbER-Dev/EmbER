################################################################################
#
# libshairplay
#
################################################################################

LIBSHAIRPLAY_VERSION = 139d5ef55564514c31f02dd82cef91236c9ff523
LIBSHAIRPLAY_SITE_METHOD = git
LIBSHAIRPLAY_SITE = git://github.com/juhovh/shairplay.git
LIBSHAIRPLAY_INSTALL_STAGING = YES
LIBSHAIRPLAY_AUTORECONF = YES
LIBSHAIRPLAY_LICENSE = MIT, BSD-3c, LGPLv2.1+
LIBSHAIRPLAY_LICENSE_FILES = LICENSE
LIBSHAIRPLAY_DEPENDENCIES = host-pkgconf $(if $(BR2_PACKAGE_LIBAO),libao)

$(eval $(call autotools-package,package/thirdparty,libshairplay))
