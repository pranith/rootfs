#!/bin/bash
# Download and configure busybox.
echo === INITRD ===

# NOTE: This is optional. The binary of busybox distributed with QSim should
# work perfectly adequately.

ARCH=
CROSS=
if [ $1  == "arm64" ]; then
    ARCH=arm64
    CROSS=aarch64-linux-gnu-
fi

BBOX=busybox-1.24.1
BBOX_ARCHIVE=$BBOX.tar.bz2
BBOX_URL=https://www.busybox.net/downloads/$BBOX_ARCHIVE

UNPACK="tar -xjf"

# Download the archive if we don't already have it.
if [ ! -e $BBOX_ARCHIVE ]; then
  echo === DOWNLOADING ARCHIVE ===
  wget $BBOX_URL --no-check-certificate
fi

# Delete the busybox directory if it already exists.
if [ ! -e busybox ]; then
    echo === UNPACKING ARCHIVE ===
    $UNPACK $BBOX_ARCHIVE
    mv $BBOX busybox
fi

echo === COPYING CONFIG ===
cp busybox-config busybox/.config

echo == BUILDING ==
mkdir -p sbin
cd busybox
make -j4 ARCH=$ARCH CROSS_COMPILE=$CROSS
cp busybox ../sbin/
cd ../
make clean && make $ARCH
