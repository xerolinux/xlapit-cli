#!/bin/bash

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
  gum style --foreground 35 "1. GPU Drivers (Prompt)."
  gum style --foreground 35 "2. Printer Drivers and Tools."
  gum style --foreground 35 "3. Samba Tools (XeroLinux Repo)."
  gum style --foreground 35 "4. Scanner Drivers (XeroLinux Repo)."
  gum style --foreground 35 "5. Game Controller Drivers (PS4/5/XBox)."
  gum style --foreground 35 "6. DeckLink & StreamDeck Drivers/Tools (AUR)."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
  echo
}

# Function to prompt user for GPU drivers
prompt_user() {
  gum style --foreground 33 "If Hybrid, only Intel/NVIDIA setup is supported."
  echo
  read -rp "Are you using a Desktop with AMD GPU ? (y/n): " amd_desktop
  if [[ $amd_desktop =~ ^[Yy](es)?$ ]]; then
    sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers lib32-vulkan-mesa-layers libva-mesa-driver lib32-libva-mesa-driver
    read -rp "Will you be using DaVinci Resolve ? (y/n): " davinci
    if [[ $davinci =~ ^[Yy](es)?$ ]]; then
      sudo pacman -S --needed --noconfirm mesa-vdpau lib32-mesa-vdpau rocm-opencl-runtime rocm-hip-runtime
    fi
  else
    read -rp "Are you only using an Intel GPU (iGPU/dGPU) ? (y/n): " intel_gpu
    if [[ $intel_gpu =~ ^[Yy](es)?$ ]]; then
      sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader intel-media-driver intel-gmmlib onevpl-intel-gpu mesa-vdpau lib32-mesa-vdpau gstreamer-vaapi libva-mesa-driver lib32-libva-mesa-driver intel-gmmlib
    else
      read -rp "Are you using an NVIDIA GPU ? (y/n): " nvidia_gpu
      if [[ $nvidia_gpu =~ ^[Yy](es)?$ ]]; then
        read -rp "Single GPU Desktop or Hybrid Laptop ? (desktop/hybrid): " nvidia_setup
        if [[ $nvidia_setup == "desktop" ]]; then
          read -rp "900/1000 series or 20 series and up ? (900/1000/20): " nvidia_series
          if [[ $nvidia_series == "900" || $nvidia_series == "1000" ]]; then
            sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
          elif [[ $nvidia_series == "20" ]]; then
            sudo pacman -S --needed --noconfirm linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
          else
            echo "Invalid selection."
            return
          fi
          read -rp "Do you want to install CUDA for Machine Learning ? (y/n): " cuda
          if [[ $cuda =~ ^[Yy](es)?$ ]]; then
            sudo pacman -S --needed --noconfirm cuda
          fi
        elif [[ $nvidia_setup == "hybrid" ]]; then
          read -rp "900/1000 series or 2000 series and up ? (900/2000): " nvidia_series
          if [[ $nvidia_series == "900" || $nvidia_series == "1000" ]]; then
            sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau nvidia-prime
            sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver intel-gmmlib onevpl-intel-gpu mesa-vdpau lib32-mesa-vdpau gstreamer-vaapi libva-mesa-driver lib32-libva-mesa-driver intel-gmmlib
          elif [[ $nvidia_series == "2000" ]]; then
            sudo pacman -S --needed --noconfirm linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau nvidia-prime
            sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver intel-gmmlib onevpl-intel-gpu mesa-vdpau lib32-mesa-vdpau gstreamer-vaapi libva-mesa-driver lib32-libva-mesa-driver intel-gmmlib
          else
            echo "Invalid selection."
            return
          fi
        else
          echo "Invalid selection."
          return
        fi
        sudo sed -i '/^MODULES=(/ s/)$/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
        sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service nvidia-powerd.service
        echo -e 'options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0 NVreg_DynamicPowerManagement=0x02' | sudo tee -a /etc/modprobe.d/nvidia.conf
        echo -e 'options nvidia_drm modeset=1 fbdev=1' | sudo tee -a /etc/modprobe.d/nvidia.conf && sudo mkinitcpio -P
      fi
    fi
  fi
  gum style --foreground 35 "Time to reboot for everything to work."
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
        sudo groupadd lp && sudo groupadd cups && sudo usermod -aG sys,lp,cups "$(whoami)"
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
        gum style --foreground 35 "Installing Game Controller Drivers..."
        sleep 2
        echo
        package_selection_dialog "DualShock4 DualSense XBoxOne" "install_aur_packages"
        gum style --foreground 35 "Game Controller Drivers installation complete!"
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
        clear && xero-cli -m
        ;;
      *)
        gum style --foreground 31 "Invalid choice. Select a valid option."
        echo
        ;;
    esac
  done
}

# Main execution
check_dependency gum
display_header
display_options
process_choice
