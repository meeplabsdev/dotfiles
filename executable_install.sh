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

# Install mesa
if ! pacman -Q mesa | grep -q "1:24.2.7-1"; then
    curl -O "https://archive.archlinux.org/packages/m/mesa/mesa-1:24.2.7-1-x86_64.pkg.tar.zst"
    sudo pacman -U --noconfirm "mesa-1:24.2.7-1-x86_64.pkg.tar.zst"
    if ! grep -q "^IgnorePkg.*mesa" "/etc/pacman.conf"; then
	sudo sed -i '/^#IgnorePkg/a IgnorePkg = mesa' "/etc/pacman.conf"
    fi
fi

# Install llvm
sudo pacman -S --noconfirm llvm18 llvm18-libs
if ! pacman -Q llvm | grep -q "18.1.8-5"; then
    curl -O "https://archive.archlinux.org/packages/l/llvm/llvm-18.1.8-5-x86_64.pkg.tar.zst"
    sudo pacman -U --noconfirm "llvm-18.1.8-5-x86_64.pkg.tar.zst"
    if ! grep -q "^IgnorePkg.*llvm" "/etc/pacman.conf"; then
	sudo sed -i '/^#IgnorePkg/a IgnorePkg = llvm' "/etc/pacman.conf"
    fi
fi

# Install once-and-done software
sudo pacman -S --needed --noconfirm kitty mako pipewire wireplumber xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland xorg-server xorg-server-common noto-fonts

# Install hyprland
if ! command -v hyprctl &> /dev/null; then
    sudo pacman -S --noconfirm hyprland nvidia-dkms nvidia-utils egl-wayland libva-nvidia-driver
fi
