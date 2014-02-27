#############################################################
#
# tar + squashfs to archive target filesystem
#
#############################################################

ROOTFS_RECOVERY_AML_DEPENDENCIES = linux rootfs-tar_aml host-python

RECOVERY_AML_ARGS = -b '$(BR2_TARGET_ROOTFS_RECOVERY_AML_BOARDNAME)'
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_WIPE_USERDATA),y)
  RECOVERY_AML_ARGS += -w
endif
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_WIPE_USERDATA_CONDITIONAL),y)
  RECOVERY_AML_ARGS += -c
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_RECOVERY_BOOTLOADER_IMG)),"")

# Check if bootloader.img exists
  $(if $(wildcard $(BR2_TARGET_ROOTFS_RECOVERY_BOOTLOADER_IMG)),,$(fatal bootloader.img does not exist (Path: $(BR2_TARGET_ROOTFS_RECOVERY_BOOTLOADER_IMG)).))

  
  RECOVERY_AML_ARGS += -u
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_RECOVERY_RECOVERY_IMG)),"")

# Check if recovery.img exists
  $(if $(wildcard $(BR2_TARGET_ROOTFS_RECOVERY_RECOVERY_IMG)),,$(fatal recovery.img does not exist (Path: $(BR2_TARGET_ROOTFS_RECOVERY_RECOVERY_IMG)).))

  
  RECOVERY_AML_ARGS += -r
endif

# Introduce imgpack
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_IMGPACK), y)

# We set folder for res_pack resources
ifneq ($(strip $(BR2_TARGET_ROOTFS_RECOVERY_AML_IMGPACK_CUSTOM)),"")
RES_PACK = $(BR2_TARGET_ROOTFS_RECOVERY_AML_IMGPACK_CUSTOM)
else
RES_PACK = fs/recovery_aml/logos/mx_res_pack
endif

# Check if AML_IMGPACK folder exists
$(if $(wildcard $(RES_PACK)),,$(fatal RES_PACK=$(RES_PACK), folder does not exist.))

endif

# Check for UPDATE_ZIP_PREFIX to override file name
# Default is to use boardname
ifneq ($(strip $(BR2_TARGET_ROOTFS_RECOVERY_AML_UPDATE_ZIP_PREFIX)),"")
    UPDATE_ZIP_PREFIX = $(BR2_TARGET_ROOTFS_RECOVERY_AML_UPDATE_ZIP_PREFIX)
else
    UPDATE_ZIP_PREFIX = $(BR2_TARGET_ROOTFS_RECOVERY_AML_BOARDNAME)
endif

ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_UPDATE_IMG),y)
  UPDATE_FORMAT = img
else
  UPDATE_FORMAT = zip
endif

ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_UPDATE_ZIP_NAME_FULL_DATETIME),y)
  UPDATE_ZIP = $(UPDATE_ZIP_PREFIX)-$(shell date -u %0d%^b%Y-%H%M%S)-update.$(UPDATE_FORMAT)
endif
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_UPDATE_ZIP_NAME_SHORT_DATE),y)
  UPDATE_ZIP = $(UPDATE_ZIP_PREFIX)-$(shell date -u +%Y%m%d)-update.$(UPDATE_FORMAT)
endif
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_UPDATE_ZIP_NAME_BOARDNAME_UPDATE_ZIP),y)
  UPDATE_ZIP = $(UPDATE_ZIP_PREFIX)-update.$(UPDATE_FORMAT)
endif
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_UPDATE_ZIP_NAME_UPDATE_ZIP),y)
  UPDATE_ZIP = update.$(UPDATE_FORMAT)
endif
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_UPDATE_ZIP_NAME_CUSTOM),y)
  UPDATE_ZIP = $(BR2_TARGET_ROOTFS_RECOVERY_AML_UPDATE_ZIP_NAME_CUSTOM_STRING)-update.$(UPDATE_FORMAT)
endif

ROOTFS_RECOVERY_AML_CMD = \
    mkdir -p $(BINARIES_DIR)/aml_recovery/system &&

# If we use imgpack, append ROOTFS_RECOVERY_AML_CMD with aditional commands
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_IMGPACK),y)

ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_IMGPACK_1225),y)
IMGPACK = imgpack-1225
else
IMGPACK = imgpack
endif

ROOTFS_RECOVERY_AML_CMD += \
    echo "Creating logo.img..." && \
    fs/recovery_aml/$(IMGPACK) -r $(RES_PACK) $(BINARIES_DIR)/aml_recovery/logo.img && 

else

ifneq ($(strip $(BR2_TARGET_ROOTFS_RECOVERY_AML_LOGO)),"")
AML_LOGO = $(BR2_TARGET_ROOTFS_RECOVERY_AML_LOGO)
else
AML_LOGO = fs/recovery_aml/logos/mx_logo.img
endif

# Check if AML_LOGO exists
$(if $(wildcard $(AML_LOGO)),,$(fatal AML_LOGO=$(AML_LOGO), file does not exist.))

endif

# Aditional files to be included in package, by default only logo.img
ADDITIONAL_FILES = logo.img

###### Advanced options ######

# Memory type
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_ADV_EMMC),y)
RECOVERY_AML_ARGS += -m EMMC
else ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_ADV_MTD),y)
RECOVERY_AML_ARGS += -m MTD
else
RECOVERY_AML_ARGS += -m UBI
endif

# File system for system and data partitions
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_ADV_FS_EXT4),y)
RECOVERY_AML_ARGS += -f ext4
PARTITION_TYPE = ext4
else ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_ADV_FS_YAFFS2),y)
RECOVERY_AML_ARGS += -f yaffs2
ifneq ($(BR2_BOARD_TYPE_AMLOGIC_M6),y)
PARTITION_TYPE = legacy_yaffs2
else
PARTITION_TYPE = yaffs2
endif
else
RECOVERY_AML_ARGS += -f ubifs
PARTITION_TYPE = ubifs
endif

