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

kernel_packages=(
	"base"
	"linux"
	"linux-lts"
	"linux-firmware"
	"linux-headers"
)

desktop_environment=(
#	"light-locker"
#	"lightdm"
#	"lightdm-gtk-greeter"
#	"lightdm-webkit2-greeter"
#	"i3-gaps"
#	"gnome"
#	"plasma"
)

network=(
#	"network-manager-applet"
	"networkmanager"
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
	#"refind"
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

shell_packages=(
	"nano"
	"ncmpcpp"
	"cmatrix"
	"htop"
	"zsh"
	"zsh-completions"
	"vim"
	"wget"
	"which"
	"calc"
	"ranger"
)

programming_packages=(
	"nodejs"
	"npm"
	"docker"
	"docker-compose"
)

packages=(
	"alacritty"
	"arandr"
	"bluez"
	"bluez-utils"
	"code"
	"discord"
	"dunst"
	"easyeffects"
	"firefox"
	"flameshot"
	"flatpak"
	"flatpak-builder"
	"font-manager"
	"gimp"
	"git"
	"gperftools"
	"gucharmap"
	"gzip"
	"keepassxc"
	"ntfs-3g"
	"onboard"
	"picom"
	"pipewire"
	"pipewire-jack"
	"pipewire-pulse"
	"polybar"
	"python-pywal"
	"refind"
	"retroarch"
	"rofi"
	"rofi-calc"
	"sed"
	"steam"
	"solaar"
	"spotifyd"
	"sudo"
	"thunderbird"
	"unzip"
	"udiskie"
	"wmctrl"
	"xdotool"
	"wireplumber"
	"xorg-xev"
	"xorg-xrdb"
	"xorg-xwininfo"
	"yt-dlp"
)

all_packages=(
	${desktop_environment[@]}
	${nvidia_graphics[@]}
	#${amd_graphics[@]}
	${bootloaders[@]}
	${shell_packages[@]}
	${programming_packages[@]}
	${network[@]}
	${packages[@]}
	${font_packages[@]}

)



# enable multilib in install medium
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Syy

# install base and linux kernel packages
pacstrap /mnt base base-devel ${all_packages[@]}


pacstrap /mnt ${all_packages[@]}

genfstab -U /mnt >> /mnt/etc/fstab

SCRIPT_DIR=/mnt/scripts
mkdir -p $SCRIPT_DIR
mv chroot.sh $SCRIPT_DIR
arch-chroot /mnt zsh /scripts/chroot.sh $ROOT_PART