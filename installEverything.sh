#!/bin/bash
BASE_DIR=pwd
USER=whoami

# Github Credentials
GITHUB_NAME="Hernán Valencia"
GITHUB_USERNAME="frjr17"
GITHUB_EMAIL="hernanadrianv17@gmail.com"

# Install Development softwares
./softwares.sh

# Installing snapper for automatic backups
./snapper.sh

# MacOS Theme
WHITESUR_DIR='/tmp/WhiteSur_Installer'
git clone https://github.com/frjr17/WhiteSur_Installer.git $WHITESUR_DIR

cd $WHITESUR_DIR
sudo chmod +x *.sh

./install.sh

#Setup git config global
git config --global user.name $GITHUB_NAME
git config --global user.username $GITHUB_USERNAME
git config --global user.email $GITHUB_EMAIL

# A new ssh-key for using in github clone access
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""

#   Dev fonts
cd $BASE_DIR/fonts
unzip FiraCodeNF.zip
unzip OperatorMono.zip

mv *.ttf /usr/share/fonts # Fira Code 
mv *.otf /usr/share/fonts # Operator Mono

# Install powerlevel10k theme for terminal
./favoriteShell.sh

# UI apps 
sudo ln -s /var/lib/snapd/snap /snap
#   VS Code
sudo snap install code --classic
#   Spotify
sudo snap install spotify
#   Google Chrome
sudo snap install google-chrome
#   Telegram
sudo snap install telegram-desktop
#   Variety
sudo dnf install variety

#Cleaning Up
cd 
sudo rm -rf $WHITESUR_DIR
sudo rm -rf ~/.frjr17Scripts
