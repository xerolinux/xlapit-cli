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
echo "1. Add/Update Microcode Module."
echo "2. Install & Activate Firewald."
echo "3. Clear Pacman Cache (Free Space)."
echo "4. Restart PipeWire/PipeWire-Pulse."
echo "5. Unlock Pacman DB (In case of DB error)."
echo "6. Activate v4l2loopback for OBS-VirtualCam."
echo "7. Activate Flatpak Theming (Required If used)."
echo "8. Activate OS-Prober for Dual-Booting with other OS."
echo "9. Install/Activate Power Daemon for Laptops/Desktops."
echo
echo "d. Fix Discover PackageKit issue."
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
      cpu=$(cat /proc/cpuinfo | awk '/vendor_id/ {print $3}' | head -n 1)
      echo "Installing microcode for : " $cpu
      echo
      sleep 6
      if [[ "$cpu" == "GenuineIntel" ]]; then
          sudo pacman -S --noconfirm --needed intel-ucode
      elif [[ "$cpu" == "AuthenticAMD" ]]; then
          sudo pacman -S --noconfirm --needed amd-ucode
      else
      echo
      echo "Unknown CPU : $cpu maybe a Virtual Machine ?"
          sudo pacman -Rdd --noconfirm intel-ucode amd-ucode
      fi
      echo
      # HOOKS=(base udev microcode autodetect kms modconf block keyboard keymap consolefont filesystems fsck)
      if grep -q microcode /etc/mkinitcpio.conf; then
         echo "Microcode is already in, Skipping...."
      else
         echo "Adding microcode module..."
         sudo sed -i "s/^HOOKS=(base udev/HOOKS=(base udev microcode/g" /etc/mkinitcpio.conf;
         sleep 3
         echo
         sudo mkinitcpio -P
      fi
      echo
	  echo "#################################"
      echo "        All Done, Reboot         "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    2 )
      echo
	  sleep 2
      sudo pacman -S --needed --noconfirm firewalld python-pyqt5 python-capng
      echo
      sudo systemctl enable --now firewalld.service
      echo
      echo "#################################"
      echo "        All Done, Enjoy!         "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    3 )
      echo
	  sleep 2
      sudo pacman -Scc
      sleep 2
      echo
      clear && sh $0

      ;;


    4 )
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
      echo "        All Done, Try now        "
      echo "#################################"
	  sleep 2
      clear && sh $0

      ;;


    5 )
      echo
	  sleep 2
	  sudo rm /var/lib/pacman/db.lck
	  sleep 2
      clear && sh $0

      ;;


    6 )
      echo
      echo "##########################################"
      echo "          Setting up v4l2loopback         "
      echo "##########################################"
      sleep 3
      sudo pacman -S --noconfirm --needed v4l2loopback-dkms v4l2loopback-utils
      sleep 3
      # Create or append to /etc/modules-load.d/v4l2loopback.conf
      echo "v4l2loopback" | sudo tee /etc/modules-load.d/v4l2loopback.conf > /dev/null

      # Create /etc/modprobe.d/v4l2loopback.conf with specified content
      echo 'options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Camera"' | sudo tee /etc/modprobe.d/v4l2loopback.conf > /dev/null

      # Prompt user to reboot
      echo "Please reboot your system for changes to take effect."
      sleep 2
      clear && sh $0

      ;;

    7 )
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


    8 )
      echo
	  sleep 2
	  echo "#####################################"
      echo "#   Activating OS-Prober in Grub.   #"
      echo "#####################################"
      sleep 3
      sudo pacman -S --noconfirm --needed os-prober
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
        
    9 )
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
    
    d )
      echo
      echo "##########################################"
      echo "    Fixing Discover's PackageKit issue    "
      echo "##########################################"
	  sleep 3
	  echo
	  # Check if the file exists
	  if [ -f "/usr/share/polkit-1/actions/org.freedesktop.packagekit.policy" ]; then
         # If it exists, rename it
         sudo mv /usr/share/polkit-1/actions/org.freedesktop.packagekit.policy /usr/share/polkit-1/actions/org.freedesktop.packagekit.policy.old
      fi
      # Install packagekit-qt6
      sudo pacman -S --needed --noconfirm packagekit-qt6
	  echo
      echo "#######################################"
      echo "    Done ! Discover should work now.   "
      echo "#######################################"
      sleep 3
      clear && sh $0
      ;;

    m )
      echo
      echo "##########################################"
      echo "     Updating Mirrors To Fastest Ones     "
      echo "##########################################"
	  sleep 3
	  echo
	  sudo pacman -S --noconfirm --needed reflector
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
      clear && xero-cli -m

      ;;

    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
