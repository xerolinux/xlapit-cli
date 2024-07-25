#!/usr/bin/env bash
set -e

######################################
# Author   :   DarkXero              #
# Website  :   http://xerolinux.xyz  #
######################################

# Set window title
echo -ne "\033]0;Essential Package Installer\007"

# Function to check and install dependencies
check_dependency() {
  local dependency=$1
  command -v $dependency >/dev/null 2>&1 || { echo >&2 "$dependency is not installed. Installing..."; sudo pacman -S --noconfirm $dependency; }
}

# Function to display header
display_header() {
  clear
  gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "Essential Package Installer"
  gum style --foreground 33 "Hello $USER, this will install extra packages. Press 'i' for the Wiki."
  echo
}

# Function to display options
display_options() {
  gum style --foreground 35 "1. LibreOffice."
  gum style --foreground 35 "2. Web Browsers."
  gum style --foreground 35 "3. System Tools."
  gum style --foreground 35 "4. Development Tools."
  gum style --foreground 35 "5. Photo and 3D Tools."
  gum style --foreground 35 "6. Music & Audio Tools."
  gum style --foreground 35 "7. Social & Chat Tools."
  gum style --foreground 35 "8. Virtualization Tools."
  gum style --foreground 35 "9. Video Tools & Software."
  echo
  gum style --foreground 33 "Type your selection or 'q' to return to main menu."
}

