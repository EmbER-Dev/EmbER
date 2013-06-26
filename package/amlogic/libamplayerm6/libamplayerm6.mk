#############################################################
#
# libamplayer
#
#############################################################
LIBAMPLAYERM6_VERSION=5b1324b964c7f289d0ac05cb69b937d3d9c9cf55
LIBAMPLAYERM6_SITE=git://github.com/wjb/libamplayer-m6.git
LIBAMPLAYERM6_INSTALL_STAGING=YES
LIBAMPLAYERM6_INSTALL_TARGET=YES
LIBAMPLAYERM6_SITE_METHOD=git

FIRMWARE_FOLDER=firmware-m6

ifeq ($(BR2_PACKAGE_LIBAMPLAYERM6),y)
# actually required for amavutils and amffmpeg
LIBAMPLAYERM6_DEPENDENCIES += alsa-lib librtmp pkg-config
AMFFMPEG_DIR = $(BUILD_DIR)/libamplayerm6-$(LIBAMPLAYERM6_VERSION)/amffmpeg
AMAVUTILS_DIR = $(BUILD_DIR)/libamplayerm6-$(LIBAMPLAYERM6_VERSION)/amavutils
AMFFMPEG_EXTRA_LDFLAGS += --extra-ldflags="-lamavutils"
endif

define LIBAMPLAYERM6_BUILD_CMDS
 $(call AMAVUTILS_BUILD_CMDS)
 $(call AMAVUTILS_INSTALL_STAGING_CMDS)
 $(call AMFFMPEG_CONFIGURE_CMDS)
 $(call AMFFMPEG_BUILD_CMDS)
 $(call AMFFMPEG_INSTALL_STAGING_CMDS)

 mkdir -p $(STAGING_DIR)/usr/include/amlplayer
 $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" HEADERS_DIR="$(STAGING_DIR)/usr/include/amlplayer" \
  CROSS_PREFIX="$(TARGET_CROSS)" SYSROOT="$(STAGING_DIR)" PREFIX="$(STAGING_DIR)/usr" -C $(@D)/amadec install
 $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" HEADERS_DIR="$(STAGING_DIR)/usr/include/amlplayer" CROSS_PREFIX="$(TARGET_CROSS)" \
  SYSROOT="$(STAGING_DIR)" PREFIX="$(STAGING_DIR)/usr" SRC=$(@D)/amcodec -C $(@D)/amcodec install
 $(MAKE) CROSS="$(TARGET_CROSS)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" PREFIX="$(STAGING_DIR)/usr" \
  SRC="$(@D)/amplayer" -C $(@D)/amplayer
endef

define LIBAMPLAYERM6_INSTALL_STAGING_CMDS
 $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" INSTALL_DIR="$(STAGING_DIR)/usr/lib" \
  STAGING="$(STAGING_DIR)/usr" PREFIX="$(STAGING_DIR)/usr" -C $(@D)/amplayer install

 #temporary, until we sync with mainline xbmc
 cp -rf $(@D)/amcodec/include/* $(STAGING_DIR)/usr/include
endef

define LIBAMPLAYERM6_INSTALL_TARGET_CMDS
 $(call AMAVUTILS_INSTALL_TARGET_CMDS)
 $(call AMFFMPEG_INSTALL_TARGET_CMDS)

 mkdir -p $(TARGET_DIR)/lib/firmware
 cp -rf $(@D)/amadec/$(FIRMWARE_FOLDER)/*.bin $(TARGET_DIR)/lib/firmware
 cp -f $(STAGING_DIR)/usr/lib/libamadec.so $(TARGET_DIR)/usr/lib/

 cp -f $(STAGING_DIR)/usr/lib/libamcodec.so.* $(TARGET_DIR)/usr/lib/
 cd $(TARGET_DIR)/usr/lib/; ln -s libamcodec.so.0.0 libamcodec.so
 cp -f $(STAGING_DIR)/usr/lib/libamplayer.so $(TARGET_DIR)/usr/lib/
 $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" INSTALL_DIR="$(TARGET_DIR)/usr/lib" \
  STAGING="$(TARGET_DIR)/usr" PREFIX="$(STAGING_DIR)/usr" -C $(@D)/amplayer install
endef

$(eval $(call generic-package))
