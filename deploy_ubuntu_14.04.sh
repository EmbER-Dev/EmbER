#!/bin/sh
###############################################################################
# This script will setup Ubuntu 14.04 to compile Amlogic Android/Buildroot.
#
# Written by:	croniccorey (cronmod.dev@gmail.com)
# Date:		2014/09/11
###############################################################################

####################
##     Global     ##
####################

AMLOGIC="http://openlinux.amlogic.com:8000"
GOOGLE="https://storage.googleapis.com/git-repo-downloads"
JAVA="ppa:webupd8team/java"

#######################
##     Functions     ##
#######################

check_root()
{
	echo "##########################################"
	echo "##     Checking for root permission     ##"
	echo "##########################################"
	if [ "$(id -u)" != "0" ]; then
		echo "ERROR: This script must be run as root...."
		exit 1
	fi
}

check_OS()
{
	echo "#######################################"
	echo "##     Checking operating system     ##"
	echo "#######################################"
	OS_MACHINE=`uname -m`
	if [ "$OS_MACHINE" != "x86_64" ]; then
		echo "ERROR: This script only supports 64-bit operating systems...."
		exit 1
	fi

	OS_NUMBER=`cat /etc/lsb-release | grep RELEASE | awk -F "=" '{print $2}'`
	if [ "$OS_NUMBER" != "14.04" ]; then
		echo "ERROR: This script only supports Ubuntu 14.04 (Trusty Tahr)...."
		exit 1
	fi
}
	
install_packages()
{
	echo "################################"
	echo "##     Installing packages    ##"
	echo "################################"
	apt-get update
	apt-get install -y nfs-kernel-server autofs autoconf automake make \
	vim perl gcc g++ gcc-4.4 g++-4.4 build-essential git-core gnupg flex \
	bison gperf zip unzip curl libc6-dev x11proto-core-dev subversion \
	libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-dev:i386 g++-multilib \
	liblzo2-2 lzma mingw32 tofrodos libxml2-utils xsltproc zlib1g-dev zlib1g-dev:i386 \
	python python-markdown python-software-properties gawk libtool gettext \
	libncurses5-dev libncurses5-dev:i386 autopoint nasm flex libsdl-image1.2 \
	libxml-parser-perl texinfo wget pkg-config swig cpio liblzo2-2 lzma whois \
	mercurial unixodbc lzop ckermit putty unrar android-tools-* u-boot-tools

	rm -rf /usr/lib/i386-linux-gnu/libGL.so /usr/lib/x86_64-linux-gnu/libmpc.so.2 /usr/bin/gcc /usr/bin/g++ 
	ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
	ln -s /usr/lib/x86_64-linux-gnu/libmpc.so.3 /usr/lib/x86_64-linux-gnu/libmpc.so.2
	ln -s /usr/bin/gcc-4.4 /usr/bin/gcc
	ln -s /usr/bin/g++-4.4 /usr/bin/g++
}

install_amlogic_packages()
{
	echo "#########################################"
	echo "##     Installing Amlogic packages     ##"
	echo "#########################################"
	wget $AMLOGIC/deploy/CodeSourcery.tar.gz -P /tmp
	tar -zxvf /tmp/CodeSourcery.tar.gz -C /opt
	wget $AMLOGIC/deploy/gnutools.tar.gz -P /tmp
	tar -zxvf /tmp/gnutools.tar.gz -C /opt
	wget $AMLOGIC/deploy/gcc-linaro-arm-linux-gnueabihf.tar.gz -P /tmp
	tar -zxvf /tmp/gcc-linaro-arm-linux-gnueabihf.tar.gz -C /opt
	wget $AMLOGIC/deploy/arc-4.8-amlogic-20130904-r2.tar.gz  -P /tmp
	tar -zxvf /tmp/arc-4.8-amlogic-20130904-r2.tar.gz -C /opt/gnutools

	wget $AMLOGIC/deploy/arc_gnutools.sh -P /etc/profile.d
	wget $AMLOGIC/deploy/arm_path.sh -P /etc/profile.d
	wget $AMLOGIC/deploy/arm_new_gcc.sh -P /etc/profile.d
	wget $AMLOGIC/deploy/arc_new_tools.sh -P /etc/profile.d
}

install_repo()
{
	echo "#####################################"
	echo "##     Installing Google repo      ##"
	echo "#####################################"
	wget $GOOGLE/repo -P /usr/bin
	chmod a+x /usr/bin/repo
}

install_java()
{
	echo "######################################"
	echo "##     Installing Oracle Java 6     ##"
	echo "######################################"
	add-apt-repository $JAVA
	apt-get update
	apt-get install -y oracle-java6-installer oracle-java6-set-default
}

reboot_machine()
{
	echo "##############################"
	echo "##     Rebooting system     ##"
	echo "##############################"
	shutdown -r 1 "Hit Ctrl+c to cancel"
}

#####################
##     Execute     ##
#####################

echo "This script will configure a Android/Buildroot build server, This script only supports Ubuntu 14.04 (Trusty Tahr) 64-bit...." 
check_root
check_OS
install_packages
install_amlogic_packages
install_repo
install_java
reboot_machine
