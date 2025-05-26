#!/bin/bash

USER=$(whoami)

sudo dnf install zsh curl -y
sudo dnf install ruby ruby-devel -y
sudo dnf install rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} ruby-bundled-gems -y
sudo dnf install make automake gcc gcc-c++ kernel-devel -y
sudo gem install colorls


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

sed -i 's/^plugins=.*/plugins=( git zsh-syntax-highlighting zsh-autosuggestions )/' ~/.zshrc
sed -i 's|^ZSH_THEME=.*|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|' ~/.zshrc

cat <<END >> ~/.zshrc

# Adding colorls to ls
if [ -x "$(command -v colorls)" ]; then
    alias ls="colorls"
    alias la="colorls -al"
fi
END

sed -i 's|typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique|typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last|' ~/.p10k.zsh

# Setting up default shell to zsh
sudo chsh -s $(which zsh) $USER

# Common aliases
cd
echo "alias update='sudo dnf update && sudo dnf upgrade && sudo dnf autoremove'" >> .zshrc
echo "alias rmdir='rm -rf'" >> .zshrc
echo "alias open='xdg-open'" >> .zshrc
echo "alias python='python3'" >> .zshrc
echo "alias venv_activate='source ./venv/bin/activate'" >> .zshrc
echo "alias create_venv='python -m venv venv && venv_activate'" >> .zshrc
