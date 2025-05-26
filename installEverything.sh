#!/bin/bash
sudo chmod +x *.sh

BASE_DIR=$(pwd)
USER=$(whoami)

# Github Credentials
GITHUB_NAME="Hernán Valencia"
GITHUB_USERNAME="frjr17"
GITHUB_EMAIL="hernanadrianv17@gmail.com"

# Install Development softwares
cd $BASEDIR
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

sudo mv *.ttf /usr/share/fonts # Fira Code 
sudo mv *.otf /usr/share/fonts # Operator Mono


# Install powerlevel10k theme for terminal
cd $BASEDIR
./favoriteShell.sh

# UI apps 
cd $BASEDIR
./apps.sh

#Cleaning Up
cd $BASEDIR
sudo rm -rf $WHITESUR_DIR
sudo rm -rf ~/.frjr17Scripts
