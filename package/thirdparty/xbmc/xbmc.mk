################################################################################
#
## xbmc
#
#################################################################################

XBMC_VERSION = 13.0-Gotham_r2
XBMC_SITE_METHOD = git
XBMC_SITE = git://github.com/xbmc/xbmc.git
XBMC_INSTALL_STAGING = YES
XBMC_INSTALL_TARGET = YES

XBMC_DEPENDENCIES = host-lzo host-sdl_image

XBMC_CONF_OPT += --enable-neon --enable-gles --disable-sdl --disable-x11 --disable-xrandr \
  --disable-projectm --enable-debug --disable-joystick --with-cpu=cortex-a9

ifeq ($(BR2_ARM_AMLOGIC),y)
XBMC_CONF_OPT += --enable-codec=amcodec
endif

ifeq ($(BR2_XBMC_POWERDOWN),y)
XBMC_CONF_OPT += --enable-powerdown
endif

ifeq ($(BR2_XBMC_SUSPEND),y)
XBMC_CONF_OPT += --enable-suspend
endif

ifeq ($(BR2_XBMC_HIBERNATE),y)
XBMC_CONF_OPT += --enable-hibernate
endif

ifeq ($(BR2_XBMC_REBOOT),y)
XBMC_CONF_OPT += --enable-reboot
endif

ifneq ($(BR2_CCACHE),y)
XBMC_CONF_OPT += --disable-ccache
endif

XBMC_DEPENDENCIES += flac libmad libmpeg2 libogg \
  libsamplerate libtheora libvorbis wavpack bzip2 dbus libcdio \
  python lzo zlib libgcrypt openssl mysql_client sqlite fontconfig \
  freetype jasper jpeg libmodplug libpng libungif tiff libcurl \
  libmicrohttpd libssh2 boost fribidi ncurses pcre libnfs afpfs-ng \
  libplist libshairport libbluray libcec \
  readline expat libxml2 yajl samba libass opengl libusb-compat \
  avahi udev tinyxml taglib18 libssh libxslt

ifeq ($(BR2_ARM_AMLOGIC),y)
XBMC_DEPENDENCIES += libamplayer
endif

ifneq ($(BR2_XBMC_REMOTE_CONF),"")
XBMC_REMOTE_CONF = package/thirdparty/xbmc/remotes/$(call qstrip,$(BR2_XBMC_REMOTE_CONF)).conf
else
XBMC_REMOTE_CONF = package/thirdparty/xbmc/remotes/remote.conf
endif

ifneq ($(BR2_XBMC_KEYMAP),"")
XBMC_KEYMAP = package/thirdparty/xbmc/keymaps/$(call qstrip,$(BR2_XBMC_KEYMAP)).xml
else
XBMC_KEYMAP = package/thirdparty/xbmc/keymaps/variant.keyboard.xml
endif

ifneq ($(BR2_XBMC_ADV_SETTINGS),"")
XBMC_ADV_SETTINGS = package/thirdparty/xbmc/settings/$(call qstrip,$(BR2_XBMC_ADV_SETTINGS)).xml
else ifeq ($(BR2_ARM_AMLOGIC),y)
XBMC_ADV_SETTINGS = package/thirdparty/xbmc/settings/amlogic_advancedsettings.xml
else
XBMC_ADV_SETTINGS = package/thirdparty/xbmc/settings/advancedsettings.xml
endif

ifneq ($(BR2_XBMC_DEFAULT_SKIN),"")
XBMC_DEFAULT_SKIN = skin.$(call qstrip,$(BR2_XBMC_DEFAULT_SKIN))
else
XBMC_DEFAULT_SKIN = skin.confluence
endif

ifneq ($(BR2_XBMC_SPLASH),"")
XBMC_SPLASH_FILE = package/thirdparty/xbmc/logos/$(call qstrip,$(BR2_XBMC_SPLASH)).png
else
XBMC_SPLASH_FILE = package/thirdparty/xbmc/logos/splash.png
endif

ifneq ($(BR2_XBMC_STARTING_FB),"")
XBMC_STARTING_FB = package/thirdparty/xbmc/fb_splashs/$(call qstrip,$(BR2_XBMC_STARTING_FB)).fb.lzo
else
XBMC_STARTING_FB = package/thirdparty/xbmc/fb_splashs/starting.fb.lzo
endif

ifneq ($(BR2_XBMC_STOPPING_FB),"")
XBMC_STOPPING_FB = package/thirdparty/xbmc/fb_splashs/$(call qstrip,$(BR2_XBMC_STOPPING_FB)).fb.lzo
else
XBMC_STOPPING_FB = package/thirdparty/xbmc/fb_splashs/stopping.fb.lzo
endif

ifneq ($(BR2_XBMC_COMPLETE_FB),"")
XBMC_COMPLETE_FB = package/thirdparty/xbmc/fb_splashs/$(call qstrip,$(BR2_XBMC_COMPLETE_FB)).fb.lzo
else
XBMC_COMPLETE_FB = package/thirdparty/xbmc/fb_splashs/complete.fb.lzo
endif

