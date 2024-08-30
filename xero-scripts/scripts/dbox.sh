#!/usr/bin/env bash
#set -e

######################################
# Author   :   DarkXero              #
# Website  :   http://xerolinux.xyz  #
######################################

# Set window title
echo -ne "\033]0;Docker & Distrobox\007"

check_distro() {
  # Check if figlet is installed; if not, install it
  if ! command -v figlet &> /dev/null; then
    echo "Figlet not found, installing it..."
    sudo pacman -S --noconfirm figlet
  fi
  source /etc/os-release
  if [ "$ID" != "arch" ] && [ "$ID" != "XeroLinux" ]; then
    # Display the message in blinking red and centered
    tput setaf 3    # Set text color to red
    #tput blink     # Enable blinking text
    clear           # Clear the terminal window

    # Use figlet to create large ASCII text
    message="This toolkit is only compatible with Vanilla Arch & XeroLinux!"
    echo "$(tput cup $(($(tput lines) / 2)) $(($(tput cols) / 2 - ${#message} / 2)))"
    figlet -c "$message"

    tput sgr0      # Reset all attributes
    exit 1
  fi
}

# Function to check and install dependencies
check_dependency() {
  local dependency=$1
  command -v $dependency >/dev/null 2>&1 || { echo >&2 "$dependency is not installed. Installing..."; sudo pacman -S --noconfirm $dependency; }
}

# Function to display header
display_header() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "XeroLinux Distrobox/Docker Tool"
  echo
  gum style --foreground 33 "Hello $USER, what would you like to do? Press 'i' for the Wiki."
  echo
}

# Function to display options
display_options() {
  gum style --foreground 215 "====== Docker/DistroBox ======"
  echo
  gum style --foreground 35 "1. Install Docker."
  gum style --foreground 35 "2. Install Distrobox."
  echo
  gum style --foreground 200 "====== DistroBox Images ======"
  echo
  gum style --foreground 35 "3. Pull Latest Debian Image."
  gum style --foreground 35 "4. Pull Latest Fedora Image."
  gum style --foreground 35 "5. Pull Latest Tumbleweed Image."
  echo
  gum style --foreground 35 "6. Update all Containers (Might take a while)."
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
        xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#distrobox--docker" > /dev/null 2>&1
        clear && exec "$0"
        ;;
      1)
        gum style --foreground 35 "Installing & Setting up Docker..."
        sleep 2
        echo
        sudo pacman -S --noconfirm --needed docker docker-compose docker-buildx || handle_error
        $AUR_HELPER -S --noconfirm --needed lazydocker-bin
        # Prompt the user
        echo
        gum confirm "Do you want to install Podman Desktop ?" && \
            flatpak install io.podman_desktop.PodmanDesktop -y || \
            echo "Podman Desktop installation skipped."
        sleep 2
        echo
        sudo systemctl enable --now docker || handle_error
        sudo usermod -aG docker "$USER" || handle_error
        sleep 2
        gum style --foreground 35 "Docker setup complete!"
        sleep 3
        clear && exec "$0"
        ;;
      2)
        gum style --foreground 35 "Installing Distrobox..."
        sleep 2
        echo
        sudo pacman -S --noconfirm --needed distrobox || handle_error
        flatpak install -y io.github.dvlv.boxbuddyrs
        echo
        gum style --foreground 35 "Distrobox installation complete!"
        sleep 3
        clear && exec "$0"
        ;;
      3)
        gum style --foreground 35 "Pulling Latest Debian Image with label 'Debian'..."
        sleep 2
        echo
        distrobox create -i quay.io/toolbx-images/debian-toolbox:latest -n "Debian" || handle_error
        sleep 10
        gum style --foreground 35 "Debian image pulled successfully!"
        sleep 3
        clear && exec "$0"
        ;;
      4)
        gum style --foreground 35 "Pulling Latest Fedora Image with label 'Fedora'..."
        sleep 2
        echo
        distrobox create -i registry.fedoraproject.org/fedora-toolbox:latest -n "Fedora" || handle_error
        sleep 10
        gum style --foreground 35 "Fedora image pulled successfully!"
        sleep 3
        clear && exec "$0"
        ;;
      5)
        gum style --foreground 35 "Pulling Latest Tumbleweed Image with label 'OpenSuse'..."
        sleep 2
        echo
        distrobox create -i registry.opensuse.org/opensuse/tumbleweed:latest -n "OpenSuse" || handle_error
        sleep 10
        gum style --foreground 35 "Tumbleweed image pulled successfully!"
        sleep 3
        clear && exec "$0"
        ;;
      6)
        gum style --foreground 35 "Upgrading all Containers..."
        sleep 2
        echo
        distrobox upgrade --all || handle_error
        gum style --foreground 35 "All containers upgraded successfully!"
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
check_distro
check_dependency gum
display_header
display_options
process_choice
