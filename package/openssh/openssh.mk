################################################################################
#
# openssh
#
################################################################################

OPENSSH_VERSION = 6.4p1
OPENSSH_SITE = http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
OPENSSH_CONF_ENV = LD="$(TARGET_CC)" LDFLAGS="$(TARGET_CFLAGS)" \
		CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)"
OPENSSH_CONF_OPT = --disable-lastlog --disable-utmp \
		--disable-utmpx --disable-wtmp --disable-wtmpx --disable-strip

OPENSSH_DEPENDENCIES = zlib openssl

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
OPENSSH_DEPENDENCIES += linux-pam
OPENSSH_CONF_OPT += --with-pam
endif

ifneq ($(BR2_PACKAGE_OPENSSH_SFTP_ONLY),y)

define OPENSSH_INSTALL_INITSCRIPT
	$(INSTALL) -D -m 755 package/openssh/S50sshd $(TARGET_DIR)/etc/init.d/S50sshd
endef

OPENSSH_POST_INSTALL_TARGET_HOOKS += OPENSSH_INSTALL_INITSCRIPT

$(eval $(autotools-package))

else

define OPENSSH_CONFIGURE_CMDS
	(cd $(@D) ; ./configure \
		$(OPENSSH_CONF_OPT)	\
		$(OPENSSH_CONF_ENV) \
		--target='$(GNU_TARGET_NAME)' \
		--host='$(GNU_TARGET_NAME)' \
		--build='$(GNU_HOST_NAME)')
endef

define OPENSSH_BUILD_CMDS
	$(MAKE) -C $(@D) sftp-server
endef

define OPENSSH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/sftp-server $(TARGET_DIR)/usr/libexec/sftp-server
endef

$(eval $(generic-package))
endif
