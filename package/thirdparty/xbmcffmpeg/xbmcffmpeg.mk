################################################################################
#
# xbmcffmpeg
#
################################################################################

XBMCFFMPEG_VERSION = 2.3.2-Helix-alpha3
XBMCFFMPEG_SITE = https://github.com/xbmc/FFmpeg.git
XBMCFFMPEG_SITE_METHOD = git
XBMCFFMPEG_INSTALL_STAGING = YES
XBMCFFMPEG_INSTALL_TARGET = YES
XBMCFFMPEG_LICENSE = LGPLv2.1+, libjpeg license and GPLv2+
XBMCFFMPEG_LICENSE_FILES = LICENSE COPYING.LGPLv2.1 COPYING.GPLv2

# Set version
XBMCFFMPEG_CONF_OPT = --extra-version="xbmc-$(XBMCFFMPEG_VERSION)"

# Handle disables
XBMCFFMPEG_CONF_OPT += \
	--disable-debug \
	--disable-muxers \
	--disable-encoders \
	--disable-decoder=mpeg_xvmc \
	--disable-devices \
	--disable-ffprobe \
	--disable-ffplay \
	--disable-ffserver \
	--disable-ffmpeg \
	--disable-vdpau \
	--disable-vaapi \
	--disable-crystalhd \
	--disable-doc \
	--disable-openssl \
	--disable-hardcoded-tables

# Handle enables
XBMCFFMPEG_CONF_OPT += \
	--enable-muxer=spdif \
	--enable-muxer=adts \
	--enable-muxer=asf \
	--enable-muxer=ipod \
	--enable-encoder=ac3 \
	--enable-encoder=aac \
	--enable-encoder=wmav2 \
	--enable-avcodec \
	--enable-postproc \
	--enable-gpl \
	--enable-protocol=http \
	--enable-runtime-cpudetect \
	--enable-optimizations

# Handle optionals
XBMCFFMPEG_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)

XBMCFFMPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBAMPLAYER),libamplayer)

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
XBMCFFMPEG_CONF_OPT += --enable-pthreads
else
XBMCFFMPEG_CONF_OPT += --disable-pthreads
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
XBMCFFMPEG_CONF_OPT += --enable-zlib
XBMCFFMPEG_DEPENDENCIES += zlib
else
XBMCFFMPEG_CONF_OPT += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
XBMCFFMPEG_CONF_OPT += --enable-bzlib
XBMCFFMPEG_DEPENDENCIES += bzip2
else
XBMCFFMPEG_CONF_OPT += --disable-bzlib
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
XBMCFFMPEG_DEPENDENCIES += libvorbis
XBMCFFMPEG_CONF_OPT += \
	--enable-libvorbis \
	--enable-muxer=ogg \
	--enable-encoder=libvorbis
else
XBMCFFMPEG_CONF_OPT += --disable-libvorbis
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
XBMCFFMPEG_DEPENDENCIES += gnutls
XBMCFFMPEG_CONF_OPT += \
	--enable-gnutls \
	--extra-cflags="-fPIC"
else
XBMCFFMPEG_CONF_OPT += --disable-gnutls
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
XBMCFFMPEG_CONF_OPT += --enable-yasm
XBMCFFMPEG_DEPENDENCIES += host-yasm
else
XBMCFFMPEG_CONF_OPT += --disable-yasm
XBMCFFMPEG_CONF_OPT += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
XBMCFFMPEG_CONF_OPT += --enable-sse
else
XBMCFFMPEG_CONF_OPT += --disable-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
XBMCFFMPEG_CONF_OPT += --enable-sse2
else
XBMCFFMPEG_CONF_OPT += --disable-sse2
endif

ifeq ($(BR2_X86_CPU_HAS_SSE3),y)
XBMCFFMPEG_CONF_OPT += --enable-sse3
else
XBMCFFMPEG_CONF_OPT += --disable-sse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
XBMCFFMPEG_CONF_OPT += --enable-ssse3
else
XBMCFFMPEG_CONF_OPT += --disable-ssse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSE4),y)
XBMCFFMPEG_CONF_OPT += --enable-sse4
else
XBMCFFMPEG_CONF_OPT += --disable-sse4
endif

ifeq ($(BR2_X86_CPU_HAS_SSE42),y)
XBMCFFMPEG_CONF_OPT += --enable-sse42
else
XBMCFFMPEG_CONF_OPT += --disable-sse42
endif

# Explicitly disable everything that doesn't match for ARM
# XBMCFFMPEG "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_arm920t)$(BR2_arm922t)$(BR2_strongarm)$(BR2_fa526),y)
XBMCFFMPEG_CONF_OPT += --disable-armv5te
endif
ifeq ($(BR2_arm1136jf_s)$(BR2_arm1176jz_s)$(BR2_arm1176jzf_s),y)
XBMCFFMPEG_CONF_OPT += --enable-armv6
else
XBMCFFMPEG_CONF_OPT += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_arm10)$(BR2_arm1136jf_s)$(BR2_arm1176jz_s)$(BR2_arm1176jzf_s)$(BR2_cortex_a5)$(BR2_cortex_a8)$(BR2_cortex_a9)$(BR2_cortex_a15),y)
XBMCFFMPEG_CONF_OPT += --enable-vfp
else
XBMCFFMPEG_CONF_OPT += --disable-vfp
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
XBMCFFMPEG_CONF_OPT += --enable-neon
else
XBMCFFMPEG_CONF_OPT += --disable-neon
endif

ifeq ($(BR2_MIPS_SOFT_FLOAT),y)
XBMCFFMPEG_CONF_OPT += \
	--disable-mipsfpu
else
XBMCFFMPEG_CONF_OPT += \
	--enable-mipsfpu
endif

ifeq ($(BR2_mips_32r2),y)
XBMCFFMPEG_CONF_OPT += \
	--enable-mips32r2
else
XBMCFFMPEG_CONF_OPT += \
	--disable-mips32r2
endif

ifeq ($(BR2_mips_64r2),y)
XBMCFFMPEG_CONF_OPT += \
	--enable-mipsdspr1 \
	--enable-mipsdspr2
else
XBMCFFMPEG_CONF_OPT += \
	--disable-mipsdspr1 \
	--disable-mipsdspr2
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
XBMCFFMPEG_CONF_OPT += --enable-altivec
else
XBMCFFMPEG_CONF_OPT += --disable-altivec
endif

ifeq ($(BR2_PREFER_STATIC_LIB),)
XBMCFFMPEG_CONF_OPT += \
 	--enable-static \
	--disable-shared \
	--enable-pic
else
XBMCFFMPEG_CONF_OPT += \
	--disable-static \
	--enable-shared \
	--disable-pic
endif

# Override XBMCFFMPEG_CONFIGURE_CMDS: FFmpeg does not support --target and others
define XBMCFFMPEG_CONFIGURE_CMDS
	(cd $(XBMCFFMPEG_SRCDIR) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(XBMCFFMPEG_CONF_ENV) \
	./configure \
		--prefix=/usr \
		--enable-cross-compile \
		--cross-prefix=$(TARGET_CROSS) \
		--sysroot=$(STAGING_DIR) \
		--host-cc="$(HOSTCC)" \
		--arch=$(BR2_ARCH) \
		--target-os="linux" \
		$(if $(BR2_GCC_TARGET_TUNE),--cpu=$(BR2_GCC_TARGET_TUNE)) \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(XBMCFFMPEG_CONF_OPT) \
	)
endef

$(eval $(call autotools-package,package/thirdparty,xbmcffmpeg))
