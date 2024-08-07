#!/usr/bin/env bash
#set -e

######################################
# Author   :   DarkXero              #
# Website  :   http://xerolinux.xyz  #
######################################

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
  gum style --foreground 35 "1. Setup Fastfetch."
  gum style --foreground 35 "2. Setup Fish Shell."
  gum style --foreground 35 "3. Setup Oh-My-Posh (Bash)."
  gum style --foreground 35 "4. Setup ZSH All in one w/OMP."
  gum style --foreground 35 "5. Setup Gnome Extenstion Tools."
  gum style --foreground 35 "6. Top 3 Hyprland Advanced Dot Files."
  echo
  gum style --foreground 200 "x. XeroLinux's Layan Plasma 6 Rice."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
}

# Function to handle errors and prompt user
handle_error() {
  echo
  gum style --foreground 196 "An error occurred. Would you like to retry or exit? (r/e)"
  read -rp "Enter your choice: " choice
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
        gum style --foreground 35 "Setting up Oh-My-Posh..."
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
        gum style --foreground 35 "Oh-My-Posh setup complete! Restart Shell."
        sleep 6
        clear && exec "$0"
        ;;
      4)
        gum style --foreground 35 "Setting up ZSH with OMP & OMZ Plugins..."
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
        gum style --foreground 35 "ZSH setup complete! Log out and back in."
        sleep 3
        clear && exec "$0"
        ;;
      5)
        gum style --foreground 35 "Setting up Gnome Extension Tools..."
        sleep 2
        echo
        $AUR_HELPER -S --noconfirm --needed extension-manager dconf-editor gnome-tweaks gnome-shell-extensions
        echo
        gum style --foreground 35 "Done ! Have fun tweaking Gnome ;)"
        sleep 3
        clear && exec "$0"
        ;;
      6)
        gum style --foreground 35 "Select Hyprland Dots..."
        select dots in "ML4W" "JaKooLit" "Prasanth" "Back"; do
          case $dots in
            ML4W) xdg-open "https://github.com/mylinuxforwork/dotfiles" > /dev/null 2>&1 && break ;;
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
