initrd.cpio: etc/fstab init sbin/hexdump dev proc sys data
	find dev sbin proc init etc sys data -path "*/.*" -o -print |\
          cpio -H newc -o > initrd.cpio

sbin/hexdump : sbin/busybox
	bash -c 'cd sbin; for a in `$(QEMU) ./busybox --list-full`; do ln -sf ./busybox $$a; done; cd ..'

sbin/% : %.c
	$(CC) -o $@ -pthread -static $<

dev proc sys data:
	mkdir -p dev proc sys data

.PHONY: arm64
arm64:
	$(MAKE) CC=aarch64-linux-gnu-gcc QEMU=qemu-aarch64

x86:
	$(MAKE)

clean: 
	rm -f initrd.cpio *~ \#*
