#!/usr/bin/env bash

# Function to check for dual GPU
check_dual_gpu() {
    if lspci | grep -E "VGA|3D" | grep -q -E "NVIDIA|AMD" && lspci | grep -E "VGA|3D" | grep -q -E "Intel|AMD"; then
        return 0
    else
        return 1
    fi
}

# Function to install NVIDIA and Intel drivers
install_nvidia_intel() {
    local driver_type=$1
    if [ "$driver_type" = "closed" ]; then
        sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
    else
        sudo pacman -S --needed --noconfirm linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
    fi
    sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader intel-media-driver intel-gmmlib onevpl-intel-gpu gstreamer-vaapi intel-gmmlib
}

# Function to install NVIDIA and AMD drivers
install_nvidia_amd() {
    local driver_type=$1
    if [ "$driver_type" = "closed" ]; then
        sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
    else
        sudo pacman -S --needed --noconfirm linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
    fi
    sudo pacman -S --needed --noconfirm mesa xf86-video-amdgpu amdvlk lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers lib32-vulkan-mesa-layers
}

# Main script
if check_dual_gpu; then
    if lspci | grep -E "VGA|3D" | grep -q "NVIDIA" && lspci | grep -E "VGA|3D" | grep -q "Intel"; then
        gum style --foreground 33 "Intel/nVidia detected, Setup should work for most."
        echo
        read -p "Do you want (C)losed (All) or (O)pen Module (Turing+) nVidia drivers? (c/o): " driver_choice
        if [ "$driver_choice" = "c" ]; then
            install_nvidia_intel "closed"
        elif [ "$driver_choice" = "o" ]; then
            install_nvidia_intel "open"
        else
            echo "Invalid input. Please choose 'closed' or 'open'."
            exit 1
        fi
    elif lspci | grep -E "VGA|3D" | grep -q "NVIDIA" && lspci | grep -E "VGA|3D" | grep -q "AMD"; then
        gum style --foreground 196 "nVidia/AMD detected, Setup should work for most."
        echo
        read -p "Do you want (C)losed or (O)pen drivers? (closed/open): " driver_choice
        if [ "$driver_choice" = "closed" ]; then
            install_nvidia_amd "closed"
        elif [ "$driver_choice" = "open" ]; then
            install_nvidia_amd "open"
        else
            echo
            echo "Invalid input. Please choose 'closed' or 'open'."
            exit 1
        fi
    fi
    echo
    read -p "A reboot is required. Do you want to reboot now ? (y/n): " reboot_choice
    if [ "$reboot_choice" = "y" ]; then
        sudo reboot
    else
        echo
        echo "Please remember to reboot your system to apply the changes."
    fi
else
    echo
    echo "No dual GPU configuration detected."
fi
