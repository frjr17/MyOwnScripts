#!/bin/bash

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
