#############################################################
#
# opengl
#
#############################################################
OPENGL_VERSION:=0.9.9
OPENGL_SOURCE=opengl-$(AMADEC_VERSION).tar.gz
OPENGL_SITE=$(TOPDIR)/package/amlogic/opengl/src
OPENGL_SITE_METHOD=local
OPENGL_INSTALL_STAGING=YES
OPENGL_INSTALL_TARGET=YES

define OPENGL_INSTALL_STAGING_CMDS
	find $(@D)/lib-m6 -type f -exec install -m 644 {} $(STAGING_DIR)/usr/lib \;
	cd $(STAGING_DIR)/usr/lib; ln -f -s libMali.so libEGL.so.1.4
	cd $(STAGING_DIR)/usr/lib; ln -f -s libEGL.so.1.4 libEGL.so.1
	cd $(STAGING_DIR)/usr/lib; ln -f -s libEGL.so.1 libEGL.so 
	cd $(STAGING_DIR)/usr/lib; ln -f -s libMali.so libGLESv1_CM.so.1.1
	cd $(STAGING_DIR)/usr/lib; ln -f -s libGLESv1_CM.so.1.1 libGLESv1_CM.so.1
	cd $(STAGING_DIR)/usr/lib; ln -f -s libGLESv1_CM.so.1 libGLESv1_CM.so
	cd $(STAGING_DIR)/usr/lib; ln -f -s libMali.so libGLESv2.so.2.0
	cd $(STAGING_DIR)/usr/lib; ln -f -s libGLESv2.so.2.0 libGLESv2.so.2
	cd $(STAGING_DIR)/usr/lib; ln -f -s libGLESv2.so.2 libGLESv2.so
	cp -rf  $(@D)/include/* $(STAGING_DIR)/usr/include
endef

define OPENGL_INSTALL_TARGET_CMDS
	find $(@D)/lib-m6 -type f -exec install -m 644 {} $(TARGET_DIR)/usr/lib \;
	cd $(TARGET_DIR)/usr/lib; ln -f -s libMali.so libEGL.so.1.4
	cd $(TARGET_DIR)/usr/lib; ln -f -s libEGL.so.1.4 libEGL.so.1
	cd $(TARGET_DIR)/usr/lib; ln -f -s libEGL.so.1 libEGL.so 
	cd $(TARGET_DIR)/usr/lib; ln -f -s libMali.so libGLESv1_CM.so.1.1
	cd $(TARGET_DIR)/usr/lib; ln -f -s libGLESv1_CM.so.1.1 libGLESv1_CM.so.1
	cd $(TARGET_DIR)/usr/lib; ln -f -s libGLESv1_CM.so.1 libGLESv1_CM.so
	cd $(TARGET_DIR)/usr/lib; ln -f -s libMali.so libGLESv2.so.2.0
	cd $(TARGET_DIR)/usr/lib; ln -f -s libGLESv2.so.2.0 libGLESv2.so.2
	cd $(TARGET_DIR)/usr/lib; ln -f -s libGLESv2.so.2 libGLESv2.so
endef


# Makefile for when everything is bunched together in libMali.so

#        $(RM) $(libdir)libGLESv1_CM.so.1.1 $(libdir)libGLESv1_CM.so.1 $(libdir)libGLESv1_CM.so
#        $(LN) libMali.so $(libdir)libGLESv1_CM.so.1.1
#        $(LN) libGLESv1_CM.so.1.1 $(libdir)libGLESv1_CM.so.1
#        $(LN) libGLESv1_CM.so.1 $(libdir)libGLESv1_CM.so
#
#        $(RM) $(libdir)libGLESv2.so.2.0 $(libdir)libGLESv2.so.2 $(libdir)libGLESv2.so
#        $(LN) libMali.so $(libdir)libGLESv2.so.2.0
#        $(LN) libGLESv2.so.2.0 $(libdir)libGLESv2.so.2
#        $(LN) libGLESv2.so.2 $(libdir)libGLESv2.so


$(eval $(generic-package))