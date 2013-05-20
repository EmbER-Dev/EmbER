#############################################################
#
# samba
#
#############################################################
SAMBA36_VERSION:=3.6.12
SAMBA36_SOURCE:=samba-$(SAMBA36_VERSION).tar.gz
SAMBA36_SITE:=http://samba.org/samba/ftp/stable

SAMBA36_SUBDIR = source3
#SAMBA36_AUTORECONF = NO

SAMBA36_INSTALL_STAGING = YES
SAMBA36_INSTALL_TARGET = YES


SAMBA36_DEPENDENCIES = \
	$(if $(BR2_ENABLE_LOCALE),,libiconv) \
	$(if $(BR2_PACKAGE_SAMBA36_AVAHI),avahi) \


SAMBA36_CONF_ENV = \
	SMB_BUILD_CC_NEGATIVE_ENUM_VALUES=yes \
	libreplace_cv_READDIR_GETDIRENTRIES=no \
	libreplace_cv_READDIR_GETDENTS=no \
	linux_getgrouplist_ok=no \
	samba_cv_REPLACE_READDIR=no \
	samba_cv_HAVE_WRFILE_KEYTAB=yes \
	samba_cv_HAVE_GETTIMEOFDAY_TZ=yes \
	samba_cv_USE_SETREUID=yes \
	samba_cv_HAVE_KERNEL_OPLOCKS_LINUX=yes \
	samba_cv_HAVE_IFACE_IFCONF=yes \
	samba_cv_HAVE_MMAP=yes \
	samba_cv_HAVE_FCNTL_LOCK=yes \
	samba_cv_HAVE_SECURE_MKSTEMP=yes \
	samba_cv_CC_NEGATIVE_ENUM_VALUES=yes \
	samba_cv_fpie=no \
        samba_cv_have_longlong=yes \
        samba_cv_HAVE_OFF64_T=yes \
	libreplace_cv_HAVE_IPV6=$(if $(BR2_INET_IPV6),yes,no) \
	$(if $(BR2_PACKAGE_SAMBA36_AVAHI),AVAHI_LIBS=-pthread)


SAMBA36_CONF_OPT = \
	--localstatedir=/var \
	--with-piddir=/var/run \
	--with-lockdir=/var/lock \
	--with-logfilebase=/var/log \
	--with-configdir=/etc/samba \
	--with-privatedir=/etc/samba \
	\
	--disable-cups \
	--enable-static \
	--enable-shared \
	--disable-shared-libs \
	--disable-pie \
	--disable-iprint \
	--disable-relro \
	--disable-dnssd \
	\
	$(if $(BR2_PACKAGE_SAMBA36_AVAHI),--enable-avahi,--disable-avahi) \
	\
        --disable-fam \
        --disable-swat \
	--without-cluster-support \
	--without-cifsupcall \
	--without-ads \
	--without-ldap \
	--with-included-popt \
	--with-included-iniparser \
	--without-sys-quotas \
	--without-krb5 \
	--without-automount \
	--without-sendfile-support \
	--with-libiconv=$(STAGING_DIR) \
        --without-cifsmount \
        --without-winbind \

SAMBA36_INSTALL_TARGET_OPT = \
	DESTDIR=$(TARGET_DIR) -C $(SAMBA36_DIR)/$(SAMBA36_SUBDIR) \
	installclientlib

SAMBA36_INSTALL_STAGING_OPT = \
        DESTDIR=$(STAGING_DIR) -C $(SAMBA36_DIR)/$(SAMBA36_SUBDIR) \
        installclientlib

SAMBA36_UNINSTALL_TARGET_OPT = \
	DESTDIR=$(TARGET_DIR) -C $(SAMBA36_DIR)/$(SAMBA36_SUBDIR) \
	uninstallclientlib

SAMBA36_UNINSTALL_STAGING_OPT = \
        DESTDIR=$(STAGING_DIR) -C $(SAMBA36_DIR)/$(SAMBA36_SUBDIR) \
        uninstallclientlib

# non-binaries to remove
SAMBA36_TXTTARGETS_ = \
	usr/include/libsmbclient.h \
	usr/include/netapi.h \
	usr/include/smb_share_modes.h \
	usr/include/talloc.h \
	usr/include/tdb.h \
	usr/include/wbclient.h

define SAMBA36_REMOVE_UNNEEDED_HEADERS
       rm -f $(addprefix $(TARGET_DIR)/, $(SAMBA36_TXTTARGETS_))
endef

SAMBA36_POST_INSTALL_TARGET_HOOKS += SAMBA36_REMOVE_UNNEEDED_HEADERS

define SAMBA36_AUTOGEN
	@$(call MESSAGE,"Reconfiguring")
        ( cd $(@D)/source3 && ./autogen.sh )
endef

#SAMBA36_PRE_CONFIGURE_HOOKS = SAMBA36_AUTOGEN

$(eval $(,utotools-packagepackage/thirdparty,samba36))

#SAMBA36_CONFIGURE_CMDS += && ( cd $(@D)/source3 && make proto )
