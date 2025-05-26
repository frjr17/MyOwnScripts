#!/bin/bash
sudo chmod +x *.sh

BASE_DIR=$(pwd)
USER=$(whoami)


# Github Credentials
GITHUB_NAME="Hernán Valencia"
GITHUB_USERNAME="frjr17"
GITHUB_EMAIL="hernanadrianv17@gmail.com"

# Install Development softwares
cd $BASE_DIR
./softwares.sh

# Installing snapper for automatic backups
./snapper.sh

# MacOS Theme

WHITESUR_DIR='/tmp/WhiteSur_Installer'
git clone https://github.com/frjr17/WhiteSur_Installer.git $WHITESUR_DIR

cd $WHITESUR_DIR
sudo chmod +x *.sh

# Note: This is because whitesur needs firefox process open once and closed
firefox &
sleep 10
pkill -9 firefox

./install.sh

pipx ensurepath
source ~/.bashrc
pipx install gnome-extensions-cli --system-site-packages

gnome-extensions-cli install hidetopbar@mathieu.bidon.ca 
gnome-extensions-cli install dash2dock-lite@icedman.github.com 

#Setup git config global
git config --global user.name $GITHUB_NAME
git config --global user.username $GITHUB_USERNAME
git config --global user.email $GITHUB_EMAIL

# A new ssh-key for using in github clone access
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""

#   Dev fonts
cd $BASE_DIR/fonts
unzip FiraCodeNF.zip
unzip OperatorMonoLig.zip

sudo mv *.ttf /usr/share/fonts # Fira Code 
sudo mv *.otf /usr/share/fonts # Operator Mono


# Install powerlevel10k theme for terminal
cd $BASE_DIR
./favoriteShell.sh

# UI apps 
cd $BASE_DIR
./apps.sh

#Cleaning Up
cd $BASE_DIR
sudo rm -rf $WHITESUR_DIR
sudo rm -rf ~/.frjr17Scripts
