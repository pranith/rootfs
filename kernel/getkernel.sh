#!/bin/sh
# Download and patch Linux kernel
KERNEL=linux-4.1.23
KERNEL_ARC=$KERNEL.tar.xz
KERNEL_URL=https://www.kernel.org/pub/linux/kernel/v4.x/$KERNEL_ARC
UNPACKAGE="tar -xf"

INITRD=`pwd`/initrd/initrd.cpio

# Only download the archive if we don't alreay have it.
if [ ! -e $KERNEL_ARC ]; then
  echo === DOWNLOADING ARCHIVE ===
  wget $KERNEL_URL
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
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j4 KCPPFLAGS="-fno-pic -Wno-pointer-sign"
