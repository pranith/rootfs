#!/bin/sh
# Download and patch Linux kernel
echo === KERNEL ===
#KERNEL=linux-4.12-rc5
#KERNEL_ARC=$KERNEL.tar.gz
#KERNEL_URL=https://git.kernel.org/torvalds/t/$KERNEL_ARC
KERNEL=linux-5.11.13
KERNEL_ARC=$KERNEL.tar.xz
KERNEL_URL=https://www.kernel.org/pub/linux/kernel/v5.x/$KERNEL_ARC

HOST_ARCH=`uname -m`
UNPACKAGE="tar -xf"
ARCH=$1
NPROC=`nproc`
if [ $1 = "arm64" ] && [ $HOST_ARCH != "aarch64" ]; then
    CROSS=aarch64-linux-gnu-
else
    CROSS=
fi

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
    cp ${ARCH}-config linux/.config
    cd linux
    make olddefconfig ARCH=$ARCH
    make ARCH=$ARCH CROSS_COMPILE=$CROSS -j${NPROC} KCPPFLAGS="-fno-pic -Wno-pointer-sign"
fi
