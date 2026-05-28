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
  is_installed_debian_package ncurses-bin || install_debian_package ncurses-bin
  is_installed_debian_package eza || install_debian_package eza
  is_installed_debian_package bat || install_debian_package bat
fi

cp vimrc "$HOME/.vimrc"
cp bash_aliases "$HOME/.bash_aliases"
cp profile.batcat "$HOME/.profile.batcat"
cp bash_prompt "$HOME/.bash_prompt"


LOAD_PROFILE_BATCAT='. "$HOME/.profile.batcat"'
grep -q "^$LOAD_PROFILE_BATCAT" ~/.profile || echo "$LOAD_PROFILE_BATCAT" >> ~/.profile

LOAD_BASH_PROMPT='. "$HOME/.bash_prompt"'
grep -q "^$LOAD_BASH_PROMPT" ~/.profile || echo "$LOAD_BASH_PROMPT" >> ~/.profile

echo "INFO: Updated files"
ls -ltr $HOME/{.vimrc,.bash_aliases,.profile,.profile.batcat,.bash_prompt}

echo -e "\nNOTE: A Nerdfont must be selected your Terminal app (to render font icons in your desktop)"
echo -e "\nPlease logoff or run: source ~/.profile"
