#!/bin/bash

is_installed_debian_package()
{
  package=$1
  return $(dpkg -l $package &> /dev/null)
}

install_debian_package()
{ 
  package=$1
  echo "INFO: Installing package '${package}'"
  sudo apt install -y $package
}


## Main

if [ -f /etc/debian_version ]; then
  is_installed_debian_package eza || install_package eza
  is_installed_debian_package bat || install_package bat
fi

cp vimrc "$HOME/.vimrc"
cp bash_aliases "$HOME/.bash_aliases"
cp profile_themes "$HOME/.profile_themes"


LOAD_PROFILE_THEMES='. "$HOME/.profile_themes"'
grep -q "^$LOAD_PROFILE_THEMES" ~/.profile || echo "$LOAD_PROFILE_THEMES" >> ~/.profile

echo "INFO: Updated files"
ls -ltr $HOME/{.vimrc,.bash_aliases,.profile,.profile_themes}

echo -e "\nNOTE: A Nerdfont must be selected your Terminal app (to render font icons in your desktop)"
