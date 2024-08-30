#!/usr/bin/env bash
#set -e

######################################
# Author   :   DarkXero              #
# Website  :   http://xerolinux.xyz  #
######################################

# Set window title
echo -ne "\033]0;Device Drivers\007"

check_distro() {
  source /etc/os-release
  if [ "$ID" != "arch" ]; then
    echo "$0 only supports archlinx. Exiting..." >&2
    exit 1;
  fi
}

# Function to check and install dependencies
check_dependency() {
  local dependency=$1
  command -v $dependency >/dev/null 2>&1 || { echo >&2 "$dependency is not installed. Installing..."; sudo pacman -S --noconfirm $dependency; }
}

# Function to display header
display_header() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "Device Drivers"
  echo
  gum style --foreground 33 "Hello $USER, please select what drivers to install. Press 'i' for the Wiki."
  echo
}

# Function to display options
display_options() {
  gum style --foreground 130 "1. GPU Drivers (Prompt)."
  echo
  gum style --foreground 35 "2. Printer Drivers and Tools."
  gum style --foreground 35 "3. Samba Tools (XeroLinux Repo)."
  gum style --foreground 35 "4. Scanner Drivers (XeroLinux Repo)."
  gum style --foreground 35 "5. Setup Tailscale Incl. fix for XeroLinux."
  gum style --foreground 35 "6. DeckLink & StreamDeck Drivers/Tools (AUR)."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
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

# Function to prompt user for GPU drivers
prompt_user() {
  # Display GPU information
  gum style --foreground 33 "Gathering information about your connected GPUs..."
  echo
  inxi -G
  echo
  gum style --foreground 33 "Above is your GPU setup, read carefully and answer prompts wisely."
  echo

  # Prompt if the user has a Single GPU/iGPU or a Hybrid setup
  read -rp "Do you have a Single dGPU/iGPU or Hybrid setup? (s/h): " setup_type
  if [[ $setup_type == "s" ]]; then
    # Prompt for the type of single GPU
    read -rp "Is your GPU AMD, Intel, or NVIDIA? (amd/intel/nvidia): " gpu_type
    case $gpu_type in
      amd)
        sudo pacman -S --needed --noconfirm mesa xf86-video-amdgpu amdvlk lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers lib32-vulkan-mesa-layers libva-mesa-driver lib32-libva-mesa-driver
        read -rp "Will you be using DaVinci Resolve? (y/n): " davinci
        if [[ $davinci =~ ^[Yy](es)?$ ]]; then
          sudo pacman -S --needed --noconfirm mesa-vdpau lib32-mesa-vdpau rocm-opencl-runtime rocm-hip-runtime
        fi
        ;;
      intel)
        sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader intel-media-driver intel-gmmlib onevpl-intel-gpu mesa-vdpau lib32-mesa-vdpau gstreamer-vaapi libva-mesa-driver lib32-libva-mesa-driver intel-gmmlib
        ;;
      nvidia)
        read -rp "Older 900/1000 series or Newer 1650ti/1660ti/20 series and up? (o/n): " nvidia_series
        if [[ $nvidia_series == "o" || $nvidia_series == "1000" ]]; then
          sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
        elif [[ $nvidia_series == "n" ]]; then
          sudo pacman -S --needed --noconfirm linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
        else
          echo "Invalid selection."
          return
        fi
        read -rp "Do you want to install CUDA for Machine Learning? (y/n): " cuda
        if [[ $cuda =~ ^[Yy](es)?$ ]]; then
          sudo pacman -S --needed --noconfirm cuda
        fi
        ;;
      *)
        echo "Invalid selection."
        return
        ;;
    esac
  elif [[ $setup_type == "h" ]]; then
    # For Hybrid setup, prompt if Intel/NVIDIA or Intel/AMD
    read -rp "Is your Hybrid setup Intel/NVIDIA or Intel/AMD? (nvidia/amd): " hybrid_type
    case $hybrid_type in
      nvidia)
        read -rp "Older 900/1000 series or Newer 1650ti/1660ti/20 series and up? (o/n): " nvidia_series
        if [[ $nvidia_series == "o" || $nvidia_series == "1000" ]]; then
          sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau nvidia-prime
        elif [[ $nvidia_series == "n" ]]; then
          sudo pacman -S --needed --noconfirm linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau nvidia-prime
        else
          echo "Invalid selection."
          return
        fi
        read -rp "Do you want to install CUDA for Machine Learning? (y/n): " cuda
        if [[ $cuda =~ ^[Yy](es)?$ ]]; then
          sudo pacman -S --needed --noconfirm cuda
        fi
        # Install Intel drivers for Hybrid setup
        sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver intel-gmmlib onevpl-intel-gpu mesa-vdpau lib32-mesa-vdpau gstreamer-vaapi libva-mesa-driver lib32-libva-mesa-driver intel-gmmlib
        $AUR_HELPER -S --noconfirm --needed supergfxctl plasma6-applets-supergfxctl && sudo systemctl enable --now supergfxd.service
        ;;
      amd)
        # Install both Intel and AMD drivers for Intel/AMD Hybrid setup
        sudo pacman -S --needed --noconfirm mesa xf86-video-amdgpu lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers lib32-vulkan-mesa-layers libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau amdvlk
        sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver intel-gmmlib onevpl-intel-gpu mesa-vdpau lib32-mesa-vdpau gstreamer-vaapi libva-mesa-driver lib32-libva-mesa-driver intel-gmmlib
        $AUR_HELPER -S --noconfirm --needed supergfxctl plasma6-applets-supergfxctl && sudo systemctl enable --now supergfxd.service
        read -rp "Will you be using DaVinci Resolve? (y/n): " davinci
        if [[ $davinci =~ ^[Yy](es)?$ ]]; then
          sudo pacman -S --needed --noconfirm mesa-vdpau lib32-mesa-vdpau rocm-opencl-runtime rocm-hip-runtime
        fi
        ;;
      *)
        echo "Invalid selection."
        return
        ;;
    esac
  else
    echo "Invalid selection."
    return
  fi

  echo
  gum style --foreground 196 "Time to reboot for everything to work."
  sleep 3
}

