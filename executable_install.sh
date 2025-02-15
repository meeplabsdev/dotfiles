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
    sudo -u "$USER_NAME" bash -c "cd /home/$USER_NAME && bash $0"
    exit 0
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
