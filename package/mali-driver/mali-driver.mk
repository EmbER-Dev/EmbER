#############################################################
#
# MALI_DRIVER
#
#############################################################

##DX910/r3p2-01rel1/DX910-SW-99002-r3p2-01rel1.tgz

MALI_DRIVER_VERSION = r3p2-01rel1
MALI_SOURCE = DX910-SW-99002-$(MALI_DRIVER_VERSION).tgz
MALI_DRIVER_SITE = http://malideveloper.arm.com/downloads/drivers/DX910
MALI_DRIVER_LICENSE = MIT
MALI_DRIVER_LICENSE_FILES = COPYING
## MALI_DRIVER_CONF_ENV = ac_cv_path_M4=/usr/bin/m4
## MALI_DRIVER_DEPENDENCIES = m4

$(eval $(generic-package))
