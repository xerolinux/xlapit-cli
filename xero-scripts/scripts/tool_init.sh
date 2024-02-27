#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
clear
tput setaf 5
echo "############################################################################"
echo "#                           Initial System Setup                           #"
echo "############################################################################"
tput sgr0
echo
echo "Hello $USER, Please Select What To Do. Press i for the Wiki."
echo
echo "############ Initial Setup Section ############"
echo
echo "a. PipeWire/Bluetooth Packages."
echo "b. Web Browser (Brave/Firefox/Vivaldi Etc.)."
echo "m. Activate multilib repository (if not done)."
echo "d. Activate/Set Pacman Parallel Downloads (10)."
echo "f. Activate Flathub Repositories (Req. for OBS)."
echo "t. Enable fast multithreaded package compilation."
echo "p. Install 3rd-Party GUI Package Manager(s) (AUR)."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    i )
      echo
      sleep 2
      xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#system-setup"  > /dev/null 2>&1
      echo
      clear && sh $0
      ;;

    a )
      echo
      echo "###########################################"
      echo "        Installing Audio/Bluetooth         "
      echo "###########################################"
      echo
      echo "Installing PipeWire packages..."
      echo
      sudo pacman -S --needed --noconfirm gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-ugly gst-plugins-good libdvdcss alsa-utils alsa-firmware pavucontrol lib32-pipewire-jack libpipewire pipewire-v4l2 pipewire-x11-bell pipewire-zeroconf realtime-privileges sof-firmware ffmpeg ffmpegthumbs ffnvcodec-headers
      sleep 3
      echo
      echo "Installing Bluetooth packages..."
      echo
      sudo pacman -S --needed --noconfirm bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools
      sudo systemctl enable --now  bluetooth.service
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      sleep 3
      clear && sh $0
      ;;

    b )
      echo
      # Function to install packages using pacman
      install_pacman_packages() {
          sudo pacman -S --noconfirm --needed $@
      }

      # Function to install packages using AUR Helper
      install_aur_packages() {
          $AUR_HELPER -S --noconfirm --needed $@
      }

      # Function to install flatpak packages
      install_flatpak_packages() {
          flatpak install -y $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select Browser to install:" 20 60 7 \
          "Brave" "The web browser from Brave" OFF \
          "Firefox" "Fast, Private & Safe Web Browser" OFF \
          "Vivaldi" "Feature-packed web browser" OFF \
          "Mullvad" "Mass surveillance free browser" OFF \
          "Floorp" "A Firefox-based Browser" OFF \
          "LibreWolf" "LibreWolf Web Browser" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      Brave)
                          install_aur_packages brave-bin
                          ;;
                      Firefox)
                          install_pacman_packages firefox firefox-ublock-origin
                          ;;
                      Vivaldi)
                          install_pacman_packages vivaldi vivaldi-ffmpeg-codecs vivaldi-widevine
                          ;;
                      Mullvad)
                          install_aur_packages mullvad-browser-bin
                          ;;
                      Floorp)
                          install_flatpak_packages flathub one.ablaze.floorp
                          ;;
                      LibreWolf)
                          install_flatpak_packages io.gitlab.librewolf-community
                          ;;
                      *)
                          echo "Unknown package: $PACKAGE"
                          ;;
                  esac
              done
          else
              echo "No packages selected."
          fi
      }

      # Call the package selection dialog function
      package_selection_dialog
      echo
      echo "#################################"
      echo "              Done !             "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    m )
      echo
      sleep 3
      echo "Activating multilib repository..."
      sudo sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
      sudo pacman -Syy
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      sleep 6
      clear && sh $0

      ;;

    d )
      echo
      sleep 3
      echo
      sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
      sudo pacman -Syy
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      sleep 3
      clear && sh $0

      ;;

    f )
      echo
      echo "##########################################"
      echo "       Adding & Activating Flatpaks       "
      echo "##########################################"
      sleep 3
      echo
      sudo pacman -S --noconfirm --needed flatpak
      echo
      echo "#######################################"
      echo "           Done Plz Reboot !           "
      echo "#######################################"
      sleep 3
      clear && sh $0

      ;;

    t )
      echo
      echo "###########################################"
      echo "      Enabling multithread compilation     "
      echo "###########################################"
      sleep 3
      echo
      numberofcores=$(grep -c ^processor /proc/cpuinfo)

      if [ $numberofcores -gt 1 ]
      then
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores+1))'"/g' /etc/makepkg.conf;
        echo
        echo "Changing the compression settings for "$numberofcores" cores."
        echo
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -z - --threads=0)/g' /etc/makepkg.conf
        sudo sed -i 's/COMPRESSZST=(zstd -c -z -q -)/COMPRESSZST=(zstd -c -z -q - --threads=0)/g' /etc/makepkg.conf
        sudo sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar.zst'/g" /etc/makepkg.conf
      else
        echo
        echo "No change."
      fi
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      sleep 3
      clear && sh $0

      ;;

    p )
      echo
      # Function to install packages using AUR Helper
      install_aur_packages() {
          $AUR_HELPER -S --noconfirm --needed $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select GUI Package Manager to install:" 20 60 7 \
          "OctoPi" "A powerful Pacman frontend using Qt" OFF \
          "PacSeek" "TUI for installing AUR packages" OFF \
          "Pamac-All" "A GUI with AUR/Flatpak/Snap support" OFF \
          "BauhGUI" "For AppImage, Flatpak, Snap, Arch/AUR" OFF \
          "ArchUpdate" "An update notifier/applier (Arch/AUR)" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      OctoPi)
                          install_aur_packages octopi alpm_octopi_utils octopi-notifier-noknotify
                          ;;
                      PacSeek)
                          install_aur_packages pacseek-bin pacfinder
                          ;;
                      Pamac-All)
                          install_aur_packages pamac-all pamac-cli libpamac-full
                          ;;
                      BauhGUI)
                          install_aur_packages bauh
                          ;;
                      ArchUpdate)
                          install_aur_packages arch-update \
                          && systemctl --user enable --now arch-update.timer
                          ;;
                      *)
                          echo "Unknown package: $PACKAGE"
                          ;;
                  esac
              done
          else
              echo "No packages selected."
          fi
      }

      # Call the package selection dialog function
      package_selection_dialog
      echo
      echo "#################################"
      echo "              Done !             "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    q )
      clear && xero-cli -m

      ;;

    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
