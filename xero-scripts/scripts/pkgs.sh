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
echo "Hello $USER, this will install extra packages, some require Xero Repo & multilib."
echo
echo "################# Various Extra Pkgs #################"
echo
echo "a. LibreOffice."
echo "s. System Tools."
echo "p. Photography Tools."
echo "m. Music/Media Tools."
echo "w. Social-Media Tools."
echo "v. Virtualization Tools."
echo
echo "################### OBS / KDEnLive ###################"
echo
echo "k. Install KDEnLive Video Editor."
echo "o. Install OBS-Studio + Plugins (Flathub)."
echo "l. Activate v4l2loopback for OBS-VirtualCam."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    a )
      echo
      sleep 2
      sudo pacman -S --noconfirm libreoffice-fresh hunspell hunspell-en_us ttf-caladea ttf-carlito ttf-dejavu ttf-liberation ttf-linux-libertine-g noto-fonts adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts libreoffice-extension-texmaths libreoffice-extension-writer2latex
      sleep 2
      echo
      $AUR_HELPER -S --noconfirm ttf-gentium-basic hsqldb2-java libreoffice-extension-languagetool
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
      $AUR_HELPER -S --noconfirm downgrade yt-dlg mkinitcpio-firmware hw-probe pkgstats alsi update-grub rate-mirrors-bin ocs-url expac linux-headers linux-firmware-marvell eza numlockx lm_sensors appstream-glib bat bat-extras pacman-contrib pacman-bintrans pacman-mirrorlist yt-dlp gnustep-base parallel dex make libxinerama logrotate bash-completion gtk-update-icon-cache gnome-disk-utility appmenu-gtk-module dconf-editor dbus-python lsb-release asciinema playerctl s3fs-fuse vi duf gcc yad zip xdo inxi meld lzop nmon mkinitcpio-archiso mkinitcpio-nfs-utils tree vala btop lshw expac fuse3 meson unace unrar unzip p7zip rhash sshfs vnstat nodejs cronie hwinfo arandr assimp netpbm wmctrl grsync libmtp polkit sysprof gparted hddtemp mlocate fuseiso gettext node-gyp graphviz inetutils appstream cifs-utils ntfs-3g nvme-cli exfatprogs f2fs-tools man-db man-pages tldr python-pip python-cffi python-numpy python-docopt python-pyaudio xdg-desktop-portal-gtk
      sleep 3
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
            clear && sh $0
      ;;
    
    p )
      echo
      echo "#################################################"
      echo "#               Photography Tools               #"
      echo "#################################################"
      echo
      echo "Select What you want to install"
      echo
      select pt in "GiMP" "Krita" "Back"; do case $pt in GiMP) sudo pacman -S --noconfirm gimp && break ;; Krita) sudo pacman -S --noconfirm krita && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, or 3." ;; esac done
      echo
      echo "#################################"
      echo "              Done !             "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    m )
      echo
      echo "#################################################"
      echo "#               Music/Media Tools               #"
      echo "#################################################"
      echo
      echo "Select What you want to install"
      echo
      select mt in "MPV" "Spotify" "Strawberry" "Back"; do case $mt in MPV) sudo pacman -S --noconfirm mpv mpv-mpris && break ;; Spotify) flatpak install com.spotify.Client && break ;; Strawberry) flatpak install org.strawberrymusicplayer.strawberry && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, 3 or 4." ;; esac done
      echo
      echo "#################################"
      echo "              Done !             "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    w )
      echo
      echo "#################################################"
      echo "#              Social-Media Tools               #"
      echo "#################################################"
      echo
      echo "Select What you want to install"
      echo
      select sm in "Discord" "Ferdium" "WebCord" "Tokodon" "Back"; do case $sm in Discord) flatpak install com.discordapp.Discord && break ;; Ferdium) flatpak install org.ferdium.Ferdium && break ;; WebCord) $AUR_HELPER -S --noconfirm webcord-bin && break ;; Tokodon) flatpak install org.kde.tokodon && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, 3, 4 or 5." ;; esac done
      echo
      echo "#################################"
      echo "              Done !             "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    v )
      echo
      echo "#################################################"
      echo "#              Virtualization Tools             #"
      echo "#################################################"
      echo
      echo "Select Preferred VM Tool"
      echo
      select vm in "VirtualBox" "VirtManager" "Back"; do case $vm in VirtualBox) sudo pacman -S --noconfirm virtualbox-meta && break ;; VirtManager) sudo pacman -Rdd --noconfirm iptables && sudo pacman -S --noconfirm virt-manager-meta && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, or 3." ;; esac done
      echo
      echo "#################################"
      echo "              Done !             "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    k )
      echo
      echo "#################################################"
      echo "#           Installing KDEnLive Editor          #"
      echo "#################################################"
      echo
      echo "Native or Flatpak ?"
      echo
      select kdenlive in "Native" "Flatpak" "Back"; do case $kdenlive in Native) sudo pacman -S --noconfirm kdenlive && break ;; Flatpak) flatpak install org.kde.kdenlive && break ;; Back) clear && sh $0 && break ;; *) echo "Invalid option. Please select 1, 2, or 3." ;; esac done
      sleep 2
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
      flatpak install com.obsproject.Studio com.obsproject.Studio.Plugin.OBSVkCapture com.obsproject.Studio.Plugin.Gstreamer com.obsproject.Studio.Plugin.TransitionTable  com.obsproject.Studio.Plugin.waveform com.obsproject.Studio.Plugin.InputOverlay com.obsproject.Studio.Plugin.SceneSwitcher com.obsproject.Studio.Plugin.MoveTransition com.obsproject.Studio.Plugin.ScaleToSound com.obsproject.Studio.Plugin.WebSocket com.obsproject.Studio.Plugin.DroidCam com.obsproject.Studio.Plugin.BackgroundRemoval com.obsproject.Studio.Plugin.GStreamerVaapi com.obsproject.Studio.Plugin.VerticalCanvas org.freedesktop.Platform.VulkanLayer.OBSVkCapture
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
      sudo pacman -S --noconfirm v4l2loopback-dkms
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