# Function to handle errors and prompt user
handle_error() {
  echo
  gum style --foreground 196 "An error occurred. Would you like to retry or go back to the main menu? (r/m)"
  read -rp "Enter your choice: " choice
  echo
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

# Function to install packages using pacman
install_pacman_packages() {
    sudo pacman -S --noconfirm --needed "$@"
}

# Function to install packages using AUR Helper
install_aur_packages() {
    $AUR_HELPER -S --noconfirm --needed "$@"
}

# Function to install flatpak packages
install_flatpak_packages() {
    flatpak install -y "$@"
}

# Function to display package selection dialog
package_selection_dialog() {
    local title=$1
    shift
    local options=("$@")
    PACKAGES=$(dialog --checklist "$title" 20 80 10 "${options[@]}" 3>&1 1>&2 2>&3)

    if [ -n "$PACKAGES" ]; then
        for PACKAGE in $PACKAGES; do
            case $PACKAGE in
                Brave)
                    clear
                    install_aur_packages brave-bin
                    ;;
                Firefox)
                    clear
                    install_pacman_packages firefox firefox-ublock-origin
                    ;;
                Filezilla)
                    clear
                    install_pacman_packages filezilla
                    ;;
                Vivaldi)
                    clear
                    install_flatpak_packages com.vivaldi.Vivaldi
                    ;;
                Mullvad)
                    clear
                    install_aur_packages mullvad-browser-bin
                    ;;
                Floorp)
                    clear
                    install_flatpak_packages flathub one.ablaze.floorp
                    ;;
                LibreWolf)
                    clear
                    install_flatpak_packages io.gitlab.librewolf-community
                    ;;
                Chromium)
                    clear
                    install_flatpak_packages com.github.Eloston.UngoogledChromium
                    ;;
                Tor)
                    clear
                    install_flatpak_packages org.torproject.torbrowser-launcher
                    ;;
                neoVim)
                    clear
                    install_pacman_packages neovim tmux neovim-lsp_signature neovim-lspconfig neovim-nvim-treesitter
                    ;;
                Hugo)
                    clear
                    install_aur_packages gohugo-extended-bin
                    ;;
                Github)
                    clear
                    install_flatpak_packages io.github.shiftey.Desktop
                    ;;
                VSCodium)
                    clear
                    install_aur_packages vscodium-bin vscodium-bin-marketplace vscodium-bin-features
                    ;;
                Meld)
                    clear
                    install_pacman_packages meld
                    ;;
                Zed)
                    clear
                    install_pacman_packages zed
                    ;;
                Emacs)
                    clear
                    echo "Please select which version you want to install :"
                    echo
                    echo "1. Vanilla Emacs"
                    echo "2. DistroTube's Emacs"
                    echo
                    read -rp "Enter your choice (1 or 2): " emacs_choice
                    echo
                    case $emacs_choice in
                        1)
                            install_pacman_packages emacs ttf-ubuntu-font-family ttf-jetbrains-mono-nerd ttf-jetbrains-mono
                            ;;
                        2)
                            install_pacman_packages emacs ttf-ubuntu-font-family ttf-jetbrains-mono-nerd ttf-jetbrains-mono
                            echo
                            echo ".:: Importing DistroTube's Custom emacs Config ::."
                            echo
                            cd ~ && git clone https://github.com/xerolinux/eMacs-Config.git && cd eMacs-Config/ && cp -R emacs/ $HOME/.config
                            rm -rf ~/emacs/
                            sleep 6
                            ;;
                        *)
                            echo "Invalid choice. Returning to menu."
                            ;;
                    esac
                    ;;
                LazyGit)
                    clear
                    install_pacman_packages lazygit
                    ;;
                Eclipse)
                    clear
                    install_flatpak_packages org.eclipse.Java
                    ;;
                IntelliJ)
                    clear
                    install_flatpak_packages com.jetbrains.IntelliJ-IDEA-Community
                    ;;
                GiMP)
                    clear
                    install_flatpak_packages org.gimp.GIMP org.gimp.GIMP.Manual org.gimp.GIMP.Plugin.Resynthesizer org.gimp.GIMP.Plugin.LiquidRescale org.gimp.GIMP.Plugin.Lensfun org.gimp.GIMP.Plugin.GMic org.gimp.GIMP.Plugin.Fourier org.gimp.GIMP.Plugin.FocusBlur org.gimp.GIMP.Plugin.BIMP
                    ;;
                Krita)
                    clear
                    install_flatpak_packages flathub org.kde.krita
                    ;;
                Blender)
                    clear
                    install_pacman_packages blender
                    ;;
                GoDot)
                    clear
                    install_pacman_packages godot
                    ;;
                Unreal)
                    clear
                    install_aur_packages unreal-engine-bin
                    ;;
                MPV)
                    clear
                    install_pacman_packages mpv mpv-mpris
                    ;;
                Spotify)
                    clear
                    install_flatpak_packages com.spotify.Client
                    ;;
                Tenacity)
                    clear
                    install_flatpak_packages org.tenacityaudio.Tenacity
                    ;;
                Strawberry)
                    clear
                    install_flatpak_packages org.strawberrymusicplayer.strawberry
                    ;;
                Spotube)
                    clear
                    install_flatpak_packages com.github.KRTirtho.Spotube
                    ;;
                Cider)
                    clear
                    install_flatpak_packages flathub sh.cider.Cider
                    ;;
                Vesktop)
                    clear
                    install_flatpak_packages dev.vencord.Vesktop
                    ;;
                Ferdium)
                    clear
                    install_flatpak_packages org.ferdium.Ferdium
                    ;;
                Telegram)
                    clear
                    install_flatpak_packages org.telegram.desktop
                    ;;
                Tokodon)
                    clear
                    install_flatpak_packages org.kde.tokodon
                    ;;
                WhatsApp)
                    clear
                    install_flatpak_packages com.rtosta.zapzap
                    ;;
                Chatterino)
                    clear
                    install_flatpak_packages com.chatterino.chatterino
                    ;;
                Element)
                    clear
                    install_pacman_packages element-desktop
                    ;;
                SimpleX)
                    clear
                    install_flatpak_packages chat.simplex.simplex
                    ;;
                VirtManager)
                    clear
                    sudo pacman -Rdd --noconfirm iptables
                    install_pacman_packages virt-manager-meta vde2 ebtables dmidecode
                    echo -e "options kvm-intel nested=1" | sudo tee -a /etc/modprobe.d/kvm-intel.conf
                    sudo virsh net-define /etc/libvirt/qemu/networks/default.xml
                    sudo virsh net-autostart default
                    sudo systemctl restart libvirtd.service
                    ;;
                VirtualBox)
                    clear
                    install_pacman_packages virtualbox-meta
                    ;;
                KDEnLive)
                    clear
                    install_pacman_packages kdenlive
                    ;;
                DaVinci)
                    clear
                    install_aur_packages davinci-resolve
                    ;;
                OBS-Studio)
                    clear
                    install_flatpak_packages com.obsproject.Studio com.obsproject.Studio.Plugin.waveform com.obsproject.Studio.Plugin.WebSocket com.obsproject.Studio.Plugin.TransitionTable com.obsproject.Studio.Plugin.SceneSwitcher com.obsproject.Studio.Plugin.ScaleToSound com.obsproject.Studio.Plugin.OBSVkCapture com.obsproject.Studio.Plugin.OBSLivesplitOne com.obsproject.Studio.Plugin.NDI com.obsproject.Studio.Plugin.MoveTransition com.obsproject.Studio.Plugin.Gstreamer com.obsproject.Studio.Plugin.GStreamerVaapi com.obsproject.Studio.Plugin.DroidCam com.obsproject.Studio.Plugin.BackgroundRemoval
                    ;;
                Mystiq)
                    clear
                    install_aur_packages mystiq
                    ;;
                MKVToolNix)
                    clear
                    install_pacman_packages mkvtoolnix-gui
                    ;;
                MakeMKV)
                    clear
                    install_flatpak_packages com.makemkv.MakeMKV
                    ;;
                Avidemux)
                    clear
                    install_pacman_packages avidemux-qt
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

