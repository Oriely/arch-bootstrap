 #!/usr/bin/env sh

packages=(
    "cava"
    "gdlauncher-bin"
    "jellyfin-media-player"
    "lightdm-webkit-theme-aether"
    "macchina"
    "mugshot"
    "networkmanager-dmenu-git"
    "pfetch"
    "pipes.sh"
    "protonmail-bridge"
    "protonvpn"
    "spotify-tui"
    "wpgtk"
    "xone-dkms"
)


cd $HOME
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S ${packages[@]}