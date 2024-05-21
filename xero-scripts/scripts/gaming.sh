#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author   :   DarkXero
# Website  :   http://xerolinux.xyz
##################################################################################################################

# Function to check and install dependencies
check_dependency() {
  local dependency=$1
  command -v $dependency >/dev/null 2>&1 || { echo >&2 "$dependency is not installed. Installing..."; sudo pacman -S --noconfirm $dependency; }
}

# Function to display header
display_header() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "The Gaming Essentials."
  echo
  gum style --foreground 33 "Hello $USER, what would you like to install? Press 'i' for the Wiki."
  echo
}

# Function to display options
display_options() {
  gum style --foreground 200 "################# Game Launchers #################"
  echo
  gum style --foreground 35 "s. Steam."
  gum style --foreground 35 "l. Lutris."
  gum style --foreground 35 "h. Heroic."
  gum style --foreground 35 "b. Bottles."
  echo
  gum style --foreground 215 "################### Game Tools ###################"
  echo
  gum style --foreground 35 "1. Mangohud."
  gum style --foreground 35 "2. Goverlay."
  gum style --foreground 35 "3. Protonup-qt."
  gum style --foreground 35 "4. Vulkan Layer (AMD)."
  gum style --foreground 35 "5. Vulkan Layer (nVidia)."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
  echo
}

# Function to handle selections
handle_selection() {
  local selection=$1
  local prompt=$2
  local commands=$3

  echo
  gum style --foreground 35 "##########   $prompt   ##########"
  echo
  eval "$commands"
  echo
  gum style --foreground 35 "##########   Done! Returning to main menu..   ##########"
  sleep 3
  clear && exec "$0"
}

# Function for native or flatpak installation options
native_or_flatpak_install() {
  local name=$1
  local native_command=$2
  local flatpak_command=$3

  gum style --foreground 33 "Native (Unofficial) or Flatpak (Official)?"
  echo
  select option in "Native" "Flatpak" "Back"; do
    case $option in
      Native)
        eval "$native_command"
        break
        ;;
      Flatpak)
        eval "$flatpak_command"
        break
        ;;
      Back)
        clear && exec "$0"
        break
        ;;
      *)
        gum style --foreground 31 "Invalid option. Please select 1, 2, or 3."
        ;;
    esac
  done
  handle_selection "$name" "$name Launcher Installed" ""
}

# Function to process user choice
process_choice() {
  while :; do
    read -rp "Enter your choice: " CHOICE
    echo

    case $CHOICE in
      i)
        xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#game-launchers" > /dev/null 2>&1
        clear && exec "$0"
        ;;
      s)
        handle_selection "s" "Installing Steam Launcher" "sudo pacman -S --noconfirm --needed steam; echo -e '@nClientDownloadEnableHTTP2PlatformLinux 0\n@fDownloadRateImprovementToAddAnotherConnection 1.0' > ~/.steam/steam/steam_dev.cfg"
        ;;
      l)
        native_or_flatpak_install "Lutris" "sudo pacman -S --noconfirm --needed lutris wine-meta; echo 'vm.max_map_count=2147483642' | sudo tee /etc/sysctl.d/99-sysctl.conf >/dev/null" "flatpak install net.lutris.Lutris"
        ;;
      h)
        native_or_flatpak_install "Heroic" "$AUR_HELPER -S --noconfirm --needed heroic-games-launcher-bin wine-meta" "flatpak install com.heroicgameslauncher.hgl"
        ;;
      b)
        native_or_flatpak_install "Bottles" "$AUR_HELPER -S --noconfirm --needed bottles wine-meta" "flatpak install com.usebottles.bottles"
        ;;
      1)
        handle_selection "1" "Installing Mangohud" "sudo pacman -S --noconfirm --needed mangohud"
        ;;
      2)
        handle_selection "2" "Installing Goverlay" "sudo pacman -S --noconfirm --needed goverlay"
        ;;
      3)
        native_or_flatpak_install "ProtonUp-QT" "$AUR_HELPER -S --noconfirm --needed protonup-qt wine-meta" "flatpak install net.davidotek.pupgui2"
        ;;
      4)
        handle_selection "4" "Installing DXVK-bin" "$AUR_HELPER -S --noconfirm --needed dxvk-bin"
        ;;
      5)
        handle_selection "5" "Installing nvdxvk" "$AUR_HELPER -S --noconfirm --needed dxvk-nvapi-mingw"
        ;;
      q)
        clear && xero-cli -m
        ;;
      *)
        gum style --foreground 31 "########## Choose the correct option ##########"
        ;;
    esac
  done
}

# Main execution
check_dependency gum
display_header
display_options
process_choice
