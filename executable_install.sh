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
sudo pacman -S --needed --noconfirm kitty pipewire wireplumber wayland qt5-wayland qt6-wayland xorg-server xorg-server-common noto-fonts llvm llvm-libs meson wayland-protocols pcre2 json-c pango cairo gdk-pixbuf2 swaybg nvidia nvidia-dkms nvidia-utils vulkan-nouveau libdrm pixman polkit xdg-desktop-portal-wlr pipewire-jack waybar mpv uwsm otf-font-awesome python-pywal swaync code 
yay -S --needed --noconfirm downgrade sway-nvidia wlroots libva-nvidia-driver swaylock-git swayidle-git clipman sway-screenshot rustup persway wdisplays-git swayosd-git wlogout walker firefox coppwr-bin python-pywalfox hyprpicker

# Finalise
sudo systemctl set-default graphical.target
sudo systemctl enable swayosd-libinput-backend.service
sudo usermod -a -G video $USER
pywalfox install && sudo pywalfox install

reboot
