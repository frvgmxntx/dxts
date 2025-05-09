<div align="center">
<img alt="Avatar Icon" src="./screens/avatar.png" width="200" height="200"/>
</div>
<h1 align="center">frvg's .s! (WIP)</h1>
<div align="center">
<img src="https://img.shields.io/badge/OS-Arch%20Linux-1793d1?style=flat-square&logo=linux&logoColor=ffffff" alt="OS" />
<img src="https://img.shields.io/badge/WM-Hyprland-885A89?style=flat-square&logo=wayland&logoColor=ffffff" alt="WM" />
<img src="https://img.shields.io/badge/License-GPL--3.0-52AA5E?style=flat-square&logo=googledocs&logoColor=ffffff" alt="License" />
<img src="https://img.shields.io/badge/Made%20With-Love-EB5E55?style=flat-square&logo=macys&logoColor=ffffff" alt="Made with" />
</div>

<h1 align="center"> ✨ Introduction ✨ </h1>
This repository contains my <em>personal</em> daily driver setup, customized for a balance between aesthetics and usability. The focus is on creating a smooth, visually appealing experience with glass-like transparency effects and dynamic theming. While built around my own workflow, it's open for anyone who enjoys a polished and fluid environment. Feel free to fork or open a pull request!

> 10% functionality, 90% vibes ✌️.

<summary><h2 align="center"> 📋 Overview </h2></summary>

<details>

<summary><h3 align="center"> ⚙️ Install Arch </h3></summary>

> did you read the word ***personal*** in the intro?

After making the Arch ISO bootable USB, plug in the notebook and turn it on while booting from the pendrive. In the Arch screen choose installation.

1. Set the keyboard layout

```
$ localectl list-keymaps	# will list all keymaps
$ loadkeys KEYMAP		# will load selected keymap
$ setfont ter-132b		# will set a font suitable for HiDPI screen
```

2. Connect to the internet

```
$ iwctl
[iwd]$ device list				# get wireless device name
[iwd]$ device DEVICE set-property Powered on	# turn device on
[iwd]$ station DEVICE scan			# turn scan on
[iwd]$ station DEVICE get-networks		# list networks
[iwd]$ station DEVICE connect NETWORK		# connect to network
[iwd]$ exit					# to exit
```
3. Set correct time

```
$ timedatectl list-timezones		# list timezones
$ timedatectl set-timezone TIMEZONE	# set timezone
$ timedatectl status			# check current RTC mode
$ timedatectl set-local-rtc BOOL	# change RTC mode (set as UTC)
$ timedatectl set-ntp BOOL		# start time sync daemon
```

4. Partition the disk and mount it

```
$ cfdisk # will start the fdisk TUI
```

- delete all existing partitions
- create one for the EFI, another for root and one for the swap space
- now it's time format all partitions, get the paths with:
```
$ fdisk -l
```
- for each path, format it as needed
```
$ mkfs.fat -F 32 /dev/PATH_TO_EFI
$ mkfs.btrfs /dev/PATH_TO_ROOT # or mkfs.xfs
$ mkswap /dev/PATH_TO_SWAP
```
- mount each partition and enable swap
```
$ mount /dev/PATH_TO_ROOT /mnt
$ mkdir /mnt/boot
$ mount /dev/PATH_TO_EFI /mnt/boot/
$ swapon /dev/PATH_TO_SWAP
```
- also create the subvolumes (btrfs only)
```
$ btrfs su cr /mnt/@		# root subvolume
$ btrfs su cr /mnt/@home	# home subvolume
$ btrfs su cr /mnt/@snapshots	# snapshot subvolume
$ btrfs su cr /mnt/@log		# logs subvolume
$ btrfs su cr /mnt/@pkg		# pacman subvolume
```
- now unmount everything and remount with the subvolumes
```
$ umount /mnt

# root (if btrfs)
$ mount -o noatime,compress=zstd:1,ssd,space_cache=v2,subvol=@ /dev/PATH_TO_ROOT /mnt

# create the directories to be mounted
$ mkdir -p /mnt/{boot,home,.snapshots}
$ mkdir -p /mnt/var/log
$ mkdir -p /mnt/var/pacman/pkg

# mount the subvolumes
$ mount -o noatime,compress=zstd:1,ssd,space_cache=v2,subvol=@home /dev/PATH_TO_ROOT /mnt/home
$ mount -o noatime,compress=zstd:1,ssd,space_cache=v2,subvol=@snapshots /dev/PATH_TO_ROOT /mnt/.snapshots
$ mount -o noatime,compress=zstd:1,ssd,space_cache=v2,subvol=@log /dev/PATH_TO_ROOT /mnt/var/log
$ mount -o noatime,compress=zstd:1,ssd,space_cache=v2,subvol=@pkg /dev/PATH_TO_ROOT /mnt/pkg

# if on XFS just do
$ mount /dev/PATH_TO_ROOT /mnt

# mount the EFI
$ mount /dev/PATH_TO_EFI /mnt/boot

# enable SWAP
$ swapon /dev/PATH_TO_SWAP
```

