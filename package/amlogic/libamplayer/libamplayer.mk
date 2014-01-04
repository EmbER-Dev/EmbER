#############################################################
#
# libamplayer
#
#############################################################
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
LIBAMPLAYER_VERSION = m1
else ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M3),y)
LIBAMPLAYER_VERSION = m3
else ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M6),y)
LIBAMPLAYER_VERSION = m6
endif

LIBAMPLAYER_SOURCE = libamplayer-$(LIBAMPLAYER_VERSION).tar.gz
LIBAMPLAYER_SITE = $(TOPDIR)/package/amlogic/libamplayer/src-$(LIBAMPLAYER_VERSION)
LIBAMPLAYER_SITE_METHOD = local
LIBAMPLAYER_INSTALL_STAGING = YES
LIBAMPLAYER_INSTALL_TARGET = YES

ifeq ($(BR2_PACKAGE_LIBAMPLAYER),y)
LIBAMPLAYER_DEPENDENCIES += alsa-lib librtmp pkg-config
AMFFMPEG_DIR = $(BUILD_DIR)/libamplayer-$(LIBAMPLAYER_VERSION)/amffmpeg
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
AMFFMPEG_EXTRA_INCLUDES += -I$(AMFFMPEG_DIR)/../amavutils/include
else
AMAVUTILS_DIR = $(BUILD_DIR)/libamplayer-$(LIBAMPLAYER_VERSION)/amavutils
AMFFMPEG_EXTRA_LDFLAGS += --extra-ldflags="-lamavutils"
endif
endif

define LIBAMPLAYER_SETUP_M1_PREBUILTS
 cp -rf $(@D)/usr/lib/libamcontroler.so.prebuilt $(@D)/usr/lib/libamcontroler.so
endef

define LIBAMPLAYER_SETUP_M3_M6_PREBUILTS
 cp -rf $(@D)/amavutils/libamavutils.so.prebuilt $(@D)/amavutils/libamavutils.so
endef

define LIBAMPLAYER_SETUP_COMMON_PREBUILTS
 cp -rf $(@D)/usr/lib/libamadec.so.prebuilt $(@D)/usr/lib/libamadec.so
 cp -rf $(@D)/usr/lib/libamplayer.so.prebuilt $(@D)/usr/lib/libamplayer.so
endef

define LIBAMPLAYER_COMMON_BUILD_CMDS
 $(call LIBAMPLAYER_SETUP_COMMON_PREBUILTS)
 $(call AMFFMPEG_CONFIGURE_CMDS)
 $(call AMFFMPEG_BUILD_CMDS)
 $(call AMFFMPEG_INSTALL_STAGING_CMDS)
endef

ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
define LIBAMPLAYER_BUILD_CMDS
 $(call LIBAMPLAYER_SETUP_M1_PREBUILTS)
 $(call LIBAMPLAYER_COMMON_BUILD_CMDS)
endef
else
define LIBAMPLAYER_BUILD_CMDS
 $(call LIBAMPLAYER_SETUP_M3_M6_PREBUILTS)
 $(call AMAVUTILS_INSTALL_STAGING_CMDS)
 $(call LIBAMPLAYER_COMMON_BUILD_CMDS)
endef
endif

define LIBAMPLAYER_INSTALL_STAGING_CMDS
 mkdir -p $(STAGING_DIR)/usr/include
 install -m 644 $(@D)/usr/include/*.h $(STAGING_DIR)/usr/include
 mkdir -p $(STAGING_DIR)/usr/include/amlplayer
 install -m 644 $(@D)/usr/include/amlplayer/*.h $(STAGING_DIR)/usr/include/amlplayer
 mkdir -p $(STAGING_DIR)/usr/include/amlplayer/amports
 install -m 644 $(@D)/usr/include/amlplayer/amports/*.h $(STAGING_DIR)/usr/include/amlplayer/amports
 mkdir -p $(STAGING_DIR)/usr/include/amlplayer/ppmgr
 install -m 644 $(@D)/usr/include/amlplayer/ppmgr/*.h $(STAGING_DIR)/usr/include/amlplayer/ppmgr
 cp -rf $(@D)/usr/include/amlplayer/* $(STAGING_DIR)/usr/include
endef

define LIBAMPLAYER_INSTALL_COMMON_CMDS
 $(call AMFFMPEG_INSTALL_TARGET_CMDS)
 mkdir -p $(TARGET_DIR)/lib/firmware
 install -m 644 $(@D)/lib/firmware/*.bin $(TARGET_DIR)/lib/firmware
 mkdir -p $(TARGET_DIR)/usr/lib
 install -m 755 $(@D)/usr/lib/*.so* $(TARGET_DIR)/usr/lib
 rm -rf $(TARGET_DIR)/usr/lib/libam*.so.prebuilt
if [ -e $(TARGET_DIR)/usr/lib/libamcodec.so ]; then rm $(TARGET_DIR)/usr/lib/libamcodec.so; fi;
 cd $(TARGET_DIR)/usr/lib/; ln -s libamcodec.so.0.0 libamcodec.so
endef

ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
define LIBAMPLAYER_INSTALL_TARGET_CMDS
 $(call LIBAMPLAYER_INSTALL_COMMON_CMDS)
endef
else
define LIBAMPLAYER_INSTALL_TARGET_CMDS
 $(call AMAVUTILS_INSTALL_TARGET_CMDS)
 $(call LIBAMPLAYER_INSTALL_COMMON_CMDS)
 rm -rf $(TARGET_DIR)/lib/libamavutils.so.prebuilt
endef
endif

$(eval $(call generic-package))
