#############################################################
#
# xf86-video-mali
#
#############################################################
XDRIVER_XF86_VIDEO_MALI_VERSION = r3p0-04rel0
XDRIVER_XF86_VIDEO_MALI_SITE = git://github.com/mortaromarcello/xf86-video-mali.git
XDRIVER_XF86_VIDEO_MALI_DEPENDENCIES = xserver_xorg-server libdrm xlib_libX11 xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto
XDRIVER_XF86_VIDEO_MALI_INSTALL_STAGING = YES
XDRIVER_XF86_VIDEO_MALI_INSTALL_TARGET = YES
XDRIVER_XF86_VIDEO_MALI_AUTORECONF=YES

$(eval $(autotools-package))
