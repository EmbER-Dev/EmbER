#############################################################
#
# opengl
#
#############################################################

# If value sets "none", report an error
ifeq ($(BR2_PACKAGE_OPENGL_API23),y)
OPENGL_VERSION = apiv23
else ifeq ($(BR2_PACKAGE_OPENGL_API20),y)
OPENGL_VERSION = apiv20
else ifeq ($(BR2_PACKAGE_OPENGL_API19),y)
OPENGL_VERSION = apiv19
else ifeq ($(BR2_PACKAGE_OPENGL_API17),y)
OPENGL_VERSION = apiv17
else ifeq ($(BR2_PACKAGE_OPENGL_API9),y)
OPENGL_VERSION = apiv9
else
OPENGL_VERSION = none
endif

# If API version is not selected, report an error
ifeq ($(OPENGL_VERSION),none)
$(fatal Error: No OpenGL version selected.)
endif

OPENGL_SOURCE=opengl-$(OPENGL_VERSION).tar
OPENGL_SITE=$(TOPDIR)/package/amlogic/opengl/
OPENGL_SITE_METHOD=file
OPENGL_INSTALL_STAGING=YES
OPENGL_INSTALL_TARGET=YES

define OPENGL_INSTALL_STAGING_CMDS
	cp -a $(@D)/* $(STAGING_DIR);
endef

define OPENGL_INSTALL_TARGET_CMDS
	cp -a $(@D)/* $(TARGET_DIR);
endef

$(eval $(generic-package))
