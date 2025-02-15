#!/bin/bash

# Add "six" user
USER_NAME="six"
if ! id -u "$USER_NAME" > /dev/null 2>&1; then
    useradd -m -s /bin/bash "$USER_NAME"
fi

# Install yay
if ! command -v yay > /dev/null; then
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -r yay
fi
