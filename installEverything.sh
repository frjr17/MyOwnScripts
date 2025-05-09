#!/bin/bash
BASE_DIR=pwd
USER=whoami

# Github Credentials
GITHUB_NAME="Hernán Valencia"
GITHUB_USERNAME="frjr17"
GITHUB_EMAIL="hernanadrianv17@gmail.com"

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

ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""

#   Dev fonts
cd $BASE_DIR/fonts
unzip FiraCodeNF.zip
unzip OperatorMono.zip

mv *.ttf /usr/share/fonts # Fira Code 
mv *.otf /usr/share/fonts # Operator Mono

# Install powerlevel10k theme for terminal
sudo dnf install zsh curl -y

sudo dnf install ruby -y
sudo dnf install rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} ruby-bundled-gems -y
sudo dnf install make automake gcc gcc-c++ kernel-devel -y
sudo gem install colorls
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Common aliases
cd
echo "alias update=sudo dnf update && sudo dnf upgrade && sudo dnf autoremove" >> .zshrc
echo "alias rmdir=rm -rf" >> .zshrc
echo "alias open=xdg-open" >> .zshrc
echo "alias python=python3" >> .zshrc
echo "alias venv_activate=source ./venv/bin/activate" >> .zshrc
echo "alias create_venv=python -m venv venv && venv_activate" >> .zshrc

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

# Install Development softwares

#   Node.js (NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install --lts

#   Python
sudo dnf install python3-pip -y

#   Go
sudo dnf install golang -y 
mkdir -p $HOME/go
echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
source $HOME/.bashrc

#   Java 21 
sudo dnf install java-21-openjdk -y

#   Vim
sudo dnf install vim-enhanced -y


#Cleaning Up
cd 
sudo rm -rf $WHITESUR_DIR
sudo rm -rf ~/.frjr17Scripts
