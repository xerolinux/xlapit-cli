#!/usr/bin/env bash
#set -eu

######################################
# Author   :   DarkXero              #
# Website  :   http://xerolinux.xyz  #
######################################

# Function to check if the repository is enabled
is_repo_enabled() {
    grep -q "\[chaotic-aur\]" /etc/pacman.conf
}

# Function to add the Chaotic-AUR repository
add_chaotic_aur() {
    gum style --foreground 69 "Adding Chaotic-AUR Repository..."
    sleep 2
    echo
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    echo -e '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf
    sudo pacman -Syy
    gum style --foreground 69 "Chaotic-AUR Repository added!"
    sleep 3
    exec "$0"
}

# Check if the repository is already enabled
if is_repo_enabled; then
    gum style --foreground 69 "Chaotic-AUR repository is already enabled."
else
    # Add the repository
    add_chaotic_aur
fi

echo
echo "Proceeding with other tasks..."
# Add any additional commands you want to run after adding the repository
