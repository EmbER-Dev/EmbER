#############################################################
#
# libump
#
#############################################################
LIBUMP_VERSION = r3p0-04rel0
LIBUMP_SITE = git://github.com/mortaromarcello/libump.git
LIBUMP_INSTALL_STAGING = YES
LIBUMP_INSTALL_TARGET = YES

define LIBUMP_INSTALL_STAGING_CMDS
    install -d -m 755 $(STAGING_DIR)/usr/include/ump
    install -m 666 $(@D)/include/ump/ump.h $(STAGING_DIR)/usr/include/ump/
    install -m 666 $(@D)/include/ump/ump_debug.h $(STAGING_DIR)/usr/include/ump/
    install -m 666 $(@D)/include/ump/ump_osu.h $(STAGING_DIR)/usr/include/ump/
    install -m 666 $(@D)/include/ump/ump_platform.h $(STAGING_DIR)/usr/include/ump/
    install -m 666 $(@D)/include/ump/ump_ref_drv.h $(STAGING_DIR)/usr/include/ump/
    install -m 666 $(@D)/include/ump/ump_uk_types.h $(STAGING_DIR)/usr/include/ump/
endef

define LIBUMP_INSTALL_TARGET_CMDS
    install -m 755 $(@D)/libUMP.so $(TARGET_DIR)/usr/lib/
    install -m 755 $(@D)/libUMP.a $(TARGET_DIR)/usr/lib/
endef

define LIBUMP_BUILD_CMDS
    $(TARGET_CC) $(TARGET_CFLAGS) -c $(@D)/arch_011_udd/ump_frontend.c -o $(@D)/arch_011_udd/ump_frontend.o -I$(@D)/include
    $(TARGET_CC) $(TARGET_CFLAGS) -c $(@D)/arch_011_udd/ump_ref_drv.c -o $(@D)/arch_011_udd/ump_ref_drv.o -I$(@D)/include
    $(TARGET_CC) $(TARGET_CFLAGS) -fPIC -c $(@D)/arch_011_udd/ump_arch.c -o $(@D)/arch_011_udd/ump_arch.o -I$(@D)/include
    $(TARGET_CC) $(TARGET_CFLAGS) -c $(@D)/os/linux/ump_uku.c -o $(@D)/os/linux/ump_uku.o -I$(@D)/include
    $(TARGET_CC) $(TARGET_CFLAGS) -c $(@D)/os/linux/ump_osu_memory.c -o $(@D)/os/linux/ump_osu_memory.o -I$(@D)/include
    $(TARGET_CC) $(TARGET_CFLAGS) -c $(@D)/os/linux/ump_osu_locks.c -o $(@D)/os/linux/ump_osu_locks.o -I$(@D)/include
    $(TARGET_CC) $(TARGET_CFLAGS) -shared -o $(@D)/libUMP.so \
		    $(@D)/arch_011_udd/ump_frontend.o \
		    $(@D)/arch_011_udd/ump_ref_drv.o \
		    $(@D)/arch_011_udd/ump_arch.o \
		    $(@D)/os/linux/ump_uku.o \
		    $(@D)/os/linux/ump_osu_memory.o \
		    $(@D)/os/linux/ump_osu_locks.o
    $(TARGET_AR) rcs -o $(@D)/libUMP.a \
	    $(@D)/arch_011_udd/ump_frontend.o \
	    $(@D)/arch_011_udd/ump_ref_drv.o \
	    $(@D)/arch_011_udd/ump_arch.o \
	    $(@D)/os/linux/ump_uku.o \
	    $(@D)/os/linux/ump_osu_memory.o \
	    $(@D)/os/linux/ump_osu_locks.o
endef

$(eval $(generic-package))
