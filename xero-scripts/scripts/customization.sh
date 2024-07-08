#!/bin/bash

# Set window title
echo -ne "\033]0;System Customization\007"

# Function to check and install dependencies
check_dependency() {
  local dependency=$1
  command -v $dependency >/dev/null 2>&1 || { echo >&2 "$dependency is not installed. Installing..."; sudo pacman -S --noconfirm $dependency; }
}

# Function to display header
display_header() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "System Customization"
  echo
  gum style --foreground 33 "Hello $USER, please select an option. Press 'i' for the Wiki."
  echo
}

# Function to display options
display_options() {
  gum style --foreground 35 "1. Install Fastfetch."
  gum style --foreground 35 "2. Install Fish Shell."
  gum style --foreground 35 "3. Install ZSH All in one."
  gum style --foreground 35 "4. Hyprland Dot Files & Rices."
  echo
  gum style --foreground 200 "x. XeroLinux's Layan Plasma 6 Rice."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
}

# Function to handle errors and prompt user
handle_error() {
  echo
  gum style --foreground 196 "An error occurred. Would you like to retry or go back to the main menu? (r/m)"
  read -rp "Enter your choice: " choice
  case $choice in
    r|R) exec "$0" ;;
    m|M) clear && exec xero-cli -m ;;
    *) gum style --foreground 50 "Invalid choice. Returning to menu." ;;
  esac
  sleep 3
  clear && exec "$0"
}

# Function to handle Ctrl+C
handle_interrupt() {
  echo
  gum style --foreground 190 "Script interrupted. Do you want to exit or restart the script? (e/r)"
  read -rp "Enter your choice: " choice
  echo
  case $choice in
    e|E) exit 1 ;;
    r|R) exec "$0" ;;
    *) gum style --foreground 50 "Invalid choice. Returning to menu." ;;
  esac
  sleep 3
  clear && exec "$0"
}

# Trap errors and Ctrl+C
trap 'handle_error' ERR
trap 'handle_interrupt' SIGINT

# Function to process user choice
process_choice() {
  while :; do
    echo
    read -rp "Enter your choice: " CHOICE
    echo

    case $CHOICE in
      i)
        gum style --foreground 33 "Opening Wiki..."
        sleep 3
        xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#system-customization" > /dev/null 2>&1
        clear && exec "$0"
        ;;
      1)
        gum style --foreground 35 "Setting up Fastfetch..."
        sleep 2
        echo
        $AUR_HELPER -S --noconfirm --needed fastfetch
        fastfetch --gen-config
        gum style --foreground 35 "Fastfetch setup complete!"
        sleep 3
        clear && exec "$0"
        ;;
      2)
        gum style --foreground 35 "Setting up Fish Shell..."
        sleep 2
        echo
        sudo pacman -S --needed --noconfirm fish fastfetch
        fastfetch --gen-config
        sudo chsh $USER -s /bin/fish
        gum style --foreground 35 "Fish shell setup complete! Log out and back in."
        sleep 3
        clear && exec "$0"
        ;;
      3)
        gum style --foreground 35 "Setting up ZSH with OMP & OMZ Plugins..."
        sleep 2
        echo
        sudo pacman -S --needed --noconfirm zsh grml-zsh-config fastfetch
        $AUR_HELPER -S --noconfirm --needed ttf-meslo-nerd siji-git ttf-unifont noto-color-emoji-fontconfig xorg-fonts-misc ttf-dejavu ttf-meslo-nerd-font-powerlevel10k noto-fonts-emoji powerline-fonts oh-my-posh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
        cd $HOME/ && rm ~/.zshrc && wget https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/.zshrc
        fastfetch --gen-config && cd ~/.config/fastfetch && mv config.jsonc config.jsonc.bk && wget https://raw.githubusercontent.com/xerolinux/xero-layan-git/main/Configs/Home/.config/fastfetch/config.jsonc && wget -O Arch.png https://raw.githubusercontent.com/xerolinux/xero-fixes/main/xero.png && sed -i 's/xero.png/Arch.png/g' ~/.config/fastfetch/config.jsonc
        sudo chsh $USER -s /bin/zsh
        gum style --foreground 35 "ZSH setup complete! Log out and back in."
        sleep 3
        clear && exec "$0"
        ;;
      4)
        gum style --foreground 35 "Select Hyprland Dots..."
        select dots in "ML4W" "JaKooLit" "Prasanth" "Back"; do
          case $dots in
            ML4W) xdg-open "https://gitlab.com/stephan-raabe/dotfiles" > /dev/null 2>&1 && break ;;
            JaKooLit) xdg-open "https://github.com/JaKooLit/Arch-Hyprland" > /dev/null 2>&1 && break ;;
            Prasanth) xdg-open "https://github.com/prasanthrangan/hyprdots?tab=readme-ov-file" > /dev/null 2>&1 && break ;;
            Back) clear && exec "$0" && break ;;
            *) gum style --foreground 31 "Invalid option. Select 1, 2, or 3." ;;
          esac
        done
        gum style --foreground 35 "Hyprland Dots setup complete!"
        sleep 3
        clear && exec "$0"
        ;;
      x)
        gum style --foreground 200 "Setting up XeroLinux KDE Rice..."
        sleep 2
        echo
        cd ~ && git clone https://github.com/xerolinux/xero-layan-git.git
        cd ~/xero-layan-git/ && sh install.sh
        gum style --foreground 200 "XeroLinux KDE Rice setup complete!"
        sleep 3
        clear && exec "$0"
        ;;
      q)
        clear && exec xero-cli -m
        ;;
      *)
        gum style --foreground 31 "Invalid choice. Please select a valid option."
        echo
        ;;
    esac
    sleep 3
  done
}

# Main execution
check_dependency gum
display_header
display_options
process_choice
