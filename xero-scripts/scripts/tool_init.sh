#!/bin/bash
set -e

# Set window title
echo -ne "\033]0;Initial System Setup\007"

# Function to check and install gum if not present
check_gum() {
  command -v gum >/dev/null 2>&1 || { echo >&2 "Gum is not installed. Installing..."; sudo pacman -S --noconfirm gum; }
}

# Function to check and install dialog if not present
check_dialog() {
  command -v dialog >/dev/null 2>&1 || { echo >&2 "Dialog is not installed. Installing..."; sudo pacman -S --noconfirm dialog; }
}

# Function to display the menu
display_menu() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "Initial System Setup"
  echo
  gum style --foreground 142 "Hello $USER, please select an option. Press 'i' for the Wiki."
  echo
  gum style --foreground 35 "1. Fix PipeWire & Bluetooth (Vanilla Arch)."
  gum style --foreground 35 "2. Install Topgrade All-in-One Updater (Advanced)."
  gum style --foreground 35 "3. Activate Flathub Repositories (Vanilla Arch Only)."
  gum style --foreground 35 "4. Enable Fast Multithreaded Package Compilation (Makepkg)."
  gum style --foreground 35 "5. Install 3rd-Party GUI Package Manager (At Your Own Risk)."
  echo
  gum style --foreground 69 "6. Add & Enable the ChaoticAUR Repository (Recommended)."
  gum style --foreground 196 "7. Add & Enable the CachyOS Repositories (Advanced Users)."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
}

# Function to handle errors and prompt user
handle_error() {
  echo
  gum style --foreground 196 "An error occurred. Would you like to retry or go back to the main menu? (r/m)"
  echo
  read -rp "Enter your choice: " choice
  case $choice in
    r|R) exec "$0" ;;
    m|M) clear && exec xero-cli -m ;;
    *) gum style --foreground 50 "Invalid choice. Returning to menu." ;;
  esac
  sleep 3
  clear && exec "$0"
}

# Function to handle Ctrl+C
handle_interrupt() {
  echo
  gum style --foreground 190 "Script interrupted. Do you want to exit or restart the script? (e/r)"
  echo
  read -rp "Enter your choice: " choice
  echo
  case $choice in
    e|E) exit 1 ;;
    r|R) exec "$0" ;;
    *) gum style --foreground 50 "Invalid choice. Returning to menu." ;;
  esac
  sleep 3
  clear && exec "$0"
}

# Trap errors and Ctrl+C
trap 'handle_error' ERR
trap 'handle_interrupt' SIGINT

# Function to open Wiki
open_wiki() {
  gum style --foreground 33 "Opening Wiki..."
  sleep 3
  xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#system-setup" > /dev/null 2>&1
  clear and exec "$0"
}

# Function for each task
install_pipewire_bluetooth() {
  gum style --foreground 35 "Installing PipeWire/Bluetooth Packages..."
  sleep 2
  echo
  sudo pacman -S --needed --noconfirm gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-ugly gst-plugins-good libdvdcss alsa-utils alsa-firmware pavucontrol lib32-pipewire-jack pipewire-support ffmpeg ffmpegthumbs ffnvcodec-headers
  sudo pacman -S --needed --noconfirm bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools
  sudo systemctl enable --now bluetooth.service
  gum style --foreground 35 "PipeWire/Bluetooth Packages installation complete!"
  sleep 3
  exec "$0"
}

install_topgrade_aio_updater() {
  gum style --foreground 35 "Installing Topgrade..."
  sleep 2
  echo
  $AUR_HELPER -S --needed topgrade-bin
  topgrade
  echo
  gum style --foreground 35 "Done! Use topgrade command topdate. Risky !"
  sleep 3
  exec "$0"
}

activate_flathub_repositories() {
  gum style --foreground 35 "Activating Flathub Repositories..."
  sleep 2
  echo
  sudo pacman -S --noconfirm --needed flatpak
  sudo flatpak remote-modify --default-branch=23.08 flathub system
  echo
  gum style --foreground 35 "##########    Activating Flatpak Theming.    ##########"
  sudo flatpak override --filesystem="$HOME/.themes"
  sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
  sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
  echo
  gum style --foreground 35 "##########     Flatpak Theming Activated     ##########"
  echo
  gum style --foreground 35 "Flathub Repositories activated! Please reboot."
  sleep 3
  exec "$0"
}

enable_multithreaded_compilation() {
  gum style --foreground 35 "Enabling Multithreaded Compilation..."
  sleep 2
  echo
  numberofcores=$(grep -c ^processor /proc/cpuinfo)
  if [ "$numberofcores" -gt 1 ]; then
    sudo sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$((numberofcores+1))\"/" /etc/makepkg.conf
    sudo sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -z - --threads=0)/" /etc/makepkg.conf
    sudo sed -i "s/COMPRESSZST=(zstd -c -z -q -)/COMPRESSZST=(zstd -c -z -q - --threads=0)/" /etc/makepkg.conf
    sudo sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar.zst'/" /etc/makepkg.conf
  fi
  gum style --foreground 35 "Multithreaded Compilation enabled!"
  sleep 3
  exec "$0"
}

install_gui_package_managers() {
  gum style --foreground 35 "Installing 3rd-Party GUI Package Managers..."
  sleep 2
  echo
  PACKAGES=$(dialog --checklist "Select GUI Package Managers to install:" 20 60 10 \
    "OctoPi" "Octopi Package Manager" off \
    "PacSeek" "PacSeek Package Manager" off \
    "Pamac-All" "Pamac-All Package Manager" off \
    "BauhGUI" "Bauh GUI Package Manager" off 3>&1 1>&2 2>&3)
  for PACKAGE in $PACKAGES; do
    case $PACKAGE in
      "OctoPi") $AUR_HELPER -S --needed octopi alpm_octopi_utils ;;
      "PacSeek") $AUR_HELPER -S --needed pacseek-bin pacfinder ;;
      "Pamac-All") $AUR_HELPER -S --needed pamac-all pamac-cli libpamac-full ;;
      "BauhGUI") $AUR_HELPER -S --needed bauh ;;
    esac
  done
  gum style --foreground 35 "3rd-Party GUI Package Managers installation complete!"
  sleep 3
  exec "$0"
}

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

add_cachyos() {
  gum style --foreground 196 "Adding CachyOS Repositories..."
  sleep 2
  echo
  cd ~ && curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
  tar xvf cachyos-repo.tar.xz && cd ~/cachyos-repo
  sudo ./cachyos-repo.sh
  gum style --foreground 196 "CachyOS Repositories added!"
  sleep 3
  exec "$0"
}

main() {
  check_gum
  check_dialog
  while :; do
    display_menu
    echo
    read -rp "Enter your choice: " CHOICE
    echo

    case $CHOICE in
      i) open_wiki ;;
      1) install_pipewire_bluetooth ;;
      2) install_topgrade_aio_updater ;;
      3) activate_flathub_repositories ;;
      4) enable_multithreaded_compilation ;;
      5) install_gui_package_managers ;;
      6) add_chaotic_aur ;;
      7) add_cachyos ;;
      q) clear && exec xero-cli -m ;;
      *)
        gum style --foreground 50 "Invalid choice. Please select a valid option."
        echo
        ;;
    esac
    sleep 3
  done
}

main