# Function to install AUR packages
install_aur_packages() {
  $AUR_HELPER -S --noconfirm --needed "$@"
}

# Function for package selection dialog
package_selection_dialog() {
  local options=$1
  local install_command=$2
  PACKAGES=$(gum choose --multiple --cursor.foreground 212 --selected.background 236 $options)
  for PACKAGE in $PACKAGES; do
    eval $install_command $PACKAGE
  done
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
        xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#system-drivers" > /dev/null 2>&1
        clear && exec "$0"
        ;;
      1)
        prompt_user
        sleep 3
        clear && exec "$0"
        ;;
      2)
        gum style --foreground 35 "Installing Printer Drivers and Tools..."
        sleep 2
        echo
        sudo pacman -S --needed --noconfirm ghostscript gsfonts cups cups-filters cups-pdf system-config-printer avahi system-config-printer foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds python-pyqt5
        sudo systemctl enable --now avahi-daemon cups.socket
        sudo groupadd lp && sudo groupadd cups and sudo usermod -aG sys,lp,cups "$(whoami)"
        gum style --foreground 35 "Printer Drivers and Tools installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      3)
        gum style --foreground 35 "Installing Samba Tools..."
        sleep 2
        echo
        sudo pacman -S --needed samba-support
        gum style --foreground 35 "Samba Tools installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      4)
        gum style --foreground 35 "Installing Scanner Drivers..."
        sleep 2
        echo
        sudo pacman -S --noconfirm --needed scanner-support
        gum style --foreground 35 "Scanner Drivers installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      5)
        gum style --foreground 35 "Installing Tailscale..."
        sleep 2
        echo
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/install.sh)"
        echo
        gum style --foreground 35 "Tailscale installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      6)
        gum style --foreground 35 "Installing DeckLink & StreamDeck Drivers/Tools..."
        sleep 2
        echo
        package_selection_dialog "Decklink DeckMaster StreamDeckUI" "install_aur_packages"
        gum style --foreground 35 "DeckLink & StreamDeck Drivers/Tools installation complete!"
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
check_distro
check_dependency gum
display_header
display_options
process_choice
