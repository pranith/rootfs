#!/bin/bash
# Set QEMU_BUILD_DIR to the build directory

QEMU_BUILD_DIR=/home/pranith/workspace/code/qemu/relbuild/

ARCH=arm64
NCPUS=1
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
    CPU=max
    MACHINE=virt,gic-version=3
fi

function buildComponents {
    cd initrd && ./getbusybox.sh $ARCH && cd ..
    cd kernel && ./getkernel.sh $ARCH && cd ..
}

if [ "$2" = "build" ]; then
    buildComponents
fi
    
echo === RUNNING QEMU ===
$QEMU -kernel $KERNEL_IMG \
      -m 2048 -M $MACHINE -cpu $CPU -append "console=ttyAMA0 console=ttyS0 ignore_loglevel initcall_debug=1 init=/init/" \
      -nographic -smp $NCPUS # --enable-kvm
