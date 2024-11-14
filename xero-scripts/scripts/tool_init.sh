#!/usr/bin/env bash
#set -eu

######################################
# Author   :   DarkXero              #
# Website  :   http://xerolinux.xyz  #
######################################

# Set window title
echo -ne "\033]0;Initial System Setup\007"

# Function to display the menu
display_menu() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "Initial System Setup"
  echo
  gum style --foreground 141 "Hello $USER, please select an option. Press 'i' for the Wiki."
  echo
  gum style --foreground 46 "u. Update System (Simple/Extended/Adv.)."
  echo
  gum style --foreground 7 "1. Fix PipeWire & Bluetooth (Vanilla Arch)."
  gum style --foreground 7 "2. Activate Flathub Repositories (Vanilla Arch)."
  gum style --foreground 7 "3. Enable Multithreaded Compilation (Vanilla Arch)."
  gum style --foreground 7 "4. Install 3rd-Party GUI or TUI Package Manager(s)."
}

# Function to handle errors and prompt user
handle_error() {
  echo
  gum style --foreground 196 "An error occurred. Would you like to retry or exit? (r/e)"
  read -rp "Enter your choice: " choice
  case $choice in
    r|R) exec "$0" ;;
    e|E) exit 0 ;;
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
  xdg-open "https://wiki.xerolinux.xyz/xlapit/#system-setup" > /dev/null 2>&1
  clear && exec "$0"
}

# Function for each task
install_pipewire_bluetooth() {
  gum style --foreground 7 "Installing PipeWire/Bluetooth Packages..."
  sleep 2
  echo
  sudo pacman -Rdd --noconfirm jack2
  sudo pacman -S --needed --noconfirm gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-ugly gst-plugins-good libdvdcss alsa-utils alsa-firmware pavucontrol pipewire-jack lib32-pipewire-jack pipewire-support ffmpeg ffmpegthumbs ffnvcodec-headers
  sudo pacman -S --needed --noconfirm bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools
  sudo systemctl enable --now bluetooth.service
  gum style --foreground 7 "PipeWire/Bluetooth Packages installation complete!"
  sleep 3
  exec "$0"
}

install_topgrade_aio_updater() {
  if ! command -v topgrade &> /dev/null; then
    gum style --foreground 7 "Topgrade not installed, installing it..."
    sleep 2
    echo
    $AUR_HELPER -S --noconfirm --needed topgrade-bin
  fi
  gum style --foreground 7 "Running Topgrade..."
  topgrade
  echo
  gum style --foreground 7 "Done, Systemm updated."
  sleep 3
  exec "$0"
}

activate_flathub_repositories() {
  gum style --foreground 7 "Activating Flathub Repositories..."
  sleep 2
  echo
  sudo pacman -S --noconfirm --needed flatpak
  sudo flatpak remote-modify --default-branch=23.08 flathub system
  echo
  flatpak install io.github.flattool.Warehouse -y
  echo
  gum style --foreground 7 "##########    Activating Flatpak Theming.    ##########"
  sudo flatpak override --filesystem="$HOME/.themes"
  sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
  sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
  echo
  gum style --foreground 7 "##########     Flatpak Theming Activated     ##########"
  echo
  gum style --foreground 7 "Flathub Repositories activated! Please reboot."
  sleep 3
  exec "$0"
}

enable_multithreaded_compilation() {
  gum style --foreground 7 "Enabling Multithreaded Compilation..."
  sleep 2
  echo
  numberofcores=$(grep -c ^processor /proc/cpuinfo)
  if [ "$numberofcores" -gt 1 ]; then
    sudo sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$((numberofcores+1))\"/" /etc/makepkg.conf
    sudo sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -z - --threads=0)/" /etc/makepkg.conf
    sudo sed -i "s/COMPRESSZST=(zstd -c -z -q -)/COMPRESSZST=(zstd -c -z -q - --threads=0)/" /etc/makepkg.conf
    sudo sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar.zst'/" /etc/makepkg.conf
  fi
  gum style --foreground 7 "Multithreaded Compilation enabled!"
  sleep 3
  exec "$0"
}

install_gui_package_managers() {
  gum style --foreground 7 "Installing 3rd-Party GUI Package Managers..."
  sleep 2
  echo
  PACKAGES=$(dialog --checklist "Select GUI Package Managers to install:" 20 60 10 \
    "OctoPi" "Octopi Package Manager" off \
    "PacSeek" "PacSeek Package Manager" off \
    "BauhGUI" "Bauh GUI Package Manager" off \
    "EasyFlatpak" "Flatpak Package Manager" off 3>&1 1>&2 2>&3)
  for PACKAGE in $PACKAGES; do
    case $PACKAGE in
      "OctoPi") clear && $AUR_HELPER -S --needed octopi alpm_octopi_utils ;;
      "PacSeek") clear && $AUR_HELPER -S --needed pacseek-bin pacfinder ;;
      "BauhGUI") clear && $AUR_HELPER -S --needed bauh ;;
      "EasyFlatpak") clear && flatpak install org.dupot.easyflatpak -y ;;
    esac
  done
  gum style --foreground 7 "3rd-Party GUI Package Managers installation complete!"
  sleep 3
  exec "$0"
}

# Function to update system
update_system() {
    echo "Select an update option:"
    echo
    echo "1) Simple (Arch packages only)"
    echo "2) Extended (Arch, AUR, Flatpaks)"
    echo "3) Advanced (All in one updater, Risky!)"
    echo
    echo "4) Return to previous menu."
    echo
    read -rp "Enter your choice: " choice

    case $choice in
        1)
            sudo pacman -Syyu
            ;;
        2)
            $AUR_HELPER -Syyu
            flatpak update
            ;;
        3)
            echo
            gum style --foreground 196 "Warning: Using Topgrade can be destructive. Use at OWN RISK!"
            sleep 6
            echo
            install_topgrade_aio_updater
            ;;
        4)
            gum style --foreground 10 "Exiting..."
            ;;
        *)
            gum style --foreground 9 "Invalid option. Please try again."
            ;;
    esac
}

main() {
  while :; do
    display_menu
    echo
    read -rp "Enter your choice, or 'q' to return to main menu : " CHOICE
    echo

    case $CHOICE in
      i) open_wiki ;;
      1) install_pipewire_bluetooth ;;
      2) activate_flathub_repositories ;;
      3) enable_multithreaded_compilation ;;
      4) install_gui_package_managers ;;
      u) update_system ;;
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
