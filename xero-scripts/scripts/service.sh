#!/bin/bash
set -e

##################################################################################################################
# Written to be used on 64 bits computers
# Author   :   DarkXero
# Website  :   http://xerolinux.xyz
##################################################################################################################

# Function to check and install gum if not present
check_gum() {
  command -v gum >/dev/null 2>&1 || { echo >&2 "Gum is not installed. Installing..."; sudo pacman -S --noconfirm gum; }
}

# Function to display the menu
display_menu() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "Fixes/Tweaks"
  echo
  gum style --foreground 33 "Hello $USER, what would you like to do today?"
  echo
  gum style --foreground 35 "1.  Install & Activate Firewalld."
  gum style --foreground 35 "2.  Clear Pacman Cache (Free Space)."
  gum style --foreground 35 "3.  Restart PipeWire/PipeWire-Pulse."
  gum style --foreground 35 "4.  Unlock Pacman DB (In case of DB error)."
  gum style --foreground 35 "5.  Activate v4l2loopback for OBS-VirtualCam."
  gum style --foreground 35 "6.  Activate Flatpak Theming (Required If used)."
  gum style --foreground 35 "7.  Install/Activate Power Daemon for Laptops/Desktops."
  gum style --foreground 35 "8.  Install Collection of XeroLinux's Fix Scripts (Optional)."
  gum style --foreground 35 "9.  Install XeroLinux Grub/GPU Hooks (Advanced Grub Users Only)."
  echo
  gum style --foreground 35 "d. Fix Discover PackageKit issue."
  gum style --foreground 35 "m. Update Arch Mirrorlist, for faster download speeds."
  gum style --foreground 35 "g. Fix Arch GnuPG Keyring in case of pkg signature issues."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
  echo
}

# Function for each task
install_firewalld() {
  sudo pacman -S --needed --noconfirm firewalld python-pyqt5 python-capng
  sudo systemctl enable --now firewalld.service
  gum style --foreground 35 "##########  All Done, Enjoy!    ##########"
  sleep 3
  restart_script
}

clear_pacman_cache() {
  sudo pacman -Scc
  sleep 2
  restart_script
}

restart_pipewire() {
  gum style --foreground 35 "##########  Restarting PipeWire   ##########"
  sleep 1.5
  systemctl --user restart pipewire
  systemctl --user restart pipewire-pulse
  sleep 1.5
  gum style --foreground 35 "##########  All Done, Try now  ##########"
  sleep 2
  restart_script
}

unlock_pacman_db() {
  sudo rm /var/lib/pacman/db.lck
  sleep 2
  restart_script
}

activate_v4l2loopback() {
  gum style --foreground 35 "##########    Setting up v4l2loopback   ##########"
  sudo pacman -S --noconfirm --needed v4l2loopback-dkms v4l2loopback-utils
  echo "v4l2loopback" | sudo tee /etc/modules-load.d/v4l2loopback.conf > /dev/null
  echo 'options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Camera"' | sudo tee /etc/modprobe.d/v4l2loopback.conf > /dev/null
  gum style --foreground 35 "Please reboot your system for changes to take effect."
  sleep 2
  restart_script
}

activate_flatpak_theming() {
  gum style --foreground 35 "##########    Activating Flatpak Theming.    ##########"
  sudo flatpak override --filesystem="$HOME/.themes"
  sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
  sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
  gum style --foreground 35 "##########     Flatpak Theming Activated     ##########"
  sleep 3
  restart_script
}

install_power_daemon() {
  sudo pacman -S --needed --noconfirm power-profiles-daemon
  sudo systemctl enable --now power-profiles-daemon
  sudo groupadd power && sudo usermod -aG power "$(whoami)"
  sleep 2
  restart_script
}

install_fix_scripts() {
  sudo pacman -S --needed --noconfirm xero-fix-scripts
  sleep 2
  restart_script
}

install_grub_hooks() {
  sudo pacman -S --needed --noconfirm grub-hooks xero-hooks
  sudo mkinitcpio -P && sudo grub-mkconfig -o /boot/grub/grub.cfg
  sleep 2
  restart_script
}

fix_discover_issue() {
  gum style --foreground 35 "##########    Fixing Discover's PackageKit issue    ##########"
  sleep 3
  if [ -f "/usr/share/polkit-1/actions/org.freedesktop.packagekit.policy" ]; then
    sudo mv /usr/share/polkit-1/actions/org.freedesktop.packagekit.policy /usr/share/polkit-1/actions/org.freedesktop.packagekit.policy.old
  fi
  sudo pacman -S --needed --noconfirm packagekit-qt6
  gum style --foreground 35 "##########    Done! Discover should work now.   ##########"
  sleep 3
  restart_script
}

update_mirrorlist() {
  gum style --foreground 35 "##########     Updating Mirrors To Fastest Ones     ##########"
  sudo pacman -S --noconfirm --needed reflector
  sudo reflector --verbose -phttps -f10 -l10 --sort rate --save /etc/pacman.d/mirrorlist && sudo pacman -Syy
  gum style --foreground 35 "##########    Done! Updating should go faster   ##########"
  sleep 3
  restart_script
}

fix_gpg_keyring() {
  gum style --foreground 35 "##########   Fixing Pacman Databases..   ##########"
  sleep 2
  gum style --foreground 35 "Step 1 - Deleting Existing Keys.."
  sudo rm -r /etc/pacman.d/gnupg/*
  sleep 2
  gum style --foreground 35 "Step 2 - Populating Keys.."
  sudo pacman-key --init && sudo pacman-key --populate
  sleep 2
  gum style --foreground 35 "Step 3 - Adding Ubuntu keyserver.."
  echo "keyserver hkp://keyserver.ubuntu.com:80" | sudo tee --append /etc/pacman.d/gnupg/gpg.conf
  sleep 2
  gum style --foreground 35 "Step 4 - Updating ArchLinux Keyring.."
  sudo pacman -Syy --noconfirm archlinux-keyring
  gum style --foreground 35 "##########    Done! Try Update now & Report     ##########"
  sleep 6
  restart_script
}

restart_script() {
  clear
  exec "$0"
}

main() {
  check_gum
  while :; do
    display_menu
    read -rp "Enter your choice: " CHOICE
    echo

    case $CHOICE in
      1) install_firewalld ;;
      2) clear_pacman_cache ;;
      3) restart_pipewire ;;
      4) unlock_pacman_db ;;
      5) activate_v4l2loopback ;;
      6) activate_flatpak_theming ;;
      7) install_power_daemon ;;
      8) install_fix_scripts ;;
      9) install_grub_hooks ;;
      d) fix_discover_issue ;;
      m) update_mirrorlist ;;
      g) fix_gpg_keyring ;;
      q) clear && exec xero-cli -m ;;
      *) gum style --foreground 31 "##########    Choose the correct number    ##########" ;;
    esac
  done
}

main