# Path to logo partition in recovery
RECOVERY_AML_ARGS += -l $(BR2_TARGET_ROOTFS_RECOVERY_AML_ADV_PATH_LOGO)

# Path to system partition in recovery
RECOVERY_AML_ARGS += -s $(BR2_TARGET_ROOTFS_RECOVERY_AML_ADV_PATH_SYSTEM)

# Path to data partition in recovery
RECOVERY_AML_ARGS += -d $(BR2_TARGET_ROOTFS_RECOVERY_AML_ADV_PATH_DATA)

# Check if NFTL partition exists, if it does provide path (without leading partition no)
ifeq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_ADV_NFTL),y)
RECOVERY_AML_ARGS += -n $(BR2_TARGET_ROOTFS_RECOVERY_AML_ADV_NFTL_PATH)
else
RECOVERY_AML_ARGS += -n none
endif

###### Advanced options ######

# If we have provided bootloader.img, make sure it's included in update.zip
ifneq ($(strip $(BR2_TARGET_ROOTFS_RECOVERY_BOOTLOADER_IMG)),"")

ROOTFS_RECOVERY_AML_CMD += \
    echo "Copy bootloader.img..." && \
    cp -f $(BR2_TARGET_ROOTFS_RECOVERY_BOOTLOADER_IMG) $(BINARIES_DIR)/aml_recovery/bootloader.img && 

ADDITIONAL_FILES += " bootloader.img"
endif

# If we have provided recovery.img, make sure it's included in update.zip
ifneq ($(strip $(BR2_TARGET_ROOTFS_RECOVERY_RECOVERY_IMG)),"")

ROOTFS_RECOVERY_AML_CMD += \
    echo "Copy recovery.img..." && \
    cp -f $(BR2_TARGET_ROOTFS_RECOVERY_RECOVERY_IMG) $(BINARIES_DIR)/aml_recovery/recovery.img && 

ADDITIONAL_FILES += " recovery.img"
endif

ROOTFS_RECOVERY_AML_CMD += \
    tar -C $(BINARIES_DIR)/aml_recovery/system -xf $(BINARIES_DIR)/rootfs.tar && \
    sed -i -f fs/recovery_aml/$(PARTITION_TYPE).sed $(BINARIES_DIR)/aml_recovery/system/etc/init.d/S10setup && \
    mkdir -p $(BINARIES_DIR)/aml_recovery/META-INF/com/google/android/ && \
    PYTHONDONTWRITEBYTECODE=1 $(HOST_DIR)/usr/bin/python fs/recovery_aml/android_scriptgen $(RECOVERY_AML_ARGS) -i -p $(BINARIES_DIR)/aml_recovery/system -o \
     $(BINARIES_DIR)/aml_recovery/META-INF/com/google/android/updater-script && \
    cp -f fs/recovery_aml/update-binary $(BINARIES_DIR)/aml_recovery/META-INF/com/google/android/ &&

ifneq ($(BR2_TARGET_ROOTFS_RECOVERY_AML_IMGPACK),y)
ROOTFS_RECOVERY_AML_CMD += \
    cp -f $(AML_LOGO) $(BINARIES_DIR)/aml_recovery/logo.img &&
endif

ifneq ($(qstrip $(BR2_TARGET_ROOTFS_RECOVERY_AML_APPEND_INITRD)),)

ROOTFS_RECOVERY_AML_CMD += \
    echo "Appending initramfs to kernel..." && \
    cd $(RECOVERY_AML_BUILDROOT_ROOT)/$(BR2_TARGET_ROOTFS_RECOVERY_AML_APPEND_INITRD)/ && \
    find . | cpio -o --format=newc | gzip > $(BINARIES_DIR)/aml_recovery/ramdisk-new.gz && \
    cd $(RECOVERY_AML_BUILDROOT_ROOT) && \
    fs/recovery_aml/mkbootimg --kernel $(BINARIES_DIR)/uImage --ramdisk $(BINARIES_DIR)/aml_recovery/ramdisk-new.gz -o $(BINARIES_DIR)/aml_recovery/uImage && \
    cp -f $(BINARIES_DIR)/aml_recovery/uImage $(BINARIES_DIR)/kernel &&  
else

ROOTFS_RECOVERY_AML_CMD += \
    cp -f $(BINARIES_DIR)/uImage $(BINARIES_DIR)/aml_recovery/ &&

endif

ROOTFS_RECOVERY_AML_CMD += \
    find $(BINARIES_DIR)/aml_recovery/system/ -type l -delete && \
    find $(BINARIES_DIR)/aml_recovery/system/ -type d -empty -exec sh -c 'echo "dummy" > "{}"/.empty' \; && \
    pushd $(BINARIES_DIR)/aml_recovery/ >/dev/null && \
    zip -m -q -r -y $(BINARIES_DIR)/aml_recovery/update-unsigned.zip $(ADDITIONAL_FILES) uImage META-INF system && \
    popd >/dev/null && \
    echo "Signing $(UPDATE_ZIP)..." && \
    pushd fs/recovery_aml/ >/dev/null; java -Xmx1024m -jar signapk.jar -w testkey.x509.pem testkey.pk8 $(BINARIES_DIR)/aml_recovery/update-unsigned.zip '$(BINARIES_DIR)/$(UPDATE_ZIP)' && \
    rm -rf $(BINARIES_DIR)/aml_recovery; rm -f $(TARGET_DIR)/usr.sqsh

$(eval $(call ROOTFS_TARGET,recovery_aml))
