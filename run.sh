#!/bin/sh
# Set QEMU_BUILD_DIR to the build directory

QEMU_BUILD_DIR=/home/pranith/qemu/build

ARCH=arm64
NCPUS=2
MTTCG=off
if [ "$1" = "x86" ]; then
    ARCH=x86
    QEMU=$QEMU_BUILD_DIR/x86_64-softmmu/qemu-system-x86_64
    KERNEL_IMG=kernel/linux/arch/x86/boot/bzImage
    CPU=qemu64
    MACHINE=pc
elif [ "$1" = "arm64" ]; then
    ARCH=arm64
    QEMU=$QEMU_BUILD_DIR/aarch64-softmmu/qemu-system-aarch64
    KERNEL_IMG=kernel/linux/arch/arm64/boot/Image
    CPU=cortex-a57
    MACHINE=virt,gic_version=3
fi

cd kernel && ./getkernel.sh $ARCH && cd ..
cd initrd && ./getbusybox.sh $ARCH && cd ..

echo === RUNNING QEMU ===
$QEMU -kernel $KERNEL_IMG -initrd initrd/initrd.cpio \
      -m 512 -M $MACHINE -cpu $CPU -append "init=/init console=ttyAMA0 console=ttyS0 ignore_loglevel initcall_debug=1" \
      -nographic -smp $NCPUS
