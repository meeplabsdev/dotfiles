# Install yay
if ! command -v yay > /dev/null; then
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -r yay
fi