ifeq ($(BR2_XBMC_SET_CONFLUENCE_POWER_BUTTON_POWERDOWN),y)
CONFLUENCE_POWER_BUTTON_FUNCTION = XBMC.Powerdown()
else ifeq ($(BR2_XBMC_SET_CONFLUENCE_POWER_BUTTON_SUSPEND),y)
CONFLUENCE_POWER_BUTTON_FUNCTION = XBMC.Suspend()
else ifeq ($(BR2_XBMC_SET_CONFLUENCE_POWER_BUTTON_HIBERNATE),y)
CONFLUENCE_POWER_BUTTON_FUNCTION = XBMC.Hibernate()
else ifeq ($(BR2_XBMC_SET_CONFLUENCE_POWER_BUTTON_REBOOT),y)
CONFLUENCE_POWER_BUTTON_FUNCTION = XBMC.Reset()
else
CONFLUENCE_POWER_BUTTON_FUNCTION = ActivateWindow(ShutdownMenu)
endif

XBMC_CONF_ENV += PYTHON_VERSION="$(PYTHON_VERSION_MAJOR)"
XBMC_CONF_ENV += PYTHON_LDFLAGS="-L$(STAGING_DIR)/usr/lib/ -lpython$(PYTHON_VERSION_MAJOR) -lpthread -ldl -lutil -lm"
XBMC_CONF_ENV += PYTHON_CPPFLAGS="-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)"
XBMC_CONF_ENV += PYTHON_SITE_PKG="$(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages"
XBMC_CONF_ENV += PYTHON_NOVERSIONCHECK="no-check"
XBMC_CONF_ENV += USE_TEXTUREPACKER_NATIVE_ROOT="$(HOST_DIR)/usr"

# For braindead apps like mysql that require running a binary/script
XBMC_CONF_ENV += PATH=$(STAGING_DIR)/usr/bin:$(TARGET_PATH)

define XBMC_BOOTSTRAP
  cd $(XBMC_DIR) && ./bootstrap
endef

define XBMC_INSTALL_ETC
  cp -rf package/thirdparty/xbmc/etc $(TARGET_DIR)
endef

define XBMC_INSTALL_SETTINGS
  cp -f $(XBMC_ADV_SETTINGS) $(TARGET_DIR)/usr/share/xbmc/system/advancedsettings.xml
endef

define XBMC_INSTALL_KEYMAP
  cp -f $(XBMC_KEYMAP) $(TARGET_DIR)/usr/share/xbmc/system/keymaps/
  cp -f package/thirdparty/xbmc/keymaps/nobs.xml $(TARGET_DIR)/usr/share/xbmc/system/keymaps/
endef

define XBMC_INSTALL_REMOTE_CONF
  mkdir -p $(TARGET_DIR)/etc/xbmc
  cp -f $(XBMC_REMOTE_CONF) $(TARGET_DIR)/etc/xbmc/remote.conf
endef

define XBMC_SET_DEFAULT_SKIN
  sed -i '/#define DEFAULT_SKIN/c\#define DEFAULT_SKIN          "$(XBMC_DEFAULT_SKIN)"' $(XBMC_DIR)/xbmc/system.h
endef

define XBMC_INSTALL_SPLASHS
  mkdir -p $(TARGET_DIR)/usr/share/splash
  cp -f $(XBMC_STARTING_FB) $(TARGET_DIR)/usr/share/splash/starting.fb.lzo
  cp -f $(XBMC_STOPPING_FB) $(TARGET_DIR)/usr/share/splash/stopping.fb.lzo
  cp -f $(XBMC_COMPLETE_FB) $(TARGET_DIR)/usr/share/splash/complete.fb.lzo
  cp -f $(XBMC_SPLASH_FILE) $(TARGET_DIR)/usr/share/xbmc/media/Splash.png
endef

define XBMC_CLEAN_UNUSED_ADDONS
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/screensaver.rsxs.euphoria
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/screensaver.rsxs.plasma
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/screensaver.rsxs.solarwinds
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.milkdrop
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.projectm
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.itunes
endef

define XBMC_SET_CONFLUENCE_POWER_BUTTON
  sed -i '/				####Compiler will set function####/c\				<onclick>$(CONFLUENCE_POWER_BUTTON_FUNCTION)</onclick>' $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence/720p/Home.xml
endef

define XBMC_CLEAN_CONFLUENCE_SKIN
  find $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence/media -name *.png -delete
  find $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence/media -name *.jpg -delete
endef

define XBMC_REMOVE_CONFLUENCE_SKIN
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence
endef

define XBMC_STRIP_BINARIES
  find $(TARGET_DIR)/usr/lib/xbmc/ -name "*.so" -exec $(STRIPCMD) $(STRIP_STRIP_UNNEEDED) {} \;
  $(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/xbmc/xbmc.bin
endef

XBMC_PRE_CONFIGURE_HOOKS += XBMC_SET_DEFAULT_SKIN
XBMC_PRE_CONFIGURE_HOOKS += XBMC_BOOTSTRAP
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_ETC
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_SETTINGS
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_KEYMAP
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_SPLASHS
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_CLEAN_UNUSED_ADDONS
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_CLEAN_CONFLUENCE_SKIN
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_REMOTE_CONF

ifneq ($(BR2_ENABLE_DEBUG),y)
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_STRIP_BINARIES
endif

ifeq ($(BR2_XBMC_NO_CONFLUENCE),y)
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_REMOVE_CONFLUENCE_SKIN
else
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_SET_CONFLUENCE_POWER_BUTTON
endif

$(eval $(call autotools-package))
