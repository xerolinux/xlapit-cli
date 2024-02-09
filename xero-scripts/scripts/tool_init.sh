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
echo "Hello $USER, Please Select What To Do."
echo
echo "############ Initial Setup Section ############"
echo
echo "b. Install Web Browser of choice."
echo "d. Activate/Set Pacman Parallel Downloads (10)."
echo "f. Activate Flathub Repositories (Req. for OBS)."
echo "t. Enable fast multithreaded package compilation."
echo
echo "########## GUI Package Managers ##########"
echo
echo "o. OctoPi GUI."
echo "p. Pamac-All GUI."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    b )
      echo
      echo "##########################################"
      echo "            Which Web Browser ?           "
      echo "##########################################"
      sleep 3
      echo
      select browser in "Brave" "Firefox" "Vivaldi"; do case $browser in Brave) $AUR_HELPER -S --noconfirm brave-bin && break ;; Firefox) sudo pacman -S --noconfirm firefox firefox-ublock-origin && break ;; Vivaldi) sudo pacman -S --noconfirm vivaldi vivaldi-ffmpeg-codecs vivaldi-widevine && break ;; *) echo "Invalid option. Please select 1, 2, or 3." ;; esac done
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      clear && sh $0

      ;;

    d )
      echo
      sleep 3
      echo
      sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
      echo
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      clear && sh $0

      ;;

    f )
      echo
      echo "##########################################"
      echo "       Adding & Activating Flatpaks       "
      echo "##########################################"
      sleep 3
      echo
      sudo pacman -S --noconfirm flatpak
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
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
      sleep 3
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      clear && sh $0

      ;;

    o )
      echo
      echo "##########################################"
      echo "             Installing Octopi            "
      echo "##########################################"
      sleep 3
      $AUR_HELPER -S octopi alpm_octopi_utils octopi-notifier-noknotify
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      clear && sh $0

      ;;

    p )
      echo
      echo "##########################################"
      echo "            Installing Pamac-All          "
      echo "##########################################"
      sleep 3
      $AUR_HELPER -S pamac-all pamac-cli libpamac-full
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      clear && sh $0

      ;;

    q )
      clear && xero-cli

      ;;

    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
