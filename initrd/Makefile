.PHONY: arm64

x86:
	$(MAKE) initrd ARCH=x86

arm64:
	$(MAKE) initrd CC=aarch64-linux-gnu-gcc QEMU=qemu-aarch64 ARCH=arm64

initrd: etc/fstab apps dir
	find dev sbin proc init etc sys data -path "*/.*" -o -print |\
          cpio -H newc -o > initrd.cpio.$(ARCH)

apps: sbin/busybox
	bash -c 'cd sbin; for a in `$(QEMU) ./busybox --list-full`; do ln -sf ./busybox $$a; done; cd ..'

dir:
	mkdir -p dev proc sys data

clean: 
	rm -f initrd.cpio *~ \#*