# Function to process user choice
process_choice() {
  while :; do
    echo
    read -rp "Enter your choice: " CHOICE
    echo

    case $CHOICE in
      i)
        xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features#recommended-packages" > /dev/null 2>&1
        clear && exec "$0"
        ;;
      1)
        sudo pacman -S --noconfirm --needed libreoffice-fresh hunspell hunspell-en_us ttf-caladea ttf-carlito ttf-dejavu ttf-liberation ttf-linux-libertine-g noto-fonts adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts libreoffice-extension-texmaths libreoffice-extension-writer2latex
        install_aur_packages ttf-gentium-basic hsqldb2-java libreoffice-extension-languagetool
        echo
        gum style --foreground 35 "##########  Done, Please Reboot !  ##########"
        sleep 3
        clear && exec "$0"
        ;;
      2)
        package_selection_dialog "Select Browser(s) to install:" \
        "Brave" "The web browser from Brave" OFF \
        "Firefox" "Fast, Private & Safe Web Browser" OFF \
        "Filezilla" "Fast and reliable FTP client" OFF \
        "Vivaldi" "Feature-packed web browser" OFF \
        "Mullvad" "Mass surveillance free browser" OFF \
        "Floorp" "A Firefox-based Browser" OFF \
        "LibreWolf" "LibreWolf Web Browser" OFF \
        "Chromium" "Ungoogled Chromium Browser" OFF \
        "Tor" "Tor Browser Bundle" OFF
        echo
        gum style --foreground 35 "##########  Done ! ##########"
        sleep 3
        clear && exec "$0"
        ;;
      3)
        gum style --foreground 35 "########## Installing Recommended Tools ##########"
        echo
        gum style --foreground 200 "Be patient while this installs the many recommended packages..."
        echo
        sleep 6
        install_aur_packages linux-headers downgrade mkinitcpio-firmware hw-probe pkgstats alsi update-grub expac linux-firmware-marvell eza numlockx lm_sensors appstream-glib bat bat-extras pacman-contrib pacman-bintrans yt-dlp gnustep-base parallel dex make libxinerama logrotate bash-completion gtk-update-icon-cache gnome-disk-utility appmenu-gtk-module dconf-editor dbus-python lsb-release asciinema playerctl s3fs-fuse vi duf gcc yad zip xdo inxi lzop nmon mkinitcpio-archiso mkinitcpio-nfs-utils tree vala btop lshw expac fuse3 meson unace unrar unzip p7zip rhash sshfs vnstat nodejs cronie hwinfo hardinfo2 arandr assimp netpbm wmctrl grsync libmtp polkit sysprof gparted hddtemp mlocate fuseiso gettext node-gyp graphviz inetutils appstream cifs-utils ntfs-3g nvme-cli exfatprogs f2fs-tools man-db man-pages tldr python-pip python-cffi python-numpy python-docopt python-pyaudio xdg-desktop-portal-gtk
        echo
        gum style --foreground 35 "##########  Done ! ##########"
        sleep 3
        clear && exec "$0"
        ;;
      4)
        package_selection_dialog "Select Development Apps to install:" \
        "neoVim" "Vim text editor" OFF \
        "Emacs" "An extensible & customizable text editor" OFF \
        "LazyGit" "Powerful terminal UI for git commands" OFF \
        "Hugo" "The fastest Static Site Generator" OFF \
        "Github" "GitHub Desktop application" OFF \
        "VSCodium" "Telemetry-less code editing" OFF \
        "Meld" "Visual diff and merge tool" OFF \
        "Zed" "Zed IDE by ATOM Devs" OFF \
        "Eclipse" "Java bytecode compiler" OFF \
        "IntelliJ" "IntelliJ IDEA IDE for Java" OFF
        echo
        gum style --foreground 35 "##########  Done ! ##########"
        sleep 3
        clear && exec "$0"
        ;;
      5)
        package_selection_dialog "Select Photography & 3D Apps to install:" \
        "GiMP" "GNU Image Manipulation Program" OFF \
        "Krita" "Edit and paint images" OFF \
        "Blender" "A 3D graphics creation suite" OFF \
        "GoDot" "Cross-platform 3D game engine" OFF \
        "Unreal" "Advanced 3D Game-Engine" OFF
        echo
        gum style --foreground 35 "##########  Done ! ##########"
        sleep 3
        clear && exec "$0"
        ;;
      6)
        package_selection_dialog "Select Music & Media Apps to install:" \
        "MPV" "An OpenSource media player" OFF \
        "Spotify" "Online music streaming service" OFF \
        "Tenacity" "Telemetry-less Audio editing" OFF \
        "Strawberry" "A music player for collectors" OFF \
        "Spotube" " An Open source Spotify client" OFF \
        "Cider" "An open source Apple Music client" OFF
        echo
        gum style --foreground 35 "##########  Done ! ##########"
        sleep 3
        clear && exec "$0"
        ;;
      7)
        package_selection_dialog "Select Social/Web Apps to install:" \
        "Vesktop" "Discord alternative with Wayland support" OFF \
        "Ferdium" "Organize many web-apps into one" OFF \
        "Telegram" "Official Telegram Desktop client" OFF \
        "Tokodon" "A Mastodon client for Plasma" OFF \
        "WhatsApp" "WhatsApp client called ZapZap" OFF \
        "Chatterino" "A Chat client for twitch.tv" OFF \
        "Element" "Matrix collaboration client" OFF \
        "SimpleX" "A private & encrypted messenger" OFF
        echo
        gum style --foreground 35 "##########  Done ! ##########"
        sleep 3
        clear && exec "$0"
        ;;
      8)
        package_selection_dialog "Select Virtualization System to install:" \
        "VirtManager" "Manage QEMU virtual machines" OFF \
        "VirtualBox" "Powerful x86 virtualization" OFF
        echo
        gum style --foreground 35 "########## Done! Please Reboot. ##########"
        sleep 3
        clear && exec "$0"
        ;;
      9)
        package_selection_dialog "Select App(s) to install (DaVinci-Resolve will take a while to compile, don't interrupt the process):" \
        "KDEnLive" "A non-linear video editor" OFF \
        "DaVinci" "Professional A/V post-production Soft" OFF \
        "OBS-Studio" "Includes many Plugins (Flatpak)" OFF \
        "Mystiq" "FFmpeg GUI front-end based on Qt5" OFF \
        "MKVToolNix" "Matroska files creator and tools" OFF \
        "MakeMKV" "DVD and Blu-ray to MKV converter" OFF \
        "Avidemux" "Graphical tool to edit video" OFF
        echo
        gum style --foreground 35 "##########  Done ! ##########"
        sleep 3
        clear && exec "$0"
        ;;
      q)
        clear && exec xero-cli -m
        ;;
      *)
        gum style --foreground 50 "Invalid choice. Please select a valid option."
        echo
        ;;
    esac
    sleep 3
  done
}

# Main execution
check_dependency gum
check_dependency dialog
display_header
display_options
process_choice
