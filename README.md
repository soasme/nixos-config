# NixOS on UTM

This repository contains configurations & scripts that allows
running NixOS on UTM(QEMU).

## Getting Started

### Getting Started with Raspberry Pi

```
nixos-rebuild switch --flake github:soasme/nixos-config
```

### Getting Started with UTM


[![Run NixOS on macOS using UTM](https://img.youtube.com/vi/8gytY4ITSDA/0.jpg)](https://www.youtube.com/watch?v=8gytY4ITSDA)

Download minimal NixOS ISO image.

In UTM, create a new VM using "Other" as system, and choose
the downloaded NixOS ISO image.

Preverse pretty much all of the default configurations
unless you have custom requirements, such as CPU cores, memory, etc.

Boot the VM and follow the instructions in
[NixOS Installation Summary] guide:

* Run all commands "Partition schemes for NixOS on /dev/sda (UEFI)".
  ```
  # parted /dev/sda -- mklabel gpt
  # parted /dev/sda -- mkpart primary 512MiB -8GiB
  # parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
  # parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
  # parted /dev/sda -- set 3 esp on
  ```
* Run "Commands for installing NixOS on /dev/sda".
  ```
  # mkfs.ext4 -L nixos /dev/sda1
  # mkswap -L swap /dev/sda2
  # swapon /dev/sda2
  # mkfs.fat -F 32 -n boot /dev/sda3        # (for UEFI systems only)
  # mount /dev/disk/by-label/nixos /mnt
  # mkdir -p /mnt/boot                      # (for UEFI systems only)
  # mount /dev/disk/by-label/boot /mnt/boot # (for UEFI systems only)
  # nixos-generate-config --root /mnt
  # nano /mnt/etc/nixos/configuration.nix # install `vim`, `wget`, `git`, etc.
  # nixos-install
  ```
  * **Import Note**: Before running `reboot`, remove ISO in the UTM.
  * Reboot!

After rebooting the OS, you can now clone this repo and use the nixos-config:

```
$ git clone git@github.com:soasme/nixos-config.git
$ sudo nixos-rebuild switch --flake '/home/soasme/nixos-config'
```
