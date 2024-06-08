#!/bin/bash

# Set window title
echo -ne "\033]0;Gaming Tools\007"

# Function to check and install dependencies
check_dependency() {
  local dependency=$1
  command -v $dependency >/dev/null 2>&1 || { echo >&2 "$dependency is not installed. Installing..."; sudo pacman -S --noconfirm $dependency; }
}

# Function to display header
display_header() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "Gaming Tools & Launchers"
  echo
  gum style --foreground 33 "Hello $USER, select what gaming software to install. Press 'i' for the Wiki."
  echo
}

# Function to display options
display_options() {
  gum style --foreground 137 ".::: Native Packages :::."
  echo
  gum style --foreground 35 "1. Steam."
  gum style --foreground 35 "2. MangoHUD."
  gum style --foreground 35 "3. Game Mode."
  echo
  gum style --foreground 93 ".::: Flatpak Packages :::."
  echo
  gum style --foreground 35 "4. Heroic."
  gum style --foreground 35 "5. Lutris."
  gum style --foreground 35 "6. Bottles."
  gum style --foreground 35 "7. ProtonUp-QT."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
}

# Function to handle errors and prompt user
handle_error() {
  echo
  gum style --foreground 196 "An error occurred. Would you like to retry or go back to the main menu? (r/m)"
  read -rp "Enter your choice: " choice
  echo
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

# Function to install gaming packages
install_gaming_packages() {
  case $1 in
    steam)
      sudo pacman -S --noconfirm --needed steam
      ;;
    bottles)
      flatpak install -y com.usebottles.bottles
      ;;
    heroic)
      flatpak install -y com.heroicgameslauncher.hgl
      ;;
    lutris)
      flatpak install -y net.lutris.Lutris
      ;;
    emulators)
      flatpak install -y org.ppsspp.PPSSPP org.DolphinEmu.dolphin-emu org.flycast.Flycast org.pcsx2.PCSX2 org.citra_emu.citra
      ;;
    gamemode)
      sudo pacman -S --noconfirm --needed gamemode
      ;;
    mangohud)
      sudo pacman -S --noconfirm --needed mangohud lib32-mangohud
      ;;
    protonupQT)
      flatpak install -y net.davidotek.pupgui2
      ;;
    *)
      echo "Unknown package: $1"
      ;;
  esac
}

# Function to process user choice
process_choice() {
  while :; do
    echo
    read -rp "Enter your choice: " CHOICE
    echo

    case $CHOICE in
      i)
        gum style --foreground 33 "Opening Wiki..."
        sleep 3
        xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#gaming" > /dev/null 2>&1
        clear && exec "$0"
        ;;
      1)
        gum style --foreground 35 "Installing Steam..."
        sleep 2
        echo
        install_gaming_packages steam
        gum style --foreground 35 "Steam installation complete!"
        sleep 3
        echo
        echo "Patching VM.Max.MapCount"
        echo
        echo "vm.max_map_count=2147483642" | sudo tee /etc/sysctl.d/99-sysctl.conf >/dev/null
        sleep 6
        clear && exec "$0"
        ;;
      2)
        gum style --foreground 35 "Installing MangoHUD..."
        sleep 2
        echo
        install_gaming_packages mangohud
        gum style --foreground 35 "MangoHUD installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      3)
        gum style --foreground 35 "Installing Game Mode..."
        sleep 2
        echo
        install_gaming_packages gamemode
        gum style --foreground 35 "Game Mode installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      4)
        gum style --foreground 35 "Installing Heroic Games Launcher..."
        sleep 2
        echo
        install_gaming_packages heroic
        gum style --foreground 35 "Heroic Games Launcher installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      5)
        gum style --foreground 35 "Installing Lutris..."
        sleep 2
        echo
        install_gaming_packages lutris
        gum style --foreground 35 "Lutris installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      6)
        gum style --foreground 35 "Installing Bottles..."
        sleep 2
        echo
        install_gaming_packages bottles
        gum style --foreground 35 "Bottles installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      7)
        gum style --foreground 35 "Installing ProtonUp-QT..."
        sleep 2
        echo
        install_gaming_packages protonupQT
        gum style --foreground 35 "ProtonUp-QT installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      q)
        clear && exec xero-cli -m
        ;;
      *)
        gum style --foreground 50 "Invalid choice. Please select a valid option."
        echo
        ;;
    esac
    sleep 3
  done
}

# Main execution
check_dependency gum
display_header
display_options
process_choice
