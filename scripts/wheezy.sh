#!/bin/bash

function cnf_hostname {
	echo "$1" > $ROOTFS_FOLDER/etc/hostname
}

function cnf_hosts {
	sed "s/localhost/localhost\ $1/" $ROOTFS_FOLDER/etc/hosts
}

function cnf_mdadm {
	echo 'DEVICE /dev/sd??*' > $ROOTFS_FOLDER/etc/mdadm/mdadm.conf
	mdadm -Eb /dev/sd??* >> $ROOTFS_FOLDER/etc/mdadm/mdadm.conf
	editor $ROOTFS_FOLDER/etc/mdadm/mdadm.conf
}

function cnf_sources {
	echo "deb $DEBIAN_REPO $SUITE main" > $ROOTFS_FOLDER/etc/apt/sources.list.d/debian.list
}

function cnf_interfaces {
	cat <<- EOF > $ROOTFS_FOLDER/etc/network/interfaces
		auto lo
		iface lo inet loopback

		auto eth0
		iface eth0 inet dhcp

		auto eth1
		iface eth1 inet dhcp
	EOF
}

function cnf_password {
	chroot $ROOTFS_FOLDER echo -e "$1\n$1" | passwd
}

function cnf_locales {
	chroot $ROOTFS_FOLDER dpkg-reconfigure locales
}

function cnf_tzdata {
	chroot $ROOTFS_FOLDER dpkg-reconfigure tzdata
}