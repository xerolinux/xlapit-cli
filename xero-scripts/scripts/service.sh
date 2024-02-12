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
echo "#                  Fixes/Tweaks                 #"
echo "#################################################"
tput sgr0
echo
echo "Hello $USER, what would you like to do today ?"
echo
echo "1. Install & Activate Firewald."
echo "2. Clear Pacman Cache (Free Space)."
echo "3. Restart PipeWire/PipeWire-Pulse."
echo "4. Unlock Pacman DB (In case of DB error)."
echo "5. Activate Flatpak Theming (Required If used)."
echo "6. Activate OS-Prober for Dual-Booting with other OS."
echo "7. Install/Activate Power Daemon for Laptops/Desktops."
echo
echo "m. Update Arch Mirrorlist, for faster download speeds."
echo "g. Fix Arch GnuPG Keyring in case of pkg signature issues."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    1 )
      echo
	  sleep 2
      sudo pacman -S --needed --noconfirm firewalld python-pyqt5 python-capng
      echo
      sudo systemctl enable --now firewalld.service
      sleep 2
      echo
      clear && sh $0

      ;;

    2 )
      echo
	  sleep 2
      sudo pacman -Scc
      sleep 2
      echo
      clear && sh $0

      ;;


    3 )
      echo
	  sleep 2
	  echo "#################################"
      echo "       Restarting PipeWire       "
      echo "#################################"
      sleep 1.5
      systemctl --user restart pipewire
      systemctl --user restart pipewire-pulse
      sleep 1.5
      echo
      echo "#################################"
      echo "        All Done, Try now       "
      echo "#################################"
	  sleep 2
      clear && sh $0

      ;;


    4 )
      echo
	  sleep 2
	  sudo rm /var/lib/pacman/db.lck
	  sleep 2
      clear && sh $0

      ;;


    5 )
      echo
	  sleep 2
	  echo "#####################################"
      echo "#    Activating Flatpak Theming.    #"
      echo "#####################################"
      sleep 3
      sudo flatpak override --filesystem=$HOME/.themes
      sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
      sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
      sleep 2
      echo
      echo "#####################################"
      echo "#     Flatpak Theming Activated     #"
      echo "#####################################"
	  sleep 3
      clear && sh $0

      ;;


    6 )
      echo
	  sleep 2
	  echo "#####################################"
      echo "#   Activating OS-Prober in Grub.   #"
      echo "#####################################"
      sleep 3
      sudo pacman -S --noconfirm os-prober
      sudo sed -i 's/#\s*GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' '/etc/default/grub'
      sudo os-prober
      sudo grub-mkconfig -o /boot/grub/grub.cfg
      sleep 2
      echo
      echo "#####################################"
      echo "#        Done! Reboot n Test        #"
      echo "#####################################"
	  sleep 3
      clear && sh $0

      ;;
        
    7 )
      echo
	  sleep 2
      sudo pacman -S --needed --noconfirm power-profiles-daemon
      echo
      sudo systemctl enable --now power-profiles-daemon
      echo
      sudo groupadd power && sudo usermod -aG power $(whoami)
      sleep 2
      echo
      clear && sh $0

      ;;
    
    m )
      echo
      echo "##########################################"
      echo "     Updating Mirrors To Fastest Ones     "
      echo "##########################################"
	  sleep 3
	  echo
	  sudo pacman -S --noconfirm reflector
	  sudo reflector --verbose -phttps -f10 -l10 --sort rate --save /etc/pacman.d/mirrorlist && sudo pacman -Syy
	  sleep 3
	  echo
      echo "#######################################"
      echo "    Done ! Updating should go faster   "
      echo "#######################################"
      clear && sh $0
      ;;

    g )
      echo
      echo "#################################"
      echo "#   Fixing Pacman Databases..   #"
      echo "#################################"
      sleep 2
      echo
      echo "Step 1 - Deleting Existing Keys.. "
      echo "##################################"
      echo
      sudo rm -r /etc/pacman.d/gnupg/*
      sleep 2
      echo
      echo "Step 2 - Populating Keys.."
      echo "##########################"
      echo
      sudo pacman-key --init && sudo pacman-key --populate
      sleep 2
      echo
      echo "Step 3 - Adding Ubuntu keyserver.."
      echo "##################################"
      echo
      echo "keyserver hkp://keyserver.ubuntu.com:80" | sudo tee --append /etc/pacman.d/gnupg/gpg.conf
      echo
      echo "Step 4 - Updating ArchLinux Keyring.."
      echo "#####################################"
      echo
      sudo pacman -Syy --noconfirm archlinux-keyring
      echo
      echo "#######################################"
      echo "    Done ! Try Update now & Report     "
      echo "#######################################"
      sleep 6
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
