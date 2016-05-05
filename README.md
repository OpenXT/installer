This is the OpenXT installer.

It is divided in 2 parts:
- part1, the core, that bootstraps the installation by downloading all the required packages from a repository, including the "control" tarball, which contains the second part.
- part2, the actual installation scripts, will verify and write the various OpenXT components to the disk, using LVMs, and setup Grub to boot OpenXT.

The installer can be used to either do a fresh install, an upgrade, or even an over-the-air upgrade.
For over-the-air upgrade, only part2 is used, and updatemgr takes care of the bootstrapping.

The installer can be started as a simple kernel + initramfs (part1), using any Linux-compatible bootloader on any media (including PXE).
It can be more or less interactive depending on how much information is filled in the answer file.
