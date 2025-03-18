# Update Everything
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

# Installing zsh
sudo apt-get install zsh -y

# Installing Oh My Zsh (Unattended mode)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Installing Powerlevel10k files
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# Installing plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sudo apt install ruby-full
sudo gem install colorls

sed -i 's/^plugins=.*/plugins=( git zsh-syntax-highlighting zsh-autosuggestions )/' ~/.zshrc

# Setting up powerlevel10k as ZSH main theme
sed -i 's|^ZSH_THEME=.*|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|' ~/.zshrc

cat <<END >> ~/.zshrc
alias update='sudo apt update && sudo apt upgrade && sudo apt autoremove'
alias rmdir='rm -rf'

# Adding colorls to ls
if [ -x "$(command -v colorls)" ]; then
    alias ls="colorls"
    alias la="colorls -al"
fi
END

chsh -s /bin/zsh
zsh

sed -i 's|typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique|typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last|' ~/.p10k.zsh


