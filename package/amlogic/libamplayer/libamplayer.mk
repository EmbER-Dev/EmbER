###############################################################################
#
# libamplayer
#
###############################################################################

ifeq ($(BR2_PACKAGE_LIBAMPLAYER_SOURCE),y)
LIBAMPLAYER_VERSION = $(subst ",,$(BR2_PACKAGE_LIBAMPLAYER_SOURCE_VERSION))
else ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
LIBAMPLAYER_VERSION = m1
else ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M3),y)
LIBAMPLAYER_VERSION = m3
else
LIBAMPLAYER_VERSION = m6
endif

LIBAMPLAYER_SOURCE = libamplayer-$(LIBAMPLAYER_VERSION).tar.gz

ifeq ($(BR2_PACKAGE_LIBAMPLAYER_SOURCE),y)
LIBAMPLAYER_SITE = $(subst ",,$(BR2_PACKAGE_LIBAMPLAYER_SOURCE_URL))
else
LIBAMPLAYER_SITE = $(TOPDIR)/package/amlogic/libamplayer/src-$(LIBAMPLAYER_VERSION)
endif

ifeq ($(BR2_PACKAGE_LIBAMPLAYER_SOURCE_GIT),y)
LIBAMPLAYER_SITE_METHOD = git
else ifeq ($(BR2_PACKAGE_LIBAMPLAYER_SOURCE_HG),y)
LIBAMPLAYER_SITE_METHOD = hg
else
LIBAMPLAYER_SITE_METHOD = local
endif

LIBAMPLAYER_INSTALL_STAGING = YES
LIBAMPLAYER_INSTALL_TARGET = YES

ifeq ($(BR2_PACKAGE_LIBAMPLAYER_SOURCE),y)
$(if $(wildcard $(LIBAMPLAYER_SITE)),,$(fatal LibPlayer GIT/Mercurial repository not provided.))
$(if $(wildcard $(LIBAMPLAYER_VERSION)),,$(fatal LibPlayer GIT/Mercurial version not provided.))
endif

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

define LIBAMPLAYER_COMMON_SOURCE_BUILD_CLEANUP
 rm -rf $(STAGING_DIR)/lib/libam*.*
 rm -rf $(STAGING_DIR)/usr/lib/libam*.*
 rm -rf $(TARGET_DIR)/lib/libam*.*
 rm -rf $(TARGET_DIR)/usr/lib/libam*.*
endef

define LIBAMPLAYER_COMMON_BUILD_CMDS
 $(call AMFFMPEG_CONFIGURE_CMDS)
 $(call AMFFMPEG_BUILD_CMDS)
 $(call AMFFMPEG_INSTALL_STAGING_CMDS)
endef

define LIBAMPLAYER_COMMON_SOURCE_BUILD_CMDS
 $(call LIBAMPLAYER_COMMON_BUILD_CMDS)
 if [ -d $(STAGING_DIR)/usr/include/amlplayer ]; then rm -rf $(STAGING_DIR)/usr/include/amlplayer/.*; \
 rm -rf $(STAGING_DIR)/usr/include/amlplayer/*; rmdir $(STAGING_DIR)/usr/include/amlplayer; fi;
 mkdir -p $(STAGING_DIR)/usr/include/amlplayer
 $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" HEADERS_DIR="$(STAGING_DIR)/usr/include/amlplayer" \
  CROSS_PREFIX="$(TARGET_CROSS)" SYSROOT="$(STAGING_DIR)" PREFIX="$(STAGING_DIR)/usr" -C $(@D)/amadec install
 $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" HEADERS_DIR="$(STAGING_DIR)/usr/include/amlplayer" CROSS_PREFIX="$(TARGET_CROSS)" \
  SYSROOT="$(STAGING_DIR)" PREFIX="$(STAGING_DIR)/usr" SRC=$(@D)/amcodec -C $(@D)/amcodec install
 $(MAKE) CROSS="$(TARGET_CROSS)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" PREFIX="$(STAGING_DIR)/usr" \
  SRC="$(@D)/amplayer" -C $(@D)/amplayer
endef

define LIBAMPLAYER_COMMON_PREBUILT_BUILD_CMDS
 $(call LIBAMPLAYER_SETUP_COMMON_PREBUILTS)
 $(call LIBAMPLAYER_COMMON_BUILD_CMDS)
endef

ifeq ($(BR2_PACKAGE_LIBAMPLAYER_PREBUILT),y)
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
define LIBAMPLAYER_BUILD_CMDS
 $(call LIBAMPLAYER_SETUP_M1_PREBUILTS)
 $(call LIBAMPLAYER_COMMON_PREBUILT_BUILD_CMDS)
endef
else
define LIBAMPLAYER_BUILD_CMDS
 $(call LIBAMPLAYER_SETUP_M3_M6_PREBUILTS)
 $(call AMAVUTILS_INSTALL_STAGING_CMDS)
 $(call LIBAMPLAYER_COMMON_PREBUILT_BUILD_CMDS)
endef
endif
else
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
define LIBAMPLAYER_BUILD_CMDS
 $(call LIBAMPLAYER_COMMON_SOURCE_BUILD_CLEANUP)
 $(call LIBAMPLAYER_COMMON_SOURCE_BUILD_CMDS)
endef
else
define LIBAMPLAYER_BUILD_CMDS
 $(call LIBAMPLAYER_COMMON_SOURCE_BUILD_CLEANUP)
 $(call AMAVUTILS_BUILD_CMDS)
 $(call AMAVUTILS_INSTALL_STAGING_CMDS)
 $(call LIBAMPLAYER_COMMON_SOURCE_BUILD_CMDS)
endef
endif
endif

define LIBAMPLAYER_INSTALL_PREBUILT_STAGING_CMDS
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

define LIBAMPLAYER_INSTALL_SOURCE_STAGING_CMDS
 $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" INSTALL_DIR="$(STAGING_DIR)/usr/lib" \
  STAGING="$(STAGING_DIR)/usr" PREFIX="$(STAGING_DIR)/usr" -C $(@D)/amplayer install
 cp -rf $(@D)/amcodec/include/* $(STAGING_DIR)/usr/include
endef

ifeq ($(BR2_PACKAGE_LIBAMPLAYER_PREBUILT),y)
define LIBAMPLAYER_INSTALL_STAGING_CMDS
 $(call LIBAMPLAYER_INSTALL_PREBUILT_STAGING_CMDS)
endef
else
define LIBAMPLAYER_INSTALL_STAGING_CMDS
 $(call LIBAMPLAYER_INSTALL_SOURCE_STAGING_CMDS)
endef
endif

ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M6),y)
FIRMWARE = firmware-m6
else
FIRMWARE = firmware
endif

define LIBAMPLAYER_INSTALL_PREBUILT_COMMON_CMDS
 $(call AMFFMPEG_INSTALL_TARGET_CMDS)
 mkdir -p $(TARGET_DIR)/lib/firmware
 install -m 644 $(@D)/lib/$(FIRMWARE)/*.bin $(TARGET_DIR)/lib/firmware
 mkdir -p $(TARGET_DIR)/usr/lib
 install -m 755 $(@D)/usr/lib/*.so* $(TARGET_DIR)/usr/lib
if [ -e $(TARGET_DIR)/usr/lib/libamcodec.so ]; then rm $(TARGET_DIR)/usr/lib/libamcodec.so; fi;
 cd $(TARGET_DIR)/usr/lib/; ln -s libamcodec.so.0.0 libamcodec.so
 rm -rf $(TARGET_DIR)/usr/lib/libam*.so.prebuilt
endef

define LIBAMPLAYER_INSTALL_SOURCE_COMMON_CMDS
 $(call AMFFMPEG_INSTALL_TARGET_CMDS)
 mkdir -p $(TARGET_DIR)/lib/firmware
 install -m 644 $(@D)/amadec/$(FIRMWARE)/*.bin $(TARGET_DIR)/lib/firmware
 mkdir -p $(TARGET_DIR)/usr/lib
 install -m 755 $(STAGING_DIR)/usr/lib/*.so* $(TARGET_DIR)/usr/lib
if [ -e $(TARGET_DIR)/usr/lib/libamcodec.so ]; then rm $(TARGET_DIR)/usr/lib/libamcodec.so; fi;
 cd $(TARGET_DIR)/usr/lib/; ln -s libamcodec.so.0.0 libamcodec.so
 $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" INSTALL_DIR="$(TARGET_DIR)/usr/lib" \
  STAGING="$(TARGET_DIR)/usr" PREFIX="$(STAGING_DIR)/usr" -C $(@D)/amplayer install
endef

ifeq ($(BR2_PACKAGE_LIBAMPLAYER_PREBUILT),y)
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
define LIBAMPLAYER_INSTALL_TARGET_CMDS
 $(call LIBAMPLAYER_INSTALL_PREBUILT_COMMON_CMDS)
endef
else
define LIBAMPLAYER_INSTALL_TARGET_CMDS
 $(call AMAVUTILS_INSTALL_TARGET_CMDS)
 $(call LIBAMPLAYER_INSTALL_PREBUILT_COMMON_CMDS)
 rm -rf $(TARGET_DIR)/lib/libamavutils.so.prebuilt
endef
endif
else
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
define LIBAMPLAYER_INSTALL_TARGET_CMDS
 $(call LIBAMPLAYER_INSTALL_SOURCE_COMMON_CMDS)
endef
else
define LIBAMPLAYER_INSTALL_TARGET_CMDS
 $(call AMAVUTILS_INSTALL_TARGET_CMDS)
 $(call LIBAMPLAYER_INSTALL_SOURCE_COMMON_CMDS)
endef
endif
endif

$(eval $(call generic-package))
