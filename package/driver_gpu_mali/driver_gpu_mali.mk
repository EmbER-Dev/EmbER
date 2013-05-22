#############################################################
#
# driver_gpu_mali
#
#############################################################
DRIVER_GPU_MALI_VERSION = 42f8ea44a39726f97681efe81942b4f0a8b4810b
DRIVER_GPU_MALI_SITE = git://github.com/linux-sunxi/sunxi-mali.git
DRIVER_GPU_MALI_INSTALL_STAGING = YES
DRIVER_GPU_MALI_INSTALL_TARGET = YES

define DRIVER_GPU_MALI_INSTALL_STAGING_CMDS
    $(MAKE) -C $(@D) VERSION=r3p0 ABI=armhf prefix=$(STAGING_DIR)/usr/ install
#    $(MAKE) -C $(@D) prefix=$(STAGING_DIR)/usr/ headers
    install -m 666 $(@D)/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0/simple-framework/inc/mali/EGL/fbdev_window.h \
	$(STAGING_DIR)/usr/include/EGL/
    install -m 666 $(@D)/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0/inc/EGL/eglplatform.h \
	$(STAGING_DIR)/usr/include/EGL/
    install -m 666 $(@D)/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0/inc/EGL/eglext.h \
	$(STAGING_DIR)/usr/include/EGL/
endef

define DRIVER_GPU_MALI_INSTALL_TARGET_CMDS
    $(MAKE) -C $(@D) VERSION=r3p0 ABI=armhf prefix=$(TARGET_DIR)/usr/ x11
endef

define DRIVER_GPU_MALI_BUILD_CMDS
    wget -c http://malideveloper.arm.com/downloads/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0.9310_Linux.tar.gz \
	-O $(BUILDROOT_DL_DIR)/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0.9310_Linux.tar.gz
    tar -xzvf $(BUILDROOT_DL_DIR)/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0.9310_Linux.tar.gz -C $(@D)
endef

$(eval $(generic-package))