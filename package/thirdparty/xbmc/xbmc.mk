################################################################################
#
## xbmc
#
#################################################################################

XBMC_VERSION = 4670f442eceb7e1f2f335b0c774d5b68d6e43a71
XBMC_SITE_METHOD = git
XBMC_SITE = git://github.com/CoreTech-Development/xbmc.git
XBMC_INSTALL_STAGING = YES
XBMC_INSTALL_TARGET = YES

XBMC_DEPENDENCIES = host-lzo host-sdl_image

XBMC_CONF_OPT += --enable-neon --enable-gles --disable-sdl --disable-x11 --disable-xrandr \
  --disable-projectm --enable-debug --disable-joystick --with-cpu=cortex-a9

ifeq ($(BR2_ARM_AMLOGIC),y)
XBMC_CONF_OPT += --enable-codec=amcodec
endif

ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M6),y)
XBMC_CONF_OPT += --enable-m6
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
  avahi udev tinyxml taglib18 libssh

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
XBMC_KEYMAP = package/thirdparty/xbmc/keymaps/keyboard.xml
endif

ifneq ($(BR2_XBMC_ADV_SETTINGS),"")
XBMC_ADV_SETTINGS = package/thirdparty/xbmc/settings/$(call qstrip,$(BR2_XBMC_ADV_SETTINGS)).xml
else
XBMC_ADV_SETTINGS = package/thirdparty/xbmc/settings/advancedsettings.xml
endif

ifneq ($(BR2_XBMC_GUI_SETTINGS),"")
XBMC_GUI_SETTINGS = package/thirdparty/xbmc/settings/$(call qstrip,$(BR2_XBMC_GUI_SETTINGS)).xml
else
XBMC_GUI_SETTINGS = package/thirdparty/xbmc/settings/guisettings.xml
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
  cp -f $(XBMC_GUI_SETTINGS) $(TARGET_DIR)/usr/share/xbmc/system/guisettings.xml
endef

define XBMC_INSTALL_KEYMAP
  cp -f $(KEYMAP) $(TARGET_DIR)/usr/share/xbmc/system/keymaps/
  cp -f package/thirdparty/xbmc/keymaps/nobs.xml $(TARGET_DIR)/usr/share/xbmc/system/keymaps/
endef

define XBMC_INSTALL_REMOTE_CONF
  cp -f $(XBMC_REMOTE_CONF) $(TARGET_DIR)/etc/xbmc/remote.conf
endef

define XBMC_SET_DEFAULT_SKIN
  sed -i '/#define DEFAULT_SKIN/c\#define DEFAULT_SKIN "$(XBMC_DEFAULT_SKIN)"' $(XBMC_DIR)/xbmc/settings/Settings.h
endef

define XBMC_INSTALL_SPLASH
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
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_SPLASH
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_CLEAN_UNUSED_ADDONS
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_CLEAN_CONFLUENCE_SKIN
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_REMOTE_CONF

ifneq ($(BR2_ENABLE_DEBUG),y)
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_STRIP_BINARIES
endif

ifeq ($(BR2_XBMC_NO_CONFLUENCE),y)
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_REMOVE_CONFLUENCE_SKIN
endif

$(eval $(call autotools-package))
