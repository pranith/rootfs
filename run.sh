#!/bin/sh

NCPUS=2
MTTCG=off

cd kernel && ./getkernel.sh && cd ..
cd initrd && ./getbusybox.sh && cd ..

echo === RUNNING QEMU ===
$QEMU -kernel kernel/linux/arch/arm64/boot/Image -initrd initrd/initrd.cpio \
      -m 512 -M virt,gic_version=3 -cpu cortex-a57 -append "init=/init console=ttyAMA0 console=ttyS0 ignore_loglevel initcall_debug=1" \
      -nographic -smp $NCPUS
