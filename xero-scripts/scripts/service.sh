#!/usr/bin/env bash
set -e

######################################
# Author   :   DarkXero              #
# Website  :   http://xerolinux.xyz  #
######################################

# Set window title
echo -ne "\033]0;Fixes & Tweaks\007"

# Function to check and install gum if not present
check_gum() {
  command -v gum >/dev/null 2>&1 || { echo >&2 "Gum is not installed. Installing..."; sudo pacman -S --noconfirm gum; }
}

# Function to display the menu
display_menu() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "System Fixes & Tweaks"
  echo
  gum style --foreground 33 "Hello $USER, what would you like to do today?"
  echo
  gum style --foreground 35 "1.  Install & Activate Firewalld."
  gum style --foreground 35 "2.  Clear Pacman Cache (Free Space)."
  gum style --foreground 35 "3.  Restart PipeWire/PipeWire-Pulse."
  gum style --foreground 35 "4.  Unlock Pacman DB (In case of DB error)."
  gum style --foreground 35 "5.  Activate v4l2loopback for OBS-VirtualCam."
  gum style --foreground 35 "6.  Install XeroLinux Grub/GPU Hooks (Optional)."
  echo
  gum style --foreground 227 "w. WayDroid Installation Guide."
  gum style --foreground 196 "f. Frogging Family/TKG nVidia-All Tool (Advanced)."
  gum style --foreground 159 "m. Update Arch Mirrorlist, for faster download speeds."
  gum style --foreground 46 "g. Fix Arch GnuPG Keyring in case of pkg signature issues."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
}

# Function to handle errors and prompt user
handle_error() {
  echo
  gum style --foreground 196 "An error occurred. Would you like to retry or go back to the main menu? (r/m)"
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

# Function for each task
install_firewalld() {
  sudo pacman -S --needed --noconfirm firewalld python-pyqt5 python-capng
  sudo systemctl enable --now firewalld.service
  gum style --foreground 35 "##########  All Done, Enjoy!  ##########"
  sleep 3
  exec "$0"
}

clear_pacman_cache() {
  sudo pacman -Scc
  sleep 2
  exec "$0"
}

restart_pipewire() {
  gum style --foreground 35 "##########  Restarting PipeWire   ##########"
  sleep 1.5
  systemctl --user restart pipewire
  systemctl --user restart pipewire-pulse
  sleep 1.5
  gum style --foreground 35 "##########  All Done, Try now  ##########"
  sleep 2
  exec "$0"
}

unlock_pacman_db() {
  sudo rm /var/lib/pacman/db.lck
  sleep 2
  exec "$0"
}

activate_v4l2loopback() {
  gum style --foreground 35 "##########    Setting up v4l2loopback   ##########"
  sudo pacman -S --noconfirm --needed v4l2loopback-dkms v4l2loopback-utils
  echo "v4l2loopback" | sudo tee /etc/modules-load.d/v4l2loopback.conf > /dev/null
  echo 'options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Camera"' | sudo tee /etc/modprobe.d/v4l2loopback.conf > /dev/null
  echo
  gum style --foreground 35 "Please reboot your system for changes to take effect."
  sleep 2
  exec "$0"
}

install_grub_hooks() {
  sudo pacman -S --needed --noconfirm grub-hooks xero-hooks
  sudo mkinitcpio -P && sudo grub-mkconfig -o /boot/grub/grub.cfg
  sleep 2
  exec "$0"
}

waydroid_guide() {
  gum style --foreground 36 "Opening Guide..."
  sleep 3
  xdg-open "https://xerolinux.xyz/posts/waydroid-guide/" > /dev/null 2>&1
  sleep 3
  exec "$0"
}

tkg_script() {
  gum style --foreground 36 "Cloning & Running Script..."
  sleep 3
  cd ~ && git clone https://github.com/Frogging-Family/nvidia-all
  cd ~/nvidia-all/ && makepkg -rsi
  cd ~ && sudo rm -rf ~/nvidia-all/
  sleep 3
  exec "$0"
}

update_mirrorlist() {
  gum style --foreground 69 "##########  Updating Mirrors To Fastest Ones  ##########"
  echo
  if ! command -v rate-mirrors &> /dev/null; then
    echo "rate-mirrors is not installed. Installing..."
    $AUR_HELPER -S --noconfirm --needed rate-mirrors-bin
  fi

  if gum confirm "Have you activated the Chaotic-AUR repos?"; then
    rate-mirrors --allow-root --protocol https arch | sudo tee /etc/pacman.d/mirrorlist
    echo
    rate-mirrors --allow-root --protocol https chaotic-aur | sudo tee /etc/pacman.d/chaotic-mirrorlist
  else
    rate-mirrors --allow-root --protocol https arch | sudo tee /etc/pacman.d/mirrorlist
  fi

  echo
  sudo pacman -Syy
  echo
  gum style --foreground 69 "########## Done! Updating should go faster ##########"
  sleep 3
  exec "$0"
}

fix_gpg_keyring() {
  gum style --foreground 69 "########## Fixing Pacman Databases.. ##########"
  sleep 2
  echo
  gum style --foreground 69 "Step 1 - Deleting Existing Keys.."
  sudo rm -r /etc/pacman.d/gnupg/*
  sleep 2
  echo
  gum style --foreground 69 "Step 2 - Populating Keys.."
  sudo pacman-key --init && sudo pacman-key --populate
  sleep 2
  echo
  gum style --foreground 69 "Step 3 - Adding Ubuntu keyserver.."
  echo
  echo "keyserver hkp://keyserver.ubuntu.com:80" | sudo tee --append /etc/pacman.d/gnupg/gpg.conf
  sleep 2
  gum style --foreground 69 "Step 4 - Updating ArchLinux Keyring.."
  echo
  sudo pacman -Syy --noconfirm archlinux-keyring
  echo
  gum style --foreground 69 "##########    Done! Try Update now & Report     ##########"
  sleep 6
  exec "$0"
}

main() {
  check_gum
  while :; do
    display_menu
    echo
    read -rp "Enter your choice: " CHOICE
    echo

    case $CHOICE in
      1) install_firewalld ;;
      2) clear_pacman_cache ;;
      3) restart_pipewire ;;
      4) unlock_pacman_db ;;
      5) activate_v4l2loopback ;;
      6) install_grub_hooks ;;
      w) waydroid_guide ;;
      f) tkg_script ;;
      m) update_mirrorlist ;;
      g) fix_gpg_keyring ;;
      q) clear && exec xero-cli -m ;;
      *)
        gum style --foreground 31 "Invalid choice. Please select a valid option."
        echo
        ;;
    esac
    sleep 3
  done
}

main
