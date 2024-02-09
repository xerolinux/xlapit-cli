#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
clear
tput setaf 3
echo "##############################################################################"
echo "#                               Device Drivers                               #"
echo "##############################################################################"
tput sgr0
echo
echo "Hello $USER, Please Select What Drivers to install."
echo
echo "################## GPU / Printing ##################"
echo
echo "g. GPU Drivers (Forum Link)."
echo "p. Printer Drivers (From AUR)."
echo "m. Samba Tools (XeroLinux Repo)."
echo "k. Scanner Drivers (XeroLinux Repo)."
echo
echo "################# Game Controllers #################"
echo
echo "d. DualShock 4 Controller Driver (AUR)."
echo "s. PS5 DualSense Controller Driver (AUR)."
echo "x. Xbox One Wireless Gamepad Driver (AUR)."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    g )
      echo
      sleep 2
      xdg-open "https://forum.xerolinux.xyz/thread-364.html"  > /dev/null 2>&1
      echo
      clear && sh $0
      ;;

    p )
      echo
      echo "###########################################"
      echo "      Installing Printing Essentials       "
      echo "###########################################"
      sleep 3
      echo
      echo "Please wait while packages install... "
      $AUR_HELPER -S --noconfirm ghostscript gsfonts cups cups-filters cups-pdf system-config-printer avahi system-config-printer foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds python-pyqt5 hplip hplip-plugin epson-inkjet-printer-escpr epson-inkjet-printer-escpr2
      echo
      sudo systemctl enable --now avahi-daemon cups.socket
      echo
      sudo groupadd lp && sudo groupadd cups && sudo usermod -aG sys,lp,cups $(whoami)
      sleep 3
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
            clear && sh $0
      ;;

    m )
      echo
      echo "###########################################"
      echo "           Installing Samba Tools          "
      echo "###########################################"
      sleep 3
      echo
      sudo pacman -S --needed samba-support
      sleep 3
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
            clear && sh $0
      ;;

    k )
      echo
      echo "############################################"
      echo "          Installing Scanner Tools          "
      echo "############################################"
      sleep 3
      echo
      sudo pacman -S --needed scanner-support
      sleep 3
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
            clear && sh $0
      ;;

    d )
      echo
      echo "#################################################"
      echo "#          Installing DualShock 4 Driver        #"
      echo "#################################################"
      echo
      $aur_helper -S --noconfirm aur/ds4drv aur/game-devices-udev
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      clear && sh $0

      ;;

    s )
      echo
      echo "#################################################"
      echo "#  Installing PS-5 DualSense controller Driver  #"
      echo "#################################################"
      echo
      $aur_helper -S --noconfirm aur/dualsensectl
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      clear && sh $0

      ;;
    
    x )
      echo
      echo "#################################################"
      echo "#  Installing Xbox One Wireless Gamepad Driver  #"
      echo "#################################################"
      echo
      $aur_helper -S --noconfirm aur/xone-dkms-git
      echo
      echo "#################################################"
      echo "#        Done ! Returning to main menu..        #"
      echo "#################################################"
      clear && sh $0

      ;;
    
    q )
      clear && exit

      ;;

    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