Finally, is time to pacstrap core stuff.

> best time to act like a wizard summoning an esoteric spell

```
$ pacstrap /mnt amd-ucode base base-devel [btrfs-progs (if on btrfs)] linux linux-firmware linux-headers linux-lts neovim networkmanager sudo [xfsprogs (if on xfs)]
```

Also generate the fstab entries.

```
$ genfstab -U /mnt >> /mnt/etc/fstab

# also check if everything is alright
$ cat /mnt/etc/fstab
```

Enter the installation directory to setup the system.

```
$ arch-chroot /mnt
```

1. Set the timezone and sync the clock.

```
$ ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
$ hwclock --systohc
```

2. Generate the locales info.

```
# find and uncomment en_US.UTF-8
$ nvim /etc/locale.gen
# then run
$ locale-gen
```
- now edit /etc/locale.conf to become
```
LANG=en_US.UTF-8
```
- also edit /etc/vconsole.conf
```
KEYMAP=us
```

3. Add btrfs or xfs module to kernel by editing /etc/mkinitcpio.conf.
```
...
MODULES=(btrfs) # or xfs
...
```
- then run
```
$ mkinitcpio -p linux
```

4. Set the host name by editing /etc/hostname.
```
nitro-arch
```
- also edit /etc/hosts
```
127.0.0.1	localhost
::1		localhost
127.0.1.1	nitro-arch.localdomain	nitroarch
```

5. Add sudo password.
```
$ passwd
```

6. Install the bootloader.
```
$ bootctl --path=/boot install
```
- now edit the /boot/loader.conf file
```
timeout 0
console-mode auto
editor no
default @saved
```
- create the /boot/loader/entries/arch.conf file
```
title	Arch Linux
linux	/vmlinuz-linux
initrd	/initramfs-linux.img
options	root=/dev/PATH_TO_ROOT rw
```

7. Get more packages.
```
$ pacman -S efibootmgr nm-connection-editor [snapper (if on btrfs only)] wpa_supplicant xdg-utils
```

8. Enable networkmanager.
```
$ systemctl enable NetworkManager
```

9. Create a new user.
```
$ useradd -mG wheel frvg
$ passwd frvg
```
- now add the user to the sudoers, first run
```
$ EDITOR=nvim visudo
```
- then uncomment the line
```
%wheel ALL=(ALL) ALL
```

10. Boot into the system.
```
$ exit
$ umount -a
$ reboot
```

11. Connect to the wifi again.
```
$ nmtui
```

12. Config pacman.
```
$ EDITOR=nvim sudoedit /etc/pacman.conf
```

- find and uncomment the lines:

```
...
Color
ILoveCandy
CheckSpace
...
```

- enable parallel downloads

```
...
ParallelDownloads = 50
...
```

- enable multilib repo (for gaming)

```
...
[multilib]
Include = /etc/pacman.d/mirrorlist
...
```

- also edit the mirrorlist

```
$ EDITOR=nvim sudoedit /etc/pacman.d/mirrorlist
```

- add the following mirrors

```
Server = http://mirror.ufscar.br/archlinux/$repo/os/$arch
Server = https://mirror.ufscar.br/archlinux/$repo/os/$arch
Server = http://archlinux.c3sl.ufpr.br/$repo/os/$arch
Server = https://archlinux.c3sl.ufpr.br/$repo/os/$arch
Server = http://www.caco.ic.unicamp.br/archlinux/$repo/os/$arch
Server = https://www.caco.ic.unicamp.br/archlinux/$repo/os/$arch
Server = http://br.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://br.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://linorg.usp.br/archlinux/$repo/os/$arch
Server = http://archlinux.pop-es.rnp.br/$repo/os/$arch
Server = http://mirror.ufam.edu.br/archlinux/$repo/os/$arch
Server = http://mirrors.ic.unicamp.br/archlinux/$repo/os/$arch
Server = https://mirrors.ic.unicamp.br/archlinux/$repo/os/$arch
```

- then refresh all mirrors

```
$ sudo pacman -Syyu
```

- also it's a good idea to set a hook to update systemd-boot, to do so create the file in /etc/pacman.d/hooks/

```
$ EDITOR=nvim sudoedit /etc/pacman.d/hooks/95-systemd-boot.hook
```

- and add the following content

```
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Gracefully upgrading systemd-boot...
When = PostTransaction
Exec = /usr/bin/systemctl restart systemd-boot-update.service
```

13. Schedule fstrim.

- just enable the systemd timer

```
$ sudo systemctl enable fstrim.timer
```

14. Config git

```
$ sudo pacman -Syu git github-cli
$ git config --global user.name "frvgmxntx"
$ git config --global user.email "gnavelino@estudante.ufscar.br"
$ gh auth login
```

15. Install AUR helper.

```
$ git clone https://aur.archlinux.org/paru.git
$ cd paru && makepkg -si
```

