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
echo "Hello $USER, Please Select What Drivers to install. Press i for the Wiki."
echo
echo "################## GPU / Printing ##################"
echo
echo "g. GPU Drivers (Forum Link)."
echo "p. Printer Drivers and Tools."
echo "m. Samba Tools (XeroLinux Repo)."
echo "k. Scanner Drivers (XeroLinux Repo)."
echo "c. Game Controller Drivers (PS4/5/XBox)."
echo "d. DeckLink & StreamDeck Drivers/Tools (AUR)."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    i )
      echo
      sleep 2
      xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#system-drivers"  > /dev/null 2>&1
      echo
      clear && sh $0
      ;;

    g )
      echo
      sleep 2
      xdg-open "https://forum.xerolinux.xyz/thread-364.html"  > /dev/null 2>&1
      echo
      clear && sh $0
      ;;

    p )
      echo
      sudo pacman -S --needed --noconfirm ghostscript gsfonts cups cups-filters cups-pdf system-config-printer avahi system-config-printer foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds python-pyqt5
      echo
      sudo systemctl enable --now avahi-daemon cups.socket
      echo
      sudo groupadd lp && sudo groupadd cups && sudo usermod -aG sys,lp,cups $(whoami)
      echo
      echo "#################################"
      echo "              Done !             "
      echo "#################################"
      sleep 3
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
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      sleep 3
      clear && sh $0
      ;;

    k )
      echo
      echo "############################################"
      echo "          Installing Scanner Tools          "
      echo "############################################"
      sleep 3
      echo
      sudo pacman -S --noconfirm --needed scanner-support
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      sleep 3
      clear && sh $0
      ;;

    c )
      echo
      # Function to install packages using AUR Helper
      install_aur_packages() {
          $AUR_HELPER -S --noconfirm --needed $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select Controller Driver to install:" 20 60 7 \
          "DualShock4" "PS4 Controller Driver" OFF \
          "DualSense" "PS5 DualSense Controller Driver" OFF \
          "XBoxOne" "Xbox One Wireless Gamepad Driver" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      DualShock4)
                          install_aur_packages ds4drv game-devices-udev \
                          && echo "" \
                          && echo "_:: Please follow guide on Github for configuration ::_" \
                          && sleep 3 \
                          && xdg-open "https://github.com/chrippa/ds4drv"  > /dev/null 2>&1 \
                          && sleep 6
                          ;;
                      DualSense)
                          install_aur_packages dualsensectl game-devices-udev \
                          && echo "" \
                          && echo "_:: Please follow guide on Github for configuration ::_" \
                          && sleep 3 \
                          && xdg-open "https://github.com/nowrep/dualsensectl"  > /dev/null 2>&1 \
                          && sleep 6
                          ;;
                      XBoxOne)
                          install_aur_packages xone-dkms game-devices-udev \
                          && echo "" \
                          && echo "_:: Please follow guide on Github for configuration ::_" \
                          && sleep 3 \
                          && xdg-open "https://github.com/medusalix/xone"  > /dev/null 2>&1 \
                          && sleep 6
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
    
    d )
      echo
      # Function to install packages using AUR Helper
      install_aur_packages() {
          $AUR_HELPER -S --noconfirm --needed $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select Tools to install (Might take a while) :" 20 60 7 \
          "Decklink" "Drivers for DeckLink" OFF \
          "DeckMaster" "App to control the Stream Deck" OFF \
          "StreamDeckUI" "A Linux UI for the Stream Deck" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      Decklink)
                          install_aur_packages decklink
                          ;;
                      DeckMaster)
                          install_aur_packages deckmaster-bin \
                          && echo "" \
                          && echo "_:: Please follow guide on Github for configuration ::_" \
                          && sleep 3 \
                          && xdg-open "https://github.com/muesli/deckmaster"  > /dev/null 2>&1 \
                          && sleep 6
                          ;;
                      StreamDeckUI)
                          install_aur_packages streamdeck-ui \
                          && echo "" \
                          && echo "_:: Please follow guide on Github for configuration ::_" \
                          && sleep 3 \
                          && xdg-open "https://streamdeck-linux-gui.github.io/streamdeck-linux-gui"  > /dev/null 2>&1 \
                          && sleep 6
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
