#############################################################
#
# libnfs
#
#############################################################
LIBNFS_VERSION = 1e7a5136dec5673bd3612a06b11ce2afaf8cf31a
LIBNFS_SITE = git://github.com/sahlberg/libnfs.git
LIBNFS_INSTALL_STAGING = YES
LIBNFS_INSTALL_TARGET = YES
LIBNFS_AUTORECONF = YES
LIBNFS_MAKE=$(MAKE1)
LIBNFS_CONF_OPT+= --enable-examples
LIBNFS_DEPENDENCIES += popt

define LIBNFS_INSTALL_EXAMPLES
$(INSTALL) -m 755 $(@D)/examples/nfsclient-async $(TARGET_DIR)/usr/bin/nfsclient-async
$(INSTALL) -m 755 $(@D)/examples/nfsclient-sync $(TARGET_DIR)/usr/bin/nfsclient-sync
$(INSTALL) -m 755 $(@D)/examples/nfsclient-raw $(TARGET_DIR)/usr/bin/nfsclient-raw
$(INSTALL) -m 755 $(@D)/examples/nfsclient-bcast $(TARGET_DIR)/usr/bin/nfsclient-bcast
$(INSTALL) -m 755 $(@D)/examples/nfsclient-listservers $(TARGET_DIR)/usr/bin/nfsclient-listservers
endef
LIBNFS_POST_INSTALL_TARGET_HOOKS += LIBNFS_INSTALL_EXAMPLES

$(eval $(call autotools-package,package/thirdparty,libnfs))
