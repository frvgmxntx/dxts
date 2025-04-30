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

- delete all existing partitions.
- create one for the EFI, another for root and one for the swap space.
- now it's time format all partitions, get the paths with:
```
$ fdisk -l
```
- for each path, format it as needed
```
$ mkfs.fat -F 32 /dev/PATH_TO_EFI
$ mkfs.btrfs /dev/PATH_TO_ROOT
$ mkswap /dev/PATH_TO_SWAP
```
- mount each partition and enable swap
```
$ mount /dev/PATH_TO_ROOT /mnt
$ mkdir /mnt/boot
$ mount /dev/PATH_TO_EFI /mnt/boot/
$ swapon /dev/PATH_TO_SWAP
```
- also create the subvolumes
```
$ btrfs su cr /mnt/@		# root subvolume
$ btrfs su cr /mnt/@home	# home subvolume
$ btrfs su cr /mnt/@snapshots	# snapshot subvolume
$ btrfs su cr /mnt/@log		# logs subvolume
$ btrfs su cr /mnt/@pkg		# pacman subvolume
```
- now unmount everything and remount with the subvolumes.
```
$ umount /mnt

# root
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

# mount the EFI
$ mount /dev/PATH_TO_EFI /mnt/boot

# enable SWAP
$ swapon /dev/PATH_TO_SWAP
```

- finally, is time to pacstrap core stuff

> best time to act like a wizard summoning an esoteric spell

```
$ pacstrap /mnt amd-ucode base base-devel btrfs-progs git linux linux-firmware linux-headers linux-lts neovim networkmanager reflector sudo
```

- now generate the fstab entries

```
$ genfstab -U /mnt >> /mnt/etc/fstab

# also check if everything is alright
$ cat /mnt/etc/fstab
```

- enter the installation directory
> aka doot doot the chroot

```
$ arch-chroot /mnt
```

- now set the zone info

```

```

6. Chroot into the system and symlink keyboard layout, language, and set time
7. Boot into the system.
8. pacman mirror
9. acer-wmi-battery
10. schedule fstrim
11. Bluetooth
12. Polkit
13. multilib repo
14. nvidia
15. paru
16. nbfc-linux
17. hyprland
18. uwsm
19. xdg-desktop-portal
20. zathura
21. zed
22. ollama
23. zen-browser & transparent-zen
24. snapper snap-sync

<h4 align="center"> Programs </h4>
pacstrap
amd-ucode app2unit-git base-devel fish git kitty linux linux-firmware linux-lts neovim network-manager noto-fonts-emoji nvidia nvidia-utils pipewire pipewire-alsa pipewire-jack pipewire-pulse sudo uwsm
other
7zip bat blueman bluez bluez-libs bluez-utils brightnessctl cava dart-sass fastfetch ffmpeg ffmpegthumbnailer file-roller gimp github-cli glances google-earth-pro gpu-screen-recorder grim gvfs hyprland hyprlock hyprpicker hyprpolkitagent imagemagick lutris mako matugen-bin mpv nbfc-linux nm-connection-editor ollama poppler pwvucontrol python qbittorrent rnote satty slurp swww-git thunar thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin thunar-volman torzu-git tree-sitter ttf-firacode-nerd tumbler tumbler-extra-thumbnailers udiskie unrar vesktop-bin walker-bin wine winetricks wireplumber wl-clipboard xdg-desktop-portal-hyprland yt-dlp zathura zathura-cb zathura-pdf-poppler zathura-ps zed zen-browser-bin zoxide



</details>

<summary><h3 align="center"> 💻 Terminal & Shell </h3></summary>

<summary><h3 align="center"> 💧 Hyprland </h3></summary>

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
