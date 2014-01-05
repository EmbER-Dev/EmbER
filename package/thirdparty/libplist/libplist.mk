#############################################################
#
# libplist
#
#############################################################
LIBPLIST_VERSION = 1.10
LIBPLIST_SITE = http://cgit.sukimashita.com/libplist.git/snapshot
LIBPLIST_SOURCE = libplist-$(LIBPLIST_VERSION).tar.gz
LIBPLIST_DEPENDENCIES=libxml2
LIBPLIST_INSTALL_STAGING = YES
LIBPLIST_INSTALL_TARGET = YES
LIBPLIST_MAKE=$(MAKE1)

$(eval $(call cmake-package,package/thirdparty,libplist))
