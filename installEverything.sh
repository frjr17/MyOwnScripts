#!/bin/bash
BASE_DIR=pwd

# MacOS Theme
WHITESUR_DIR='/tmp/WhiteSur_Installer'
git clone https://github.com/frjr17/WhiteSur_Installer.git $WHITESUR_DIR

cd $WHITESUR_DIR
sudo chmod +x *.sh
sudo pkill -9 firefox

./install.sh

#Setup git config global
git config --global user.name "Hernán Valencia"
git config --global user.username frjr17
git config --global user.email hernanadrianv17@gmail.com

ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""



#   Dev fonts
cd $BASE_DIR/fonts
unzip FiraCodeNF.zip
unzip OperatorMono.zip

mv *.ttf /usr/share/fonts # Fira Code 
mv *.otf /usr/share/fonts # Operator Mono

# Install powerlevel10k theme for terminal
sudo dnf install zsh curl -y

sudo dnf install ruby 
sudo dnf install rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} ruby-bundled-gems
sudo dnf install make automake gcc gcc-c++ kernel-devel
sudo gem install colorls

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#   Common aliases



# UI apps 
#   VS Code
#   Spotify
#   Notion
#   Notion Calendar
#   Google Chrome
#   Telegram
#   Variety
#   Whatsapp


# Install Development softwares
#   Node.js (NVM)
#   Python
#   Go
#   Java
#   Vim

