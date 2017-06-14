#!/bin/sh
# Download and patch Linux kernel
echo === KERNEL ===
#KERNEL=linux-4.12-rc5
#KERNEL_ARC=$KERNEL.tar.gz
#KERNEL_URL=https://git.kernel.org/torvalds/t/$KERNEL_ARC
KERNEL=linux-4.11.4
KERNEL_ARC=$KERNEL.tar.xz
KERNEL_URL=https://www.kernel.org/pub/linux/kernel/v4.x/$KERNEL_ARC
UNPACKAGE="tar -xf"

INITRD=`pwd`/initrd/initrd.cpio

if [ ! -e $INITRD ]; then
    # Only download the archive if we don't alreay have it.
    if [ ! -e $KERNEL_ARC ]; then
	echo === DOWNLOADING ARCHIVE ===
	wget $KERNEL_URL
	rm -rf linux
    fi

    # unpack if kernel does not exists
    if [ ! -e linux ]; then
	echo === UNPACKING ARCHIVE ===
	$UNPACKAGE $KERNEL_ARC
	mv $KERNEL linux
    fi

    echo === BUILDING LINUX ===
    cp kernel-config linux/.config
    cd linux
    make olddefconfig ARCH=arm64
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j4 KCPPFLAGS="-fno-pic -Wno-pointer-sign"
fi
