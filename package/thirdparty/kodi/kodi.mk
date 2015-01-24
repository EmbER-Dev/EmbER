################################################################################
#
## kodi
#
#################################################################################

KODI_VERSION = $(call qstrip,$(BR2_PACKAGE_KODI_REV))
KODI_SITE_METHOD = git
KODI_SITE = git://github.com/CoreTech-Development/xbmc.git
KODI_INSTALL_STAGING = YES
KODI_INSTALL_TARGET = YES

KODI_DEPENDENCIES = host-lzo host-sdl_image

KODI_CONF_OPT += --enable-neon --enable-gles --disable-sdl --disable-x11 --disable-xrandr \
  --disable-projectm --enable-debug --disable-joystick --with-cpu=cortex-a9

ifeq ($(BR2_ARM_AMLOGIC),y)
KODI_CONF_OPT += --enable-codec=amcodec
endif

ifeq ($(BR2_KODI_POWERDOWN),y)
KODI_CONF_OPT += --enable-powerdown
endif

ifeq ($(BR2_KODI_SUSPEND),y)
KODI_CONF_OPT += --enable-suspend
endif

ifeq ($(BR2_KODI_HIBERNATE),y)
KODI_CONF_OPT += --enable-hibernate
endif

ifeq ($(BR2_KODI_REBOOT),y)
KODI_CONF_OPT += --enable-reboot
endif

ifneq ($(BR2_CCACHE),y)
KODI_CONF_OPT += --disable-ccache
endif

KODI_DEPENDENCIES += flac libmad libmpeg2 libogg \
  libsamplerate libtheora libvorbis wavpack bzip2 dbus libcdio \
  python lzo zlib libgcrypt openssl mysql_client sqlite fontconfig \
  freetype jasper jpeg libmodplug libpng libungif tiff libcurl \
  libmicrohttpd libssh2 boost fribidi ncurses pcre libnfs afpfs-ng \
  libplist libshairplay libbluray libcec \
  readline expat libxml2 yajl samba libass opengl libusb-compat \
  avahi udev tinyxml taglib18 libssh libxslt xbmcffmpeg

ifeq ($(BR2_ARM_AMLOGIC),y)
KODI_DEPENDENCIES += libamplayer
endif

ifneq ($(BR2_KODI_REMOTE_CONF),"")
KODI_REMOTE_CONF = package/thirdparty/kodi/remotes/$(call qstrip,$(BR2_KODI_REMOTE_CONF)).conf
else
KODI_REMOTE_CONF = package/thirdparty/kodi/remotes/remote.conf
endif

ifneq ($(BR2_KODI_KEYMAP),"")
KODI_KEYMAP = package/thirdparty/kodi/keymaps/$(call qstrip,$(BR2_KODI_KEYMAP)).xml
else
KODI_KEYMAP = package/thirdparty/kodi/keymaps/variant.keyboard.xml
endif

ifneq ($(BR2_KODI_SETTINGS),"")
KODI_SETTINGS = package/thirdparty/kodi/settings/$(call qstrip,$(BR2_KODI_SETTINGS)).xml
endif

ifneq ($(BR2_KODI_ADV_SETTINGS),"")
KODI_ADV_SETTINGS = package/thirdparty/kodi/settings/$(call qstrip,$(BR2_KODI_ADV_SETTINGS)).xml
else ifeq ($(BR2_ARM_AMLOGIC),y)
KODI_ADV_SETTINGS = package/thirdparty/kodi/settings/amlogic_advancedsettings.xml
else
KODI_ADV_SETTINGS = package/thirdparty/kodi/settings/advancedsettings.xml
endif

ifneq ($(BR2_KODI_SPLASH),"")
KODI_SPLASH_FILE = package/thirdparty/kodi/logos/$(call qstrip,$(BR2_KODI_SPLASH)).png
else
KODI_SPLASH_FILE = package/thirdparty/kodi/logos/splash.png
endif

ifneq ($(BR2_KODI_OVERLAY_FB),y)
ifneq ($(BR2_KODI_STARTING_FB),"")
KODI_STARTING_FB = package/thirdparty/kodi/fb_splashs/$(call qstrip,$(BR2_KODI_STARTING_FB)).fb.lzo
else
KODI_STARTING_FB = package/thirdparty/kodi/fb_splashs/starting.fb.lzo
endif

ifneq ($(BR2_KODI_STOPPING_FB),"")
KODI_STOPPING_FB = package/thirdparty/kodi/fb_splashs/$(call qstrip,$(BR2_KODI_STOPPING_FB)).fb.lzo
else
KODI_STOPPING_FB = package/thirdparty/kodi/fb_splashs/stopping.fb.lzo
endif

ifneq ($(BR2_KODI_COMPLETE_FB),"")
KODI_COMPLETE_FB = package/thirdparty/kodi/fb_splashs/$(call qstrip,$(BR2_KODI_COMPLETE_FB)).fb.lzo
else
KODI_COMPLETE_FB = package/thirdparty/kodi/fb_splashs/complete.fb.lzo
endif
endif

ifeq ($(BR2_KODI_SET_CONFLUENCE_POWER_BUTTON_POWERDOWN),y)
CONFLUENCE_POWER_BUTTON_FUNCTION = XBMC.Powerdown()
else ifeq ($(BR2_KODI_SET_CONFLUENCE_POWER_BUTTON_SUSPEND),y)
CONFLUENCE_POWER_BUTTON_FUNCTION = XBMC.Suspend()
else ifeq ($(BR2_KODI_SET_CONFLUENCE_POWER_BUTTON_HIBERNATE),y)
CONFLUENCE_POWER_BUTTON_FUNCTION = XBMC.Hibernate()
else ifeq ($(BR2_KODI_SET_CONFLUENCE_POWER_BUTTON_REBOOT),y)
CONFLUENCE_POWER_BUTTON_FUNCTION = XBMC.Reset()
else
CONFLUENCE_POWER_BUTTON_FUNCTION = ActivateWindow(ShutdownMenu)
endif

KODI_CONF_ENV += PYTHON_VERSION="$(PYTHON_VERSION_MAJOR)"
KODI_CONF_ENV += PYTHON_LDFLAGS="-L$(STAGING_DIR)/usr/lib/ -lpython$(PYTHON_VERSION_MAJOR) -lpthread -ldl -lutil -lm"
KODI_CONF_ENV += PYTHON_CPPFLAGS="-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)"
KODI_CONF_ENV += PYTHON_SITE_PKG="$(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages"
KODI_CONF_ENV += PYTHON_NOVERSIONCHECK="no-check"
KODI_CONF_ENV += USE_TEXTUREPACKER_NATIVE_ROOT="$(HOST_DIR)/usr"

# For braindead apps like mysql that require running a binary/script
KODI_CONF_ENV += PATH=$(STAGING_DIR)/usr/bin:$(TARGET_PATH)

define KODI_BOOTSTRAP
  cd $(KODI_DIR) && ./bootstrap
endef

define KODI_INSTALL_ETC
  cp -rf package/thirdparty/kodi/etc $(TARGET_DIR)
endef

define KODI_INSTALL_SETTINGS
  cp -f $(KODI_SETTINGS) $(TARGET_DIR)/usr/share/kodi/system/settings/settings.xml
endef

define KODI_INSTALL_ADV_SETTINGS
  cp -f $(KODI_ADV_SETTINGS) $(TARGET_DIR)/usr/share/kodi/system/advancedsettings.xml
endef

define KODI_INSTALL_KEYMAP
  cp -f $(KODI_KEYMAP) $(TARGET_DIR)/usr/share/kodi/system/keymaps/
  cp -f package/thirdparty/kodi/keymaps/nobs.xml $(TARGET_DIR)/usr/share/kodi/system/keymaps/
endef

define KODI_INSTALL_REMOTE_CONF
  mkdir -p $(TARGET_DIR)/etc/kodi
  cp -f $(KODI_REMOTE_CONF) $(TARGET_DIR)/etc/kodi/remote.conf
endef

