###############################################################################
#
## speedtest_cli
#
###############################################################################
SPEEDTEST_CLI_VERSION = 18408ee93884de3d28142d0afac12714049e293b
SPEEDTEST_CLI_SITE = git://github.com/sivel/speedtest-cli.git
SPEEDTEST_CLI_SITE_METHOD = git
SPEEDTEST_CLI_INSTALL_STAGING = NO
SPEEDTEST_CLI_INSTALL_TARGET = YES

define SPEEDTEST_CLI_INSTALL_TARGET_CMDS
	install -m 755 $(@D)/speedtest_cli.py $(TARGET_DIR)/sbin/speedtest-cli
endef

$(eval $(call generic-package,package/thirdparty,speedtest_cli))

