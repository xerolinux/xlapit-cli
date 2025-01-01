#!/usr/bin/env bash
#set -e

######################################
# Author   :   DarkXero              #
# Website  :   http://xerolinux.xyz  #
######################################

# Set window title
echo -ne "\033]0;System Customization\007"

# Function to display header
display_header() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "System Customization"
  echo
  gum style --foreground 141 "Hello $USER, please select an option. Press 'i' for the Wiki."
  echo
}

# Function to display options
display_options() {
  gum style --foreground 7 "1. Setup Fastfetch (Vanilla Arch)."
  gum style --foreground 7 "2. Setup ble.sh tools for Bash Shell."
  gum style --foreground 7 "3. Setup Oh-My-Posh prompt (Vanilla Arch)."
  gum style --foreground 7 "4. Setup ZSH All in one with Oh-My-Posh/Plugs."
  echo
  gum style --foreground 178 "g. Change Grub Theme (Xero Script)."
  gum style --foreground 200 "x. XeroLinux's Layan Rice (Vanilla KDE)."
  gum style --foreground 153 "u. Layan GTK4 Patch & Update (Distro Only)."
}

# Function to handle errors and prompt user
handle_error() {
  echo
  gum style --foreground 196 "An error occurred. Would you like to retry or exit? (r/e)"
  read -rp "Enter your choice : " choice
  case $choice in
    r|R) exec "$0" ;;
    e|E) exit 0 ;;
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
    read -rp "Enter your choice, 'r' to reboot or 'q' for main menu : " CHOICE
    echo

    case $CHOICE in
      i)
        gum style --foreground 33 "Opening Wiki..."
        sleep 3
        xdg-open "https://wiki.xerolinux.xyz/xlapit/#system-customization" > /dev/null 2>&1
        clear && exec "$0"
        ;;
      1)
        gum style --foreground 7 "Setting up Fastfetch..."
        sleep 2
        echo
        sudo pacman -S --noconfirm --needed fastfetch imagemagick ffmpeg ffmpegthumbnailer ffmpegthumbs qt6-multimedia-ffmpeg
        fastfetch --gen-config
        # Change to the ~/.config/fastfetch directory
          cd "$HOME/.config/fastfetch" || exit

          # Rename the existing config file by appending .bk to its name
          mv config.jsonc{,.bk}

          # Download the new image and config file
          wget -qO Arch.png https://raw.githubusercontent.com/xerolinux/xero-fixes/main/xero.png
          wget -q https://raw.githubusercontent.com/xerolinux/xero-layan-git/main/Configs/Home/.config/fastfetch/config.jsonc

          # Update the config file to use the new image name
          sed -i 's/xero.png/Arch.png/' $HOME/.config/fastfetch/config.jsonc
        sleep 2
        echo
        add_fastfetch() {
          if ! grep -Fxq 'fastfetch' "$HOME/.bashrc"; then
            echo 'fastfetch' >> "$HOME/.bashrc"
            echo "fastfetch has been added to your .bashrc and will run on Terminal launch."
          else
            echo "fastfetch is already set to run on Terminal launch."
          fi
        }

        # Prompt the user
        read -p "Do you want to enable fastfetch to run on Terminal launch? (y/n): " response

        case "$response" in
          [yY])
            add_fastfetch
            ;;
          [nN])
            echo "fastfetch will not be added to your .bashrc."
            ;;
          *)
            echo "Invalid response. Please enter y or n."
            ;;
        esac
        echo
        gum style --foreground 7 "Fastfetch setup complete!"
        sleep 3
        clear && exec "$0"
        ;;
      2)
        gum style --foreground 7 "Setting up ble.sh for Bash..."
        sleep 2
        echo
        curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf -
        bash ble-nightly/ble.sh --install ~/.local/share
        echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
        echo
        gum style --foreground 7 "Setup complete! Log out and back in."
        sleep 3
        clear && exec "$0"
        ;;
      3)
        gum style --foreground 7 "Setting up Oh-My-Posh..."
        sleep 2
        echo
        $AUR_HELPER -S --noconfirm --needed oh-my-posh-bin
        mkdir -p "$HOME/.config/ohmyposh"
        curl -o "$HOME/.config/ohmyposh/xero.omp.json" https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/pararussel.omp.json
        echo "Injecting OMP to .bashrc"
        # Define the lines to be added
        line1='# Oh-My-Posh Config'
        line2='eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/xero.omp.json)"'

        # Define the .bashrc file
        bashrc_file="$HOME/.bashrc"

        # Function to add lines if not already present
        add_lines() {
          if ! grep -qxF "$line1" "$bashrc_file"; then
            echo "" >> "$bashrc_file"  # Add an empty line before line1
            echo "$line1" >> "$bashrc_file"
          fi

          if ! grep -qxF "$line2" "$bashrc_file"; then
            echo "$line2" >> "$bashrc_file"
            echo "" >> "$bashrc_file"  # Add an empty line after line2
          fi
        }

        # Run the function to add lines
        add_lines
        echo
        gum style --foreground 7 "Oh-My-Posh setup complete! Restart Shell."
        sleep 6
        clear && exec "$0"
        ;;
      4)
        gum style --foreground 7 "Setting up ZSH with OMP & OMZ Plugins..."
        sleep 2
        echo
        sudo pacman -S --needed --noconfirm zsh grml-zsh-config fastfetch
        $AUR_HELPER -S --noconfirm --needed ttf-meslo-nerd siji-git ttf-unifont noto-color-emoji-fontconfig xorg-fonts-misc ttf-dejavu ttf-meslo-nerd-font-powerlevel10k noto-fonts-emoji powerline-fonts oh-my-posh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        cd $HOME/ && mv ~/.zshrc ~/.zshrc.user && wget https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/.zshrc
        sleep 2
        echo
        echo "Applying Oh-My-Posh to ZSH"
        echo
        # Check if the folder exists, if not create it and download the file
        if [ ! -d "$HOME/.config/ohmyposh" ]; then
          mkdir -p "$HOME/.config/ohmyposh"
        fi
        curl -o "$HOME/.config/ohmyposh/xero.omp.json" https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/pararussel.omp.json

        # Check if the line exists in ~/.zshrc, if not add it
        if ! grep -Fxq 'eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/xero.omp.json)"' "$HOME/.zshrc"; then
          echo '' >> "$HOME/.zshrc"
          echo 'eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/xero.omp.json)"' >> "$HOME/.zshrc"
        fi
        sleep 2
        echo
        echo "Switching to ZSH..."
        echo
        sudo chsh $USER -s /bin/zsh
        # Check if the current terminal is Konsole and if KDE Plasma is running
        if [[ "$KONSOLE_VERSION" && "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
            sed -i 's|Command=/bin/bash|Command=/bin/zsh|' "$HOME/.local/share/konsole/XeroLinux.profile"
        fi
        echo
        gum style --foreground 7 "ZSH setup complete! Log out and back in."
        sleep 3
        clear && exec "$0"
        ;;
      g)
        gum style --foreground 7 "XeroLinug Grub Themes..."
        sleep 2
        echo
        cd ~ && git clone https://github.com/xerolinux/xero-grubs
        cd ~/xero-grubs/ && sh install.sh
        echo
        rm -rf ~/xero-grubs/
        sleep 3
        clear && exec "$0"
        ;;
      x)
        gum style --foreground 200 "Setting up XeroLinux KDE Rice..."
        sleep 2
        echo
        cd ~ && git clone https://github.com/xerolinux/xero-layan-git.git
        cd ~/xero-layan-git/ && sh install.sh
        echo
        gum style --foreground 200 "XeroLinux KDE Rice setup complete!"
        sleep 3
        # Countdown from 15 to 1
        for i in {15..1}; do
            dialog --infobox "Rebooting in $i seconds..." 3 30
            sleep 1
        done

        # Reboot after the countdown
        reboot
        sleep 3
        ;;
      u)
        gum style --foreground 200 "Applying Layan GTK4 Patch/Updating..."
        sleep 2
        echo
        cd ~ && git clone https://github.com/vinceliuice/Layan-gtk-theme.git
        cd ~/Layan-gtk-theme/ && sh install.sh -l -c dark -d $HOME/.themes
        cd ~ && rm -Rf Layan-gtk-theme/
        sleep 3
        echo
        gum style --foreground 200 "Updating Layan KDE Theme..."
        echo
        cd ~ && git clone https://github.com/vinceliuice/Layan-kde.git
        cd ~/Layan-kde/ && sh install.sh
        cd ~ && rm -Rf Layan-kde/
        echo
        gum style --foreground 200 "GTK4 Pacthing & Update Complete!"
        sleep 3
        clear && exec "$0"
        ;;
      r)
        gum style --foreground 33 "Rebooting System..."
        sleep 3
        # Countdown from 5 to 1
        for i in {5..1}; do
            dialog --infobox "Rebooting in $i seconds..." 3 30
            sleep 1
        done

        # Reboot after the countdown
        reboot
        sleep 3
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
display_header
display_options
process_choice
