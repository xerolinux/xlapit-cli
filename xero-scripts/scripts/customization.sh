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
echo "Hello $USER, please select what to do. Press i for the Wiki."
echo
echo "################# Shell / Prompts ################"
echo
echo "f. Install Fish Shell."
echo "z. Install ZSH+OMZ+Powerlevel10k."
echo
echo "################## DE/WM Ricing ##################"
echo
echo "k. XeroLinux KDE Rice"
echo "h. Hyprland Dot Files/Rices"
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    i )
      echo
      sleep 2
      xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#system-customization"  > /dev/null 2>&1
      echo
      clear && sh $0

      ;;

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
      $AUR_HELPER -S --noconfirm --needed ttf-meslo-nerd siji-git ttf-unifont noto-color-emoji-fontconfig xorg-fonts-misc ttf-dejavu ttf-meslo-nerd-font-powerlevel10k noto-fonts-emoji powerline-fonts zsh-theme-powerlevel10k
      echo
      mkdir ~/.config/neofetch && cd ~/.config/neofetch && wget https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/config.conf
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
      sleep 6
      clear && sh $0

      ;;

    z )
      echo
      echo "######################################"
      echo "Setting up ZSH With p10k & OMZ Plugins"
      echo "######################################"
      sleep 2
      echo "Step 1 - Grabing Necessary Fonts"
      echo "################################"
      sudo pacman -S --needed --noconfirm zsh grml-zsh-config neofetch
      $AUR_HELPER -S --noconfirm --needed ttf-meslo-nerd siji-git ttf-unifont noto-color-emoji-fontconfig xorg-fonts-misc ttf-dejavu ttf-meslo-nerd-font-powerlevel10k noto-fonts-emoji powerline-fonts zsh-theme-powerlevel10k
      sleep 2
      echo "Step 2 - Grabing OhMyZsh & Plugins"
      echo "##################################"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
      git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
      git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
      sleep 2
      echo "Step 3 - Grabing PowerLevel10k Theme"
      echo "#####################################"
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
      cd $HOME/ && wget https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/.p10k.zsh \
      && rm ~/.zshrc && wget https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/.zshrc \
      && mkdir ~/.config/neofetch && cd ~/.config/neofetch && wget https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/config.conf
      sleep 2
      echo "Step 4 - Setting Default Shell to ZSH"
      echo "#####################################"
      sudo chsh $USER -s /bin/zsh
      echo "#####################################"
      echo "     Done ! Now Logout & back in     "
      echo "#####################################"
      sleep 6
      clear && sh $0

      ;;

    k )
      echo
      echo "######################################"
      echo "    Setting up the XeroLayan Rice.    "
      echo "######################################"
      echo
      cd ~ && git clone https://github.com/xerolinux/xero-layan-git.git
      echo
      cd ~/xero-layan-git/ && sh install.sh
      sleep 4
      clear && sh $0

      ;;

    h )
      echo
      echo "##########################################"
      echo "           Select Hyprland Dots           "
      echo "##########################################"
      echo
      select dots in "ML4W" "JaKooLit" "Prasanth" "Back"; do case $dots in ML4W) xdg-open "https://gitlab.com/stephan-raabe/dotfiles"  > /dev/null 2>&1 && break ;; JaKooLit) xdg-open "https://github.com/JaKooLit/Arch-Hyprland"  > /dev/null 2>&1 && break ;; Prasanth) xdg-open "https://github.com/prasanthrangan/hyprdots?tab=readme-ov-file"  > /dev/null 2>&1 && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, 3 or 4." ;; esac done
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
