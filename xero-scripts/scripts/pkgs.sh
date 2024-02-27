#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
clear
tput setaf 5
echo "###################################################################################"
echo "#                             Essential Pkg Installer                             #"
echo "###################################################################################"
tput sgr0
echo
echo "Hello $USER, this will install extra packages. Press i for the Wiki."
echo
echo "################# Various Extra Pkgs #################"
echo
echo "a. LibreOffice."
echo "s. System Tools."
echo "d. Development Tools."
echo "p. Photo and 3D Tools."
echo "m. Music & Audio Tools."
echo "w. Social & Chat Tools."
echo "v. Virtualization Tools."
echo "k. Video Tools & Software."
echo
echo "####################### Extras #######################"
echo
echo "l. Activate v4l2loopback for OBS-VirtualCam."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    i )
      echo
      sleep 2
      xdg-open "https://github.com/xerolinux/xlapit-cli/wiki/Toolkit-Features"  > /dev/null 2>&1
      echo
      clear && sh $0
      ;;

    a )
      echo
      sleep 2
      sudo pacman -S --noconfirm --needed libreoffice-fresh hunspell hunspell-en_us ttf-caladea ttf-carlito ttf-dejavu ttf-liberation ttf-linux-libertine-g noto-fonts adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts libreoffice-extension-texmaths libreoffice-extension-writer2latex
      sleep 2
      echo
      $AUR_HELPER -S --noconfirm --needed ttf-gentium-basic hsqldb2-java libreoffice-extension-languagetool
      echo
      echo "#################################"
      echo "        Done, Plz Reboot !       "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    s )
      echo
      echo "##########################################"
      echo "       Installing Recommended tools       "
      echo "##########################################"
      echo
      echo "Please wait while packages install might take a while... "
      echo
      $AUR_HELPER -S --noconfirm --needed downgrade yt-dlg mkinitcpio-firmware hw-probe pkgstats alsi update-grub rate-mirrors-bin ocs-url expac linux-headers linux-firmware-marvell eza numlockx lm_sensors appstream-glib bat bat-extras pacman-contrib pacman-bintrans pacman-mirrorlist yt-dlp gnustep-base parallel dex make libxinerama logrotate bash-completion gtk-update-icon-cache gnome-disk-utility appmenu-gtk-module dconf-editor dbus-python lsb-release asciinema playerctl s3fs-fuse vi duf gcc yad zip xdo inxi lzop nmon mkinitcpio-archiso mkinitcpio-nfs-utils tree vala btop lshw expac fuse3 meson unace unrar unzip p7zip rhash sshfs vnstat nodejs cronie hwinfo arandr assimp netpbm wmctrl grsync libmtp polkit sysprof gparted hddtemp mlocate fuseiso gettext node-gyp graphviz inetutils appstream cifs-utils ntfs-3g nvme-cli exfatprogs f2fs-tools man-db man-pages tldr python-pip python-cffi python-numpy python-docopt python-pyaudio xdg-desktop-portal-gtk
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      sleep 3
      clear && sh $0
      ;;
    
    d )
      echo
      # Function to install packages using pacman
      install_pacman_packages() {
          sudo pacman -S --noconfirm --needed $@
      }

      # Function to install packages using AUR Helper
      install_aur_packages() {
          $AUR_HELPER -S --noconfirm --needed $@
      }

      # Function to install flatpak packages
      install_flatpak_packages() {
          flatpak install -y $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select Development Apps to install:" 20 60 7 \
          "neoVim" "Vim text editor" OFF \
          "Github" "GitHub Desktop application" OFF \
          "VSCodium" "Telemetry-less code editing" OFF \
          "Meld" "Visual diff and merge tool" OFF \
          "Zettlr" "Markdown editor" OFF \
          "Eclipse" "Java bytecode compiler" OFF \
          "IntelliJ" "IntelliJ IDEA IDE for Java" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      neoVim)
                          install_pacman_packages neovim neovim-lsp_signature neovim-lspconfig neovim-nvim-treesitter
                          ;;
                      Github)
                          install_flatpak_packages io.github.shiftey.Desktop
                          ;;
                      VSCodium)
                          install_aur_packages vscodium-bin vscodium-bin-marketplace vscodium-bin-features
                          ;;
                      Meld)
                          install_pacman_packages meld
                          ;;
                      Zettlr)
                          install_flatpak_packages com.zettlr.Zettlr
                          ;;
                      Eclipse)
                          install_flatpak_packages org.eclipse.Java
                          ;;
                      IntelliJ)
                          install_flatpak_packages com.jetbrains.IntelliJ-IDEA-Community
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

    p )
      echo
      # Function to install packages using pacman
      install_pacman_packages() {
          sudo pacman -S --noconfirm --needed $@
      }

      # Function to install packages using AUR Helper
      install_aur_packages() {
          $AUR_HELPER -S --noconfirm --needed $@
      }

      # Function to install flatpak packages
      install_flatpak_packages() {
          flatpak install -y $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select Photography & 3D Apps to install :" 20 60 7 \
          "GiMP" "GNU Image Manipulation Program" OFF \
          "Krita" "Edit and paint images" OFF \
          "Blender" "A 3D graphics creation suite" OFF \
          "GoDot" "Cross-platform 3D game engine" OFF \
          "Unreal" "Advanced 3D Game-Engine" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      GiMP)
                          install_pacman_packages gimp
                          ;;
                      Krita)
                          install_flatpak_packages flathub org.kde.krita
                          ;;
                      Blender)
                          install_pacman_packages blender
                          ;;
                      GoDot)
                          install_pacman_packages godot
                          ;;
                      Unreal)
                          install_aur_packages unreal-engine-bin
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

    m )
      echo
      # Function to install packages using pacman
      install_pacman_packages() {
          sudo pacman -S --noconfirm --needed $@
      }

      # Function to install flatpak packages
      install_flatpak_packages() {
          flatpak install -y $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select Music & Media Apps to install:" 20 60 7 \
          "MPV" "An OpenSource media player" OFF \
          "Spotify" "Online music streaming service" OFF \
          "Tenacity" "Telemetry-less Audio editing" OFF \
          "Strawberry" "A music player for collectors" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      MPV)
                          install_pacman_packages mpv mpv-mpris
                          ;;
                      Spotify)
                          install_flatpak_packages com.spotify.Client
                          ;;
                      Tenacity)
                          install_flatpak_packages org.tenacityaudio.Tenacity
                          ;;
                      Strawberry)
                          install_flatpak_packages org.strawberrymusicplayer.strawberry
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

    w )
      echo
      # Function to install packages using pacman
      install_pacman_packages() {
          sudo pacman -S --noconfirm --needed $@
      }

      # Function to install packages using AUR Helper
      install_aur_packages() {
          $AUR_HELPER -S --noconfirm --needed $@
      }

      # Function to install flatpak packages
      install_flatpak_packages() {
          flatpak install -y $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select Social/Web Apps to install:" 20 60 7 \
          "Discord" "All-in-one IM for gamers" OFF \
          "Ferdium" "Organize many apps into one" OFF \
          "WebCord" "Customizable Discord Fork" OFF \
          "Tokodon" "A Mastodon client for Plasma" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      Discord)
                          install_flatpak_packages com.discordapp.Discord
                          ;;
                      Ferdium)
                          install_flatpak_packages org.ferdium.Ferdium
                          ;;
                      WebCord)
                          install_aur_packages webcord-bin
                          ;;
                      Tokodon)
                          install_flatpak_packages org.kde.tokodon
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

    v )
      echo
      # Function to install packages using pacman
      install_pacman_packages() {
          sudo pacman -S --noconfirm --needed $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select Virtualization System to install :" 20 60 7 \
          "VirtManager" "Manage QEMU virtual machines" OFF \
          "VirtualBox" "Powerful x86 virtualization" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      VirtManager)
                          sudo pacman -Rdd --noconfirm iptables \
                          && install_pacman_packages virt-manager-meta
                          ;;
                      VirtualBox)
                          install_pacman_packages virtualbox-meta
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

    k )
      echo
      # Function to install packages using pacman
      install_pacman_packages() {
          sudo pacman -S --noconfirm --needed $@
      }

      # Function to install flatpak packages
      install_flatpak_packages() {
          flatpak install -y $@
      }

      # Function to install packages using AUR Helper
      install_aur_packages() {
          $AUR_HELPER -S --noconfirm --needed $@
      }

      # Function to display package selection dialog
      package_selection_dialog() {
          PACKAGES=$(whiptail --checklist --separate-output "Select App(s) to install (DaVinci-Reslove will take a while to compile, don't interrupt the process) :" 20 60 7 \
          "KDEnLive" "A non-linear video editor" OFF \
          "DaVinci" "Professional A/V post-production Soft" OFF \
          "OBS-Studio" "Includes many Plugins (Flatpak)" OFF \
          "Mystiq" "FFmpeg GUI front-end based on Qt5" OFF \
          "MKVToolNix" "Matroska files creator and tools" OFF \
          "MakeMKV" "DVD and Blu-ray to MKV converter" OFF \
          "Avidemux" "Graphical tool to edit video" OFF 3>&1 1>&2 2>&3)

          # Check if user has selected any packages
          if [ -n "$PACKAGES" ]; then
              for PACKAGE in $PACKAGES; do
                  case $PACKAGE in
                      KDEnLive)
                          install_pacman_packages kdenlive
                          ;;
                      DaVinci)
                          install_aur_packages davinci-resolve
                          ;;
                      OBS-Studio)
                          install_flatpak_packages com.obsproject.Studio com.obsproject.Studio.Plugin.OBSVkCapture com.obsproject.Studio.Plugin.Gstreamer com.obsproject.Studio.Plugin.TransitionTable com.obsproject.Studio.Plugin.waveform com.obsproject.Studio.Plugin.InputOverlay com.obsproject.Studio.Plugin.SceneSwitcher com.obsproject.Studio.Plugin.MoveTransition com.obsproject.Studio.Plugin.ScaleToSound com.obsproject.Studio.Plugin.WebSocket com.obsproject.Studio.Plugin.DroidCam com.obsproject.Studio.Plugin.BackgroundRemoval com.obsproject.Studio.Plugin.GStreamerVaapi com.obsproject.Studio.Plugin.VerticalCanvas org.freedesktop.Platform.VulkanLayer.OBSVkCapture com.obsproject.Studio.Plugin.NDI com.obsproject.Studio.Plugin.Ocr
                          ;;
                      Mystiq)
                          install_aur_packages mystiq
                          ;;
                      MKVToolNix)
                          install_pacman_packages mkvtoolnix-gui
                          ;;
                      MakeMKV)
                          install_flatpak_packages com.makemkv.MakeMKV
                          ;;
                      Avidemux)
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

      # Call the package selection dialog function
      package_selection_dialog
      echo
      echo "#################################"
      echo "              Done !             "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    o )
      echo
      echo "###########################################"
      echo "           Installing OBS-Studio           "
      echo "###########################################"
      sleep 3
      flatpak install
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      clear && sh $0
      ;;

    l )
      echo
      echo "##########################################"
      echo "          Setting up v4l2loopback         "
      echo "##########################################"
      sleep 3
      sudo pacman -S --noconfirm --needed v4l2loopback-dkms
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
