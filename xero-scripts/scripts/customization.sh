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
echo "#              System Customization             #"
echo "#################################################"
tput sgr0
echo
echo "Hello $USER, please select what to do..."
echo
echo "################# Shell / Others #################"
echo
echo "f. Install Fish Shell."
echo "z. Install ZSH+OMZ+Powerlevel10k."
echo "g. Launch Grub Theme Installer TUI."
echo "s. Install and Apply Starship Bash Prompt."
echo
echo "################# Plasma Stuffs #################"
echo
echo "#################################################"
echo "#          Rices Currently Unavailable.         #"
echo "#################################################"
echo
echo "p. Install missing Plasma Packages."
echo "m. Apply AppMenu Meta-Key Fix (Kwin/Rices)."
echo "w. Apply xWayland Screen/Window Sharing Fix."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    f )
      echo
      echo "#######################################"
      echo "         Setting up Fish Shell         "
      echo "#######################################"
      sleep 2
      echo
      echo "Step 1 - Fish Shell & Fonts"
      echo "################################"
      sudo pacman -S --needed --noconfirm fish neofetch
      echo
      $AUR_HELPER -S --noconfirm ttf-meslo-nerd siji-git ttf-unifont noto-color-emoji-fontconfig xorg-fonts-misc ttf-dejavu ttf-meslo-nerd-font-powerlevel10k noto-fonts-emoji powerline-fonts zsh-theme-powerlevel10k
      echo
      echo "Step 2 - Setting Fish as default"
      echo "################################"
      echo
      sudo chsh $USER -s /bin/fish
      echo
      sleep 2
      echo
      echo "Done Please Log-out n back in !"
      echo "###############################"
      clear && sh $0


      ;;

    g )
      echo
	  sleep 2
	  cd ~ && git clone https://github.com/xerolinux/xero-grubs && cd ~/xero-grubs/ && sudo sh install.sh
	  sleep 2
      clear && sh $0

      ;;

    s )
      echo
      echo "###########################################"
      echo "              Starship Prompt              "
      echo "###########################################"
      sleep 3
      sudo pacman -S starship
      mkdir -p ~/.config/starship && cd ~/.config/starship
      wget https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/starship.toml
      echo 'eval "$(starship init bash)"' >> ~/.bashrc
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      clear && sh $0
      ;;

    p )
      echo
	  sleep 2
	  echo "Installing Missing Plasma Packages..."
	  echo
      sleep 3
      $AUR_HELPER -S --noconfirm flatpak-kcm systemd-kcm kdeplasma-addons keditbookmarks kgpg kwalletmanager print-manager yakuake tesseract-data-eus dolphin-plugins gwenview kamera okular spectacle svgpart plasmatube dwayland egl-wayland qt6-wayland glfw-wayland lib32-wayland wayland-protocols kwayland-integration plasma-wayland-session plasma-wayland-protocols
      echo
      sleep 2
      echo "All done, please reboot for good measure !"
	  sleep 3
      clear && sh $0

      ;;

    m )
      echo
	  sleep 2
	  echo "Applying Meta-Key AppMenu fix..."
      echo
      kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.plasmashell,/PlasmaShell,org.kde.PlasmaShell,activateLauncherMenu"
      sleep 3
      echo "Relaunching Kwin..."
      qdbus org.kde.KWin /KWin reconfigure
      echo
      echo "All done, should work now !"
	  sleep 3
      clear && sh $0

      ;;

    w )
      echo
	  sleep 2
	  echo "Installing XWayland Bridge..."
	  echo
      sleep 3
      sudo pacman -S --noconfirm xwaylandvideobridge
      echo
      sleep 2
      echo "All done, please reboot for good measure !"
	  sleep 3
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
