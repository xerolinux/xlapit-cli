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
echo "Hello $USER, Please Select What To Do. (multilib Repo req.)"
echo
echo "############ Initial Setup Section ############"
echo
echo "a. PipeWire/Bluetooth Packages."
echo "b. Web Browser (Brave/Firefox/Vivaldi)."
echo "m. Activate multilib repository if not done."
echo "d. Activate/Set Pacman Parallel Downloads (10)."
echo "f. Activate Flathub Repositories (Req. for OBS)."
echo "t. Enable fast multithreaded package compilation."
echo
echo "########## GUI Package Managers ##########"
echo
echo "o. OctoPi GUI."
echo "s. PacSeek TUI."
echo "p. Pamac-All GUI."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

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
      echo "##########################################"
      echo "            Which Web Browser ?           "
      echo "##########################################"
      echo
      select browser in "Brave" "Firefox" "Vivaldi" "Back"; do case $browser in Brave) $AUR_HELPER -S --noconfirm --needed brave-bin && break ;; Firefox) sudo pacman -S --noconfirm --needed firefox firefox-ublock-origin && break ;; Vivaldi) sudo pacman -S --noconfirm --needed vivaldi vivaldi-ffmpeg-codecs vivaldi-widevine && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, 3 or 4." ;; esac done
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
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

    o )
      echo
      echo "##########################################"
      echo "             Installing Octopi            "
      echo "##########################################"
      sleep 3
      $AUR_HELPER -S --noconfirm --needed octopi alpm_octopi_utils octopi-notifier-noknotify
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      sleep 3
      clear && sh $0

      ;;

    s )
      echo
      echo "##########################################"
      echo "               PacSeek T.U.I              "
      echo "##########################################"
      sleep 3
      echo
      $AUR_HELPER -S --noconfirm --needed pacseek-bin pacfinder
      echo
      echo "#######################################"
      echo "           Done Plz Reboot !           "
      echo "#######################################"
      sleep 3
      clear && sh $0

      ;;

    p )
      echo
      echo "##########################################"
      echo "            Installing Pamac-All          "
      echo "##########################################"
      sleep 3
      $AUR_HELPER -S --noconfirm --needed pamac-all pamac-cli libpamac-full
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
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
