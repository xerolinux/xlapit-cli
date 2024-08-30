#!/usr/bin/env bash

rerun_script=0

if command -v figlet; then
  m_figlet="Invalid distro! Only Arch (vanilla) and XeroLinux are supported!"

  if [[ "$SECRET_FEATURE" == "1" ]]; then
    m_figlet="Arg! Yee is not an Arch user! Nor are yee a XeroLinux user, scallywag!"
  fi

  echo "$m_figlet" | figlet -f big
else
  is_arch=0

  if grep "ID_LIKE=" /etc/os-release > /dev/null 2>&1; then
    id_like="$(cat /etc/os-release | grep 'ID_LIKE=' | sed 's/ID_LIKE=//' | sed 's/"//g')"

    if [[ "$id_like" == "arch" ]]; then
      is_arch=1
    fi
  fi

  if [[ "$is_arch" == "1" ]]; then
    echo "Figlet not found! Would you like to install it?"
    [[ "$SECRET_FEATURE" == "1" ]] && echo "Even if it is for this one dumb little script... 🙄"

    read -p "[y/n]: " answer

    if [[ "$answer" == 'y' ]]; then
      sudo pacman --noconfirm -S figlet && echo "Done! Re-running script..."
      rerun_script=1
      $0
    elif [[ "$answer" == 'n' ]]; then
      [[ "$SECRET_FEATURE" == "1" ]] && echo "Good choice! You and me buddy! - OgloTheNerd"
    else
      echo "Invalid answer... assuming 'n'..."
      [[ "$SECRET_FEATURE" == "1" ]] && echo "How did you mess this up?"
    fi
  else
    echo "Figlet not found!"
    [[ "$SECRET_FEATURE" == "1" ]] && echo "Oh hi non-Arch user! It is a bit strange that you are running this, but Arch sucks. I salute you! - OgloTheNerd"
  fi
fi

if [[ "$rerun_script" == "0" ]]; then
  echo " "
  read -p "Press ENTER to quit... "
fi
