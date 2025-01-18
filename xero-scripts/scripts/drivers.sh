#!/usr/bin/env bash

# Set window title
echo -ne "\033]0;Device Drivers\007"

# Function to display header
display_header() {
    clear
    gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "Device Drivers"
    echo
    gum style --foreground 141 "Hello $USER, please select what drivers to install. Press 'i' for the Wiki."
    echo
}

# Function to display options
display_options() {
    gum style --foreground 85 "1. GPU Drivers (Intel/AMD/nVidia)."
    gum style --foreground 7 "2. Printer Drivers (Vanilla Arch)."
    gum style --foreground 7 "3. Samba Sharing Tools (Vanilla Arch)."
    gum style --foreground 7 "4. Scanner Drivers & Tools (Vanilla Arch)."
    gum style --foreground 7 "5. Setup Tailscale Incl. fix for XeroLinux."
    gum style --foreground 7 "6. DeckLink & StreamDeck Drivers/Tools (AUR)."
    echo
    gum style --foreground 190 "g. Apply nVidia GSP Firmware Fix (Closed Drivers)."
    gum style --foreground 196 "k. Install Arch Kernel Manager Tool (XeroLinux Repo)."
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
    gum style --foreground 33 "Gathering information about your connected GPUs..."
    echo
    inxi -G
    echo
    gum style --foreground 33 "Answer below prompts wisely. No Legacy GPU Support."
    echo
    read -rp "Single or Dual (Hybrid) GPU/iGPU Setup ? (s/d): " setup_type
    if [[ $setup_type == "s" ]]; then
        read -rp "Is your GPU AMD, Intel, or NVIDIA? (amd/intel/nvidia): " gpu_type
        case $gpu_type in
            amd)
                sudo pacman -S --needed --noconfirm mesa xf86-video-amdgpu amdvlk lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers lib32-vulkan-mesa-layers
                read -rp "Will you be using DaVinci Resolve and/or Machine Learning? (y/n): " davinci
                if [[ $davinci =~ ^[Yy](es)?$ ]]; then
                    sudo pacman -S --needed --noconfirm mesa lib32-mesa rocm-opencl-runtime rocm-hip-runtime
                fi
                ;;
            intel)
                sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader intel-media-driver intel-gmmlib onevpl-intel-gpu gstreamer-vaapi intel-gmmlib
                ;;
            nvidia)
                read -rp "Closed-Source (Proprietary) or Open-Kernel Modules ? (p/o): " nvidia_series
                if [[ $nvidia_series == "p" || $nvidia_series == "1000" ]]; then
                    sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
                elif [[ $nvidia_series == "o" ]]; then
                    sudo pacman -S --needed --noconfirm linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
                else
                    echo "Invalid selection."
                    return
                fi
                sudo sed -i '/^MODULES=(/s/)$/nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
                sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
                sudo mkinitcpio -P
                echo
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
    else
        echo
        sh /usr/share/xero-scripts/hybrid.sh
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
        read -rp "Enter your choice, 'r' to reboot or 'q' for main menu : " CHOICE
        echo
        case $CHOICE in
            i)
                gum style --foreground 33 "Opening Wiki..."
                sleep 3
                xdg-open "https://wiki.xerolinux.xyz/xlapit/#system-drivers" > /dev/null 2>&1
                echo
                clear && exec "$0"
                ;;
            1)
                prompt_user
                sleep 3
                clear && exec "$0"
                ;;
            2)
                gum style --foreground 7 "Installing Printer Drivers and Tools..."
                sleep 2
                echo
                sudo pacman -S --needed --noconfirm ghostscript gsfonts cups cups-filters cups-pdf system-config-printer avahi system-config-printer foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds python-pyqt5
                sudo systemctl enable --now avahi-daemon cups.socket
                sudo groupadd lp && sudo groupadd cups && sudo usermod -aG sys,lp,cups "$(whoami)"
                echo
                gum style --foreground 7 "Printer Drivers and Tools installation complete!"
                sleep 3
                clear && exec "$0"
                ;;
            3)
                gum style --foreground 7 "Installing Samba Tools..."
                sleep 2
                echo
                sudo pacman -S --needed samba-support
                echo
                gum style --foreground 7 "Samba Tools installation complete!"
                sleep 3
                clear && exec "$0"
                ;;
            4)
                gum style --foreground 7 "Installing Scanner Drivers..."
                sleep 2
                echo
                sudo pacman -S --noconfirm --needed scanner-support
                echo
                gum style --foreground 7 "Scanner Drivers installation complete!"
                sleep 3
                clear && exec "$0"
                ;;
            5)
                gum style --foreground 7 "Installing Tailscale..."
                sleep 2
                echo
                bash -c "$(curl -fsSL https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/install.sh)"
                echo
                gum style --foreground 7 "Tailscale installation complete!"
                sleep 3
                clear && exec "$0"
                ;;
            6)
                gum style --foreground 7 "Installing DeckLink & StreamDeck Drivers/Tools..."
                sleep 2
                echo
                package_selection_dialog "Decklink DeckMaster StreamDeckUI" "install_aur_packages"
                echo
                gum style --foreground 7 "DeckLink & StreamDeck Drivers/Tools installation complete!"
                sleep 3
                clear && exec "$0"
                ;;
            g)
                gum style --foreground 7 "Applying nVidia GSP Firmware fix..."
                echo
                if pacman -Qq | grep -qE 'nvidia-dkms|nvidia-open-dkms'; then
                    if pacman -Qq | grep -q 'nvidia-open-dkms'; then
                        read -p "Open Modules detected. This fix is only for closed drivers. Switch to closed drivers? (y/n): " response
                        if [[ "$response" =~ ^[Yy]$ ]]; then
                            sudo pacman -Rdd --noconfirm nvidia-open-dkms
                            sudo pacman -S --noconfirm nvidia-dkms
                            echo -e "options nvidia-drm modeset=1 fbdev=1\noptions nvidia NVreg_EnableGpuFirmware=0" | sudo tee -a /etc/modprobe.d/nvidia-modeset.conf
                            sudo mkinitcpio -P
                            echo
                            gum style --foreground 33 "Closed drivers installed and GSP Firmware fix applied."
                        else
                            echo
                            gum style --foreground 33 "No changes made."
                        fi
                    else
                        read -p "Apply GSP Firmware fix for closed drivers? (y/n): " response
                        if [[ "$response" =~ ^[Yy]$ ]]; then
                            echo -e "options nvidia-drm modeset=1 fbdev=1\noptions nvidia NVreg_EnableGpuFirmware=0" | sudo tee -a /etc/modprobe.d/nvidia-modeset.conf
                            sudo mkinitcpio -P
                            echo
                            gum style --foreground 33 "GSP Firmware fix applied."
                        else
                            echo
                            gum style --foreground 33 "No changes made."
                        fi
                    fi
                    echo
                    read -p "Do you want to reboot now? (y/n): " reboot_response
                    if [[ "$reboot_response" =~ ^[Yy]$ ]]; then
                        reboot
                    else
                        echo
                        gum style --foreground 33 "Remember to reboot for changes to take effect."
                    fi
                else
                    echo
                    gum style --foreground 40 "No nVidia drivers installed, or you are using nouveau/Intel/AMD."
                fi
                sleep 3
                clear && exec "$0"
                ;;
            r)
                gum style --foreground 33 "Rebooting System..."
                sleep 3
                for i in {5..1}; do
                    dialog --infobox "Rebooting in $i seconds..." 3 30
                    sleep 1
                done
                reboot
                sleep 3
                ;;
            k)
                gum style --foreground 7 "Installing Arch Kernel Manager..."
                sleep 2
                echo
                sudo pacman -S --noconfirm --needed archlinux-kernel-manager python-tomlkit
                echo
                gum style --foreground 7 "Kernel Manager installation complete."
                sleep 6
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
display_header
display_options
process_choice
