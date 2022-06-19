# NixOS on UTM

This repository contains configurations & scripts that allows
running NixOS on UTM(QEMU).

## Getting Started

Download minimal NixOS ISO image.

In UTM, create a new VM using "Other" as system, and choose
the downloaded NixOS ISO image.

Preverse pretty much all of the default configurations
unless you have custom requirements, such as CPU cores, memory, etc.

Boot the VM and follow the instructions in
[NixOS Installation Summary] guide:

* Run all commands "Partition schemes for NixOS on /dev/sda (UEFI)".
* Run "Commands for installing NixOS on /dev/sda".
  * **Import Note**: Before running `reboot`, remove ISO in the UTM.

After rebooting the OS, you can now use the NixOS.