define KODI_SET_DEFAULT_SKIN
  sed -i '/<default>skin./c\          <default>skin.$(call qstrip,$(BR2_KODI_DEFAULT_SKIN))</default>' $(TARGET_DIR)/usr/share/kodi/system/settings/settings.xml
endef

define KODI_INSTALL_SPLASH
  mkdir -p $(TARGET_DIR)/usr/share/splash
  cp -f $(KODI_SPLASH_FILE) $(TARGET_DIR)/usr/share/kodi/media/Splash.png
endef

define KODI_INSTALL_FB_SPLASHS
  cp -f $(KODI_STARTING_FB) $(TARGET_DIR)/usr/share/splash/starting.fb.lzo
  cp -f $(KODI_STOPPING_FB) $(TARGET_DIR)/usr/share/splash/stopping.fb.lzo
  cp -f $(KODI_COMPLETE_FB) $(TARGET_DIR)/usr/share/splash/complete.fb.lzo
endef

define KODI_CLEAN_UNUSED_ADDONS
  rm -rf $(TARGET_DIR)/usr/share/kodi/addons/screensaver.rsxs.euphoria
  rm -rf $(TARGET_DIR)/usr/share/kodi/addons/screensaver.rsxs.plasma
  rm -rf $(TARGET_DIR)/usr/share/kodi/addons/screensaver.rsxs.solarwinds
  rm -rf $(TARGET_DIR)/usr/share/kodi/addons/visualization.milkdrop
  rm -rf $(TARGET_DIR)/usr/share/kodi/addons/visualization.projectm
  rm -rf $(TARGET_DIR)/usr/share/kodi/addons/visualization.itunes
  rm -rf $(TARGET_DIR)/usr/share/kodi/addons/service.xbmc.versioncheck
endef

define KODI_SET_CONFLUENCE_POWER_BUTTON
  sed -i '/				####Compiler will set function####/c\				<onclick>$(CONFLUENCE_POWER_BUTTON_FUNCTION)</onclick>' $(TARGET_DIR)/usr/share/kodi/addons/skin.confluence/720p/Home.xml
endef

define KODI_CLEAN_CONFLUENCE_SKIN
  find $(TARGET_DIR)/usr/share/kodi/addons/skin.confluence/media -name *.png -delete
  find $(TARGET_DIR)/usr/share/kodi/addons/skin.confluence/media -name *.jpg -delete
endef

define KODI_REMOVE_CONFLUENCE_SKIN
  rm -rf $(TARGET_DIR)/usr/share/kodi/addons/skin.confluence
endef

define KODI_STRIP_BINARIES
  find $(TARGET_DIR)/usr/lib/kodi/ -name "*.so" -exec $(STRIPCMD) $(STRIP_STRIP_UNNEEDED) {} \;
  $(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/kodi/kodi.bin
endef

KODI_PRE_CONFIGURE_HOOKS += KODI_BOOTSTRAP
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_ETC
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_ADV_SETTINGS
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_KEYMAP
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_SPLASH
KODI_POST_INSTALL_TARGET_HOOKS += KODI_CLEAN_UNUSED_ADDONS
KODI_POST_INSTALL_TARGET_HOOKS += KODI_CLEAN_CONFLUENCE_SKIN
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_REMOTE_CONF

ifneq ($(BR2_KODI_OVERLAY_FB),y)
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_FB_SPLASHS
endif

ifneq ($(BR2_KODI_SETTINGS),"")
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_SETTINGS
endif

ifneq ($(BR2_ENABLE_DEBUG),y)
KODI_POST_INSTALL_TARGET_HOOKS += KODI_STRIP_BINARIES
endif

ifneq ($(BR2_KODI_DEFAULT_SKIN),"")
KODI_POST_INSTALL_TARGET_HOOKS += KODI_SET_DEFAULT_SKIN
endif

ifeq ($(BR2_KODI_NO_CONFLUENCE),y)
KODI_POST_INSTALL_TARGET_HOOKS += KODI_REMOVE_CONFLUENCE_SKIN
else
KODI_POST_INSTALL_TARGET_HOOKS += KODI_SET_CONFLUENCE_POWER_BUTTON
endif

$(eval $(call autotools-package))
