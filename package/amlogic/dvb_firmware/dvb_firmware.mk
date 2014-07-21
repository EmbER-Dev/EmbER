###############################################################################
#
## USB DVB Firmwares
#
###############################################################################
DVB_FIRMWARE_VERSION = 1.0
DVB_FIRMWARE_SOURCE = dvb-firmwares.tar.bz2
DVB_FIRMWARE_SITE = http://linuxtv.org/downloads/firmware/
DVB_FIRMWARE_INSTALL_STAGING = NO
DVB_FIRMWARE_INSTALL_TARGET = YES

define DVB_FIRMWARE_EXTRACT_CMDS
	tar xjf $(DL_DIR)/$(DVB_FIRMWARE_SOURCE) -C $(@D)
endef

define DVB_FIRMWARE_INSTALL_TARGET_CMDS
	if [ ! -d $(TARGET_DIR)/lib/firmware ]; then  mkdir -p $(TARGET_DIR)/lib/firmware ; fi
	cp -rf $(@D)/* $(TARGET_DIR)/lib/firmware
endef

$(eval $(call generic-package))
