#############################################################
#
# broadcom wifi support
#
#############################################################
BROADCOM_VERSION = aml
BROADCOM_SOURCE = broadcom-$(BROADCOM_VERSION)-firmware.tar.gz
BROADCOM_SITE = $(TOPDIR)/package/amlogic/broadcom/src
BROADCOM_SITE_METHOD = local
BROADCOM_INSTALL_STAGING = NO
BROADCOM_INSTALL_TARGET = YES

define BROADCOM_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/init.d
	if [ -d $(TARGET_DIR)/etc/wifi ]; then rm -rf $(TARGET_DIR)/etc/wifi ; fi
	mkdir -p $(TARGET_DIR)/etc/wifi/4330
	mkdir $(TARGET_DIR)/etc/wifi/40181
	mkdir $(TARGET_DIR)/etc/wifi/40183
	mkdir $(TARGET_DIR)/etc/wifi/ap62x2
	mkdir $(TARGET_DIR)/etc/wifi/ap6181
	mkdir $(TARGET_DIR)/etc/wifi/ap6210
	mkdir $(TARGET_DIR)/etc/wifi/ap6330
	mkdir $(TARGET_DIR)/etc/wifi/ap6476
	mkdir $(TARGET_DIR)/etc/wifi/ap6493
	install -m 755 $(@D)/S60wifi $(TARGET_DIR)/etc/init.d
	install -m 644 $(@D)/firmware/4330/* $(TARGET_DIR)/etc/wifi/4330
	install -m 644 $(@D)/firmware/40181/* $(TARGET_DIR)/etc/wifi/40181
	install -m 644 $(@D)/firmware/40183/* $(TARGET_DIR)/etc/wifi/40183
	install -m 644 $(@D)/firmware/ap62x2/* $(TARGET_DIR)/etc/wifi/ap62x2
	install -m 644 $(@D)/firmware/ap6181/* $(TARGET_DIR)/etc/wifi/ap6181
	install -m 644 $(@D)/firmware/ap6210/* $(TARGET_DIR)/etc/wifi/ap6210
	install -m 644 $(@D)/firmware/ap6330/* $(TARGET_DIR)/etc/wifi/ap6330
	install -m 644 $(@D)/firmware/ap6476/* $(TARGET_DIR)/etc/wifi/ap6476
	install -m 644 $(@D)/firmware/ap6493/* $(TARGET_DIR)/etc/wifi/ap6493
endef

$(eval $(call generic-package))