- enable paru to clean after

```
$ EDITOR=nvim sudoedit /etc/paru.conf
```

- find and uncomment the line
- 
```
...
CleanAfter
...
```

16. Get sound.

```
$ sudo pacman -Syu pipewire lib32-pipewire wireplumber pwvucontrol pipewire-audio pipewire-alsa pipewire-jack pipewire-pulse && reboot

```

17. Get bluetooth.

```
$ sudo pacman -Syu bluez bluez-utils blueman
$ sudo systemctl enable --now bluetooth.service
```

18. Setup fan control.

- first install nbfc-linux from AUR

```
$ paru -Syu nbfc-linux
```

- then copy the configuration file from the repo to the config folder

```
$ cp dxts/nbfc/'Acer Nitro AN515-44.json' /usr/share/nbfc/configs
```

- apply the config and start the service

```
$ sudo nbfc config -a 'Acer Nitro AN515-44'
```

19. Setup battery charge limit.

- compile the module

```
$ git clone https://github.com/frederik-h/acer-wmi-battery.git
$ cd acer-wmi-battery && make
```

- copy the module to the loader directory

```
$ sudo mkdir /lib/modules/$(uname -r)/kernel/acer  
$ cp acer-wmi-battery.ko /lib/modules/$(uname -r)/kernel/acer/
```

- create the module loader file

```
$ EDITOR=nvim sudoedit /etc/modules-load.d/acer-wmi-battery.conf
```

- add the following line

```
acer-wmi-battery
```

- create the modprobe file

```
$ EDITOR=nvim sudoedit /etc/modprobe.d/acer-wmi-battery.conf
```

- add the following line

```
options acer-wmi-battery enable_health_mode=1
```

- update kernel modules dependencies info

```
$ sudo depmod -a
```

20. Setup nvidia drivers (GTX 1650 Mobile / Max-Q | TU117).

- get the drivers

```
$ sudo pacman -Syu nvidia-open nvidia-utils
```

> *yeah it's this simple.*

21. Set auto login on tty.

- create the auto auto login service for tty1

```
$ sudo mkdir /etc/systemd/system/getty@tty.service.d
```

- create an autologin.conf file

```
$ cd /etc/systemd/system/getty@tty.service.d
$ EDITOR=nvim sudoedit autologin.conf
```

- add the following content

```
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin frvg %I $TERM
Type=simple
```

- also create the skip prompt file

```
$ EDITOR=nvim sudoedit skip-prompt.conf
```

- add the following content

```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue --autologin frvg --noclear %I $TERM
```

22. Set quiet boot.

- just add this parameters to /boot/loader/entries/*_linux.conf

```
...
options	root=/dev/PATH_TO_ROOT rw quiet nowatchdogs loglevel=3 systemd.show_status=auto rd.udev.log_level=3
...
```

<h4 align="center"> Programs </h4>
pacstrap
app2unit-git fish kitty noto-fonts-emoji uwsm
other
7zip bat brightnessctl cava dart-sass fastfetch ffmpeg ffmpegthumbnailer file-roller gimp glances google-earth-pro gpu-screen-recorder grim gvfs hyprland hyprlock hyprpicker hyprpolkitagent imagemagick lutris mako matugen-bin mpv nm-connection-editor ollama poppler python qbittorrent rnote satty slurp swww-git thunar thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin thunar-volman torzu-git tree-sitter ttf-firacode-nerd tumbler tumbler-extra-thumbnailers udiskie unrar vesktop-bin walker-bin wine winetricks wl-clipboard xdg-desktop-portal-hyprland yt-dlp zathura zathura-cb zathura-pdf-poppler zathura-ps zed zen-browser-bin zoxide



</details>

<summary><h3 align="center"> 💻 Terminal & Shell </h3></summary>

<details>

<summary><h3 align="center"> 💧 Hyprland </h3></summary>

17. hyprland
18. Polkit
18. uwsm
19. xdg-desktop-portal

</details>

<summary><h3 align="center"> 🎨 Matugen </h3></summary>

<summary><h3 align="center"> 🧰 Waybar </h3></summary>

<summary><h3 align="center"> 🍃 Zen Browser </h3></summary>

<summary><h3 align="center"> 🖼️ GTK & QT Themes </h3></summary>

<h1 align="center"> ✨ Showcase ✨ </h1>

<div align="center">

<img src="./screens/screen-firewatch.gif" alt="desktop with rainy firewatch game wallpaper">

</div>

<div align="center">

<img src="./screens/screen-grass.gif" alt="desktop with moving grass wallpaper">

</div>

<div align="center">

<img src="./screens/screen-moon.gif" alt="desktop with moving moon and clouds illustration wallpaper">

</div>

<h1 align="center"> ✨ Thank You Section ✨ </h1>

<h4>

❤️ [Matugen](https://github.com/InioX/matugen "give ini a star!") - A material you color generation tool.

</h4>

> shoutout to the giants whose shoulders I'm standing on 🙏.
