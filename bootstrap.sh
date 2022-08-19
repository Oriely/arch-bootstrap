#!/usr/bin/env sh

ROOT_PART=/dev/sda3
EFI_PART=/dev/sda1
#SWAP_PART=/dev/sda4

mount ${ROOT_PART} /mnt

[[ -n ${SWAP_PART} ]] && swapon ${SWAP_PART}

if [[ -n ${EFI_PART} ]]; then
	mkdir -p /mnt/boot
	mount ${EFI_PART} /mnt/boot
fi

linux_packages=(
	"base"
	"linux"
	"linux-firmware"
	"linux-headers"

)

desktop_environment=(
	"light-locker"
	"lightdm"
	"lightdm-gtk-greeter"
	"lightdm-webkit2-greeter"
	"i3-gaps"
)

network=(
	"network-manager-applet"
	"networkmanager"
	"dhcpcd"
)

font_packages=(
	"adobe-source-han-sans-cn-fonts"
	"adobe-source-han-sans-jp-fonts"
	"adobe-source-han-sans-kr-fonts"
	"adobe-source-han-serif-jp-fonts"
	"ttf-liberation"
	"wqy-zenhei"
)

bootloaders=(
	#"grub"
	"refind"
)

nvidia_graphics=(
	"nvidia"
	"nvidia-settings"
	"nvidia-utils"
)

amd_graphics=(
	"mesa"
	"lib32-mesa"
	"xf86-video-amdgpu"
	"vulkan-radeon"
	"lib32-vulkan-radeon"
	"libva-mesa-driver"
)

packages=(
	"alacritty"
	"arandr"
	"blueberry"
	"bluez"
	"bluez-utils"
	"calc"
	"cmatrix"
	"code"
	"conky"
	"conky-manager"
	"discord"
	"docker"
	"docker-compose"
	"dunst"
	"easyeffects"
	"feh"
	"firefox"
	"flameshot"
	"flatpak"
	"flatpak-builder"
	"font-manager"
	"gimp"
	"git"
	"gnome-keyring"
	"gparted"
	"gperftools"
	"gucharmap"
	"gzip"
	"htop"
	"jre17-openjdk-headless"
	"jre8-openjdk-headless"
	"keepassxc"
	"libreoffice-still"
	"lxappearance-gtk3"
	"mopidy"
	"mpd"
	"nano"
	"ncmpcpp"

	"nodejs"
	"npm"
	"ntfs-3g"

	"onboard"
	"openresolv"
	"pavucontrol"
	"picom"
	"pipewire"
	"pipewire-jack"
	"pipewire-pulse"
	"polybar"
	"python-pywal"
	"ranger"
	"refind"
	"retroarch"
	"rofi"
	"rofi-calc"
	"sed"
	"steam"
	"solaar"
	"spotifyd"
	"sudo"
	"thunar"
	"thunar-archive-plugin"
	"thunar-volman"
	"thunderbird"
	"tumbler"
	"unzip"
	"udiskie"
	"vim"
	"wget"
	"which"
	"wmctrl"
	"xarchiver"
	"xdotool"
	"xfce4-power-manager"
	"wireplumber"
	"xorg-xev"
	"xorg-xrdb"
	"xorg-xwininfo"
	"yt-dlp"
	"zsh"
)

all_packages=(
	${desktop_environment[@]}
	${nvidia_graphics[@]}
	#${amd_graphics[@]}
	${bootloaders[@]}
	${network[@]}
	${packages[@]}
	${font_packages[@]}

)


# install base and linux kernel packages
pacstrap /mnt base base-devel ${all_packages[@]}

# Enable multilib

timedatectl set-ntp true

pacstrap /mnt ${all_packages[@]}

genfstab -U /mnt >> /mnt/etc/fstab

SCRIPT_DIR=/mnt/scripts
mkdir -p $SCRIPT_DIR
mv chroot.sh $SCRIPT_DIR
arch-chroot /mnt zsh /scripts/chroot.sh $ROOT_PART