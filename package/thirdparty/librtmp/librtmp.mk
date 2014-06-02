#############################################################
#
#librtmp
#
#############################################################
LIBRTMP_VERSION = 79459a2b43f41ac44a2ec001139bcb7b1b8f7497
LIBRTMP_SOURCE = rtmpdump-$(LIBRTMP_VERSION).tar.gz
LIBRTMP_SITE_METHOD = git
LIBRTMP_SITE = git://git.ffmpeg.org/rtmpdump
LIBRTMP_INSTALL_STAGING = YES
LIBRTMP_DEPENDENCIES = openssl

define LIBRTMP_BUILD_CMDS
	sed -ie "s|prefix=/usr/local|prefix=/usr|" $(@D)/librtmp/Makefile
        $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" AR="$(TARGET_AR)" -C $(@D)/librtmp
endef

define LIBRTMP_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/librtmp install DESTDIR=$(STAGING_DIR)
endef

define LIBRTMP_INSTALL_TARGET_CMDS
	install -m 644 $(@D)/librtmp/librtmp.so.1 $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
