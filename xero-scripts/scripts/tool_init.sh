#!/usr/bin/env bash
set -e

# Add this at the start of the script, right after the shebang
trap 'clear && exec "$0"' INT

# Check if being run from xero-cli
if [ -z "$AUR_HELPER" ]; then
    echo
    gum style --border double --align center --width 70 --margin "1 2" --padding "1 2" --border-foreground 196 "$(gum style --foreground 196 'ERROR: This script must be run through the toolkit.')"
    echo
    gum style --border normal --align center --width 70 --margin "1 2" --padding "1 2" --border-foreground 33 "$(gum style --foreground 33 'Or use this command instead:') $(gum style --bold --foreground 47 'clear && xero-cli -m')"
    echo
    exit 1
fi

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
  echo
  gum style --foreground 208 "n. Apply latest XeroLinux specific changes/updates."
  gum style --foreground 39 "a. Install Multi-A.I Model Chat G.U.I (Local/Offline)."
}

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
  IFS='"' read -ra PACKAGE_ARRAY <<< "$PACKAGES"
  for PACKAGE in "${PACKAGE_ARRAY[@]}"; do
    [ -z "$PACKAGE" ] && continue
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

install_alpaca_ai() {
  if flatpak list | grep -q "com.jeffser.Alpaca"; then
    gum style --foreground 46 "Alpaca is already installed!"
    sleep 3
  else
    gum style --foreground 7 "Installing Alpaca (~4.5gb)..."
    echo
    sleep 3
    flatpak install com.jeffser.Alpaca -y
    echo
    gum style --foreground 46 "Alpaca has been installed!"
    sleep 4
  fi
  exec "$0"
}

# Function to update system
update_system() {
  if ! command -v flatpak &> /dev/null; then
    gum style --foreground 196 "Warning: flatpak is not installed"
  fi
  
  echo "Select an update option:"Neovide
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
      install_topgrade_aio_if [ -z "$AUR_HELPER" ]; then
    echo
    gum style --border double --align center --width 70 --margin "1 2" --padding "1 2" --border-foreground 196 "$(gum style --foreground 196 'ERROR: This script must be run through the toolkit.')"
    echo
    gum style --border normal --align center --width 70 --margin "1 2" --padding "1 2" --border-foreground 33 "$(gum style --foreground 33 'Or use this command instead:') $(gum style --bold --foreground 47 'clear && xero-cli -m')"
    echo
    exit 1
fiupdater
      ;;
    4)
      gum style --foreground 10 "Exiting..."
      ;;
    *)
      gum style --foreground 9 "Invalid option. Please try again."
      ;;
  esac
}

restart() {
  # Notify the user that the system is rebooting
  gum style --foreground 69 "Rebooting System..."
  sleep 3

  # Countdown from 5 to 1
  for i in {5..1}; do
    dialog --infobox "Rebooting in $i seconds..." 3 30
    sleep 1
  done

  # Execute the reboot command
  reboot
}

apply_latest_fixes() {
    # Ask user to choose between GNOME and Plasma
    local DE
    if gum confirm --default=false --affirmative "GNOME" --negative "Plasma" "Please select Version:"; then
        DE="GNOME"
    else
        DE="Plasma"
    fi
    
    gum style \
        --border normal \
        --margin "1" \
        --padding "1" \
        --border-foreground 212 \
        "Applying latest fixes for $DE..."

    echo
    sleep 3  # Initial pause

    if [ "$DE" = "Plasma" ]; then
        # Install/update desktop-config
        gum style --foreground 212 "Updating Desktop Config package..."
        echo
        sudo pacman -Syy --needed desktop-config
        sleep 3
        echo
        # Copy apdatifier config
        gum style --foreground 212 "Updating configuration files..."
        echo
        gum spin --spinner dot --title "Copying files..." -- \
            cp -rf /etc/skel/.config/apdatifier/* "$HOME/.config/apdatifier/"
        sleep 3

        # Install additional packages
        gum style --foreground 212 "Installing additional packages..."
        echo
        sudo pacman -S --noconfirm --needed ncdu nvtop ventoy-bin iftop
        sleep 3

    elif [ "$DE" = "GNOME" ]; then
        # Warn user about vim replacement
        if ! gum confirm --default=false "$(gum style --foreground 196 --bold 'Vim will be replaced with neoVide/nVim. Continue?')"; then
            gum style \
                --border normal \
                --margin "1" \
                --padding "1" \
                --border-foreground 212 \
                "⚠️ Operation cancelled. Returning to main menu..."
            sleep 2
            return
        fi

        # Install/update desktop-config-gnome
        gum style --foreground 212 "Updating desktop-config-gnome package..."
        sudo pacman -Syy --needed desktop-config-gnome
        sleep 3

        echo

        # Remove vim packages
        gum style --foreground 212 "Removing old vim packages..."
        sudo pacman -Rns --noconfirm vim vim-csound vim-runtime vim-nerdtree vim-supertab vim-syntastic vim-gitgutter vim-bufexplorer vim-nerdcommenter
        sleep 3
        echo
        # Install new packages
        gum style --foreground 212 "Installing new packages with neovide..."
        sudo pacman -S --noconfirm --needed ncdu nvtop ventoy-bin iftop neovide neovim-plug python-pynvim neovim-remote neovim-lspconfig
        sleep 3
        echo
        # Copy nvim config
        gum style --foreground 212 "Updating neovim configuration..."
        gum spin --spinner dot --title "Copying files..." -- \
            cp -r /etc/skel/.config/nvim/ "$HOME/.config/"
        sleep 3
    fi

    gum style \
        --border normal \
        --margin "1" \
        --padding "1" \
        --border-foreground 212 \
        "✅ All fixes and tweaks have been applied successfully!"
    
    sleep 6  # Final pause
}

main() {
  while :; do
    display_menu
    echo
    read -rp "Enter your choice, 'r' to reboot or 'q' for main menu : " CHOICE
    echo

    case $CHOICE in
      i) open_wiki ;;
      1) install_pipewire_bluetooth ;;
      2) activate_flathub_repositories ;;
      3) enable_multithreaded_compilation ;;
      4) install_gui_package_managers ;;
      a) install_alpaca_ai ;;
      u) update_system ;;
      n) apply_latest_fixes ;;
      r) restart ;;
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
