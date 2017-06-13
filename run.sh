#!/bin/sh

QEMU=/home/pranith/devops/code/qemu/build/aarch64-softmmu/qemu-system-aarch64

cd kernel && ./getkernel.sh && cd ..
cd initrd && ./getbusybox.sh a64 && cd ..
$QEMU -kernel kernel/linux/arch/arm64/boot/Image -initrd initrd/initrd.cpio.arm64 \
      -m 512 -M virt -cpu cortex-a57 -append "init=/init console=ttyAMA0 console=ttyS0" \
      -nographic
