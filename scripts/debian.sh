#!/bin/bash

function cnf_hostname {
	echo "$1" > $ROOTFS_FOLDER/etc/hostname
}

function cnf_hosts {
	sed -i "s/localhost/localhost\ $1/" $ROOTFS_FOLDER/etc/hosts
}

function cnf_mdadm {
	cat <<- EOF > $ROOTFS_FOLDER/etc/mdadm/mdadm.conf
		CREATE owner=root group=disk mode=0660 auto=yes
		DEVICE /dev/sd??*
	EOF

	mdadm -Eb /dev/sd??* >> $ROOTFS_FOLDER/etc/mdadm/mdadm.conf
	# editor $ROOTFS_FOLDER/etc/mdadm/mdadm.conf
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

function cnf_fstab {
	cat <<- EOF > $ROOTFS_FOLDER/etc/fstab
		# /etc/fstab: static file system information.
		#
		# file system	mount point	type	options		dump	pass
		/dev/md0	/boot		ext3	ro,nosuid,nodev		0	2
		/dev/md1	/			ext3	defaults,noatime	0	1
		/dev/md2	none		swap	sw					0	0
		proc		/proc		proc	defaults			0	0
		devpts		/dev/pts	devpts	gid=4,mode=620		0	0
		sysfs		/sys		sysfs	defaults			0	0
	EOF
}