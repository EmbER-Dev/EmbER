######################
## Pre-built kernel ##
######################

LINUX_VERSION = prebuilt
LINUX_SOURCE = linux-$(LINUX_VERSION).tar.gz
LINUX_SITE = $(call qstrip,$(BR2_PREBUILT_LINUX_PATH))
LINUX_SITE_METHOD = local
LINUX_INSTALL_TARGET = YES

MOD_IN = $(@D)/$(call qstrip,$(BR2_PREBUILT_LINUX_MODS))
MOD_OUT = $(TARGET_DIR)/lib/modules
IMAGE_IN = $(@D)/$(call qstrip,$(BR2_PREBUILT_LINUX_IMAGE))
IMAGE_OUT = $(TOPDIR)/output/images

define MODULE_CMDS
if [ -e $(MOD_OUT) ]; then rm -rf $(MOD_OUT); fi;
 mkdir -p $(MOD_OUT)
 cp -R $(MOD_IN) $(MOD_OUT)
endef

define IMAGE_CMDS
if [ -e $(IMAGE_OUT)/$(call qstrip,$(BR2_PREBUILT_LINUX_IMAGE)) ]; then rm $(IMAGE_OUT)/$(call qstrip,$(BR2_PREBUILT_LINUX_IMAGE)); fi;
 cp $(IMAGE_IN) $(IMAGE_OUT)
endef

define LINUX_INSTALL_TARGET_CMDS
$(call MODULE_CMDS)
$(call IMAGE_CMDS)
endef

$(eval $(generic-package))
