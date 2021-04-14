QEMU_BUILD_DIR?=/home/pranith/workspace/code/qemu/relbuild
NCPUS?=1

.phony: all initrd.x86 initrd.arm64 kernel.x86 kernel.arm64

all: x86 arm64

run.arm64:ARCH=arm64
run.arm64:QEMU=$(QEMU_BUILD_DIR)/aarch64-softmmu/qemu-system-aarch64
run.arm64:KERNEL_IMG=kernel/linux/arch/arm64/boot/Image
run.arm64:CPU=max
run.arm64:MACHINE=virt

run.x86:ARCH=x86
run.x86:QEMU=$(QEMU_BUILD_DIR)/x86_64-softmmu/qemu-system-x86_64
run.x86:KERNEL_IMG=kernel/linux/arch/x86/boot/bzImage
run.x86:CPU=qemu64
run.x86:MACHINE=pc

x86: kernel.x86

arm64: kernel.arm64

initrd.x86: initrd/initrd.cpio.x86

initrd/initrd.cpio.x86:
	cd initrd; ./getbusybox.sh x86; cd ..

initrd.arm64: initrd/initrd.cpio.arm64

initrd/initrd.cpio.arm64:
	cd initrd; ./getbusybox.sh arm64; cd ..

kernel.x86: initrd.x86 kernel/linux/arch/x86/boot/bzImage

kernel/linux/arch/x86/boot/bzImage:
	cd kernel; ./getkernel.sh x86; cd ..

kernel.arm64: initrd.arm64 kernel/linux/arch/arm64/boot/Image

kernel/linux/arch/arm64/boot/Image:
	cd kernel; ./getkernel.sh arm64; cd ..

run.arm64: arm64
	$(QEMU) -kernel $(KERNEL_IMG) \
		-m 2048 -M $(MACHINE) -cpu $(CPU) \
		-append "console=ttyAMA0 console=ttyS0 ignore_loglevel initcall_debug=1 init=/init/" \
		-nographic -smp $(NCPUS) # --enable-kvm

run.x86: x86
	$(QEMU) -kernel $(KERNEL_IMG) \
		-m 2048 -M $(MACHINE) -cpu $(CPU) \
		-append "console=ttyAMA0 console=ttyS0 ignore_loglevel initcall_debug=1 init=/init/" \
		-nographic -smp $(NCPUS) # --enable-kvm

clean:
	rm -f initrd/initrd.cpio.* kernel/linux/arch/x86/boot/bzImage kernel/linux/arch/arm64/boot/Image

