#############################################################
#
#librtmp
#
#############################################################
LIBRTMP_VERSION = a9f353c7ccf29d6305e13fedb77653b8681e9fc2
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
