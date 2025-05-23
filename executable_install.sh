#!/bin/bash

if [[ $EUID -eq 0 ]]; then
    USER_NAME="six"

    if ! id -u "$USER_NAME" > /dev/null 2>&1; then
	while true; do
	    read -s -p "Enter password for new user '$USER_NAME': " PASSWORD
	    echo
	    read -s -p "Confirm password: " CONFIRM_PASSWORD
	    echo

	    if [ "$PASSWORD" == "$CONFIRM_PASSWORD" ]; then
		break
	    else
		echo "Passwords do not match. Please try again."
	    fi
	done

	useradd -m -s /bin/bash "$USER_NAME"
	echo "$USER_NAME:$PASSWORD" | chpasswd	
    fi

    if ! grep -q "^$USER_NAME " /etc/sudoers; then
	echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    fi

    cp "$0" "/home/$USER_NAME/$0"
    chown "$USER_NAME:$USER_NAME" "/home/$USER_NAME/$0"
    reboot
fi


# Install yay
if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed base-devel -y
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install once-and-done software
sudo pacman -S --needed --noconfirm alacritty pipewire wireplumber wayland qt5-wayland qt6-wayland xorg-server xorg-server-common noto-fonts llvm llvm-libs meson wayland-protocols pcre2 json-c pango cairo gdk-pixbuf2 swaybg nvidia nvidia-dkms nvidia-utils vulkan-nouveau libdrm pixman polkit xdg-desktop-portal-wlr pipewire-jack waybar mpv uwsm otf-font-awesome python-pywal swaync code doublecmd-qt6 qt5ct qt6ct lxappearance zsh unzip libqalculate nwg-bar obsidian
yay -S --needed --noconfirm downgrade swayfx-nvidia wlroots libva-nvidia-driver clipman sway-screenshot rustup swaymgr wdisplays-git swayosd-git walker firefox coppwr-bin python-pywalfox hyprpicker nerd-fonts-git notion-calendar-electron notion-app-electron notion-calendar-widget nwg-look qogir-icon-theme materia-gtk-theme illogical-impulse-bibata-modern-classic-bin pfetch-rs-bin neovim

# Install Shell Environment
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
curl -s https://ohmyposh.dev/install.sh | bash -s
sudo chsh -s $(which zsh) ${USER}

# Install waybar-module-pomodoro
git clone https://github.com/Andeskjerf/waybar-module-pomodoro
cd waybar-module-pomodoro
rustup default stable
cargo build --release
cp target/release/waybar-module-pomodoro ~/.local/bin
sudo ln -s ~/.local/bin/waybar-module-pomodoro /usr/bin/waybar-module-pomodoro
cd ..
rm -rf waybar-module-pomodoro

# Finish up
sudo systemctl set-default graphical.target
sudo systemctl enable swayosd-libinput-backend.service
sudo usermod -a -G video $USER
pywalfox install && sudo pywalfox install
