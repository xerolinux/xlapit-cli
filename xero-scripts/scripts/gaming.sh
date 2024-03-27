#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
clear
tput setaf 3
echo "#################################################"
echo "#             The Gaming Essentials.            #"
echo "#################################################"
tput sgr0
echo
echo "Hello $USER, what would you like to install ? Press i for the Wiki."
echo
echo "################# Game Launchers #################"
echo
echo "s. Steam."
echo "l. Lutris."
echo "h. Heroic."
echo "b. Bottles."
echo
echo "################### Game Tools ###################"
echo
echo "1.  Mangohud."
echo "2.  Goverlay."
echo "3.  Protonup-qt."
echo "4.  Vulkan Layer (AMD)."
echo "5.  Vulkan Layer (nVidia)."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    i )
      echo
      sleep 2
      xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#game-launchers"  > /dev/null 2>&1
      echo
      clear && sh $0
      ;;

    s )
      echo
      echo "#################################################"
      echo "#            Installing Steam Launcher          #"
      echo "#################################################"
      echo
      sudo pacman -S --noconfirm --needed steam
      sleep 3
      echo
      echo "Applying Download Speed Enhancement Patch..."
      echo -e "@nClientDownloadEnableHTTP2PlatformLinux 0\n@fDownloadRateImprovementToAddAnotherConnection 1.0" > ~/.steam/steam/steam_dev.cfg
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      sleep 3
      clear && sh $0

      ;;

    l )
      echo
      echo "#################################################"
      echo "#           Installing Lutris Launcher          #"
      echo "#################################################"
      echo
      echo "Native (Unofficial) or Flatpak (Official) ?"
      echo
      select lutris in "Native" "Flatpak" "Back"; do case $lutris in Native) sudo pacman -S --noconfirm --needed lutris wine-meta && break ;; Flatpak) flatpak install net.lutris.Lutris && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, or 3." ;; esac done
      echo
      echo "vm.max_map_count=2147483642" | sudo tee /etc/sysctl.d/99-sysctl.conf >/dev/null
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      sleep 3
      clear && sh $0

      ;;

    h )
      echo
      echo "#################################################"
      echo "#           Installing Heroic Launcher          #"
      echo "#################################################"
      echo
      echo "Native (Unofficial) or Flatpak (Official) ?"
      echo
      select heroic in "Native" "Flatpak" "Back"; do case $heroic in Native) $AUR_HELPER -S --noconfirm --needed heroic-games-launcher-bin wine-meta && break ;; Flatpak) flatpak install com.heroicgameslauncher.hgl && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, or 3." ;; esac done
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      sleep 3
      clear && sh $0

      ;;

    b )
      echo
      echo "#################################################"
      echo "#          Installing Bottles Launcher          #"
      echo "#################################################"
      echo
      echo "Native (Unofficial) or Flatpak (Official) ?"
      echo
      select bottles in "Native" "Flatpak" "Back"; do case $bottles in Native) $AUR_HELPER -S --noconfirm --needed bottles wine-meta && break ;; Flatpak) flatpak install com.usebottles.bottles && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, or 3." ;; esac done
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      sleep 3
      clear && sh $0

      ;;

    1 )
      echo
      echo "#################################################"
      echo "#               Installing Mangohud             #"
      echo "#################################################"
      echo
      sudo pacman -S --noconfirm --needed mangohud
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      sleep 3
      clear && sh $0

      ;;

    2 )
      echo
      echo "#################################################"
      echo "#               Installing Goverlay             #"
      echo "#################################################"
      echo
      sudo pacman -S --noconfirm --needed goverlay
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      sleep 3
      clear && sh $0

      ;;

    3 )
      echo
      echo "#################################################"
      echo "#             Installing ProtonUp-QT            #"
      echo "#################################################"
      echo
      echo "Native (Unofficial) or Flatpak (Official) ?"
      echo
      select protonup in "Native" "Flatpak" "Back"; do case $protonup in Native) $AUR_HELPER -S --noconfirm --needed protonup-qt wine-meta && break ;; Flatpak) flatpak install net.davidotek.pupgui2 && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, or 3." ;; esac done
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      sleep 3
      clear && sh $0

      ;;

    4 )
      echo
      echo "#################################################"
      echo "#               Installing DXVK-bin             #"
      echo "#################################################"
      echo
      $AUR_HELPER -S --noconfirm --needed dxvk-bin
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      sleep 3
      clear && sh $0

      ;;

    5 )
      echo
      echo "#################################################"
      echo "#                Installing nvdxvk              #"
      echo "#################################################"
      echo
      $AUR_HELPER -S --noconfirm --needed dxvk-nvapi-mingw
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
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
