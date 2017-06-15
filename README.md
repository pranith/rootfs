Build x86 and arm64 test images
---

Fetch the latest kernel and build a bootable x86 or ARM64 image along with a busybox userspace.

To run, set the QEMU_BUILD_DIR environment variable in the run.sh script to your qemu build
directory before running it as follows.

	$ ./run.sh x86 or
	$ ./run.sh arm64
