# ¡IMPORTANT NOTE! This script only works for Ubuntu or debian based distros. 
# Step 1.) Update Everything
echo '################################################'
echo 'Updating Everything'
echo '################################################'
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

# Step 2.) Installing zsh
echo '################################################'
echo 'Installing ZSH'
echo '################################################'
sudo apt-get install zsh -y

# Step 3.) Installing Oh My Zsh (Unattended mode)
echo '################################################'
echo 'Installing Oh my ZSH in unattended mode'
echo '################################################'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Step 4.) Installing Powerlevel10k files, but not initiating anything
echo '################################################'
echo 'Installing Powerlevel10k files'
echo '################################################'
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# Step 5.) Installing plugins
echo '################################################'
echo 'Installing Powerlevel10k plugins'
echo '################################################'

# ------- ZSH syntax highlighting 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# ------- ZSH syntax autosuggestions 
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# ------- colorls 
sudo apt install ruby-full -y
sudo gem install colorls -f
# ------- Adding plugins to .zshrc file 
sed -i 's/^plugins=.*/plugins=( git zsh-syntax-highlighting zsh-autosuggestions )/' ~/.zshrc

# Step 6.) Setting up powerlevel10k as ZSH main theme
echo '################################################'
echo 'Setting up Powerlevel 10k as ZSH main theme'
echo '################################################'
sed -i 's|^ZSH_THEME=.*|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|' ~/.zshrc

# Step 7.) Adding custom aliases and colorls to ZSH
cat <<END >> ~/.zshrc
alias update='sudo apt update && sudo apt upgrade && sudo apt autoremove'
alias rmdir='rm -rf'

# Adding colorls to ls
if [ -x "$(command -v colorls)" ]; then
    alias ls="colorls"
    alias la="colorls -al"
fi
END

# Step 8.) Setting up ZSH as default shell (password required) 
echo '################################################'
echo 'Setting up ZSH as default shell'
echo '################################################'
sudo sed -i "s|^$USER:.*:$SHELL|$USER:x:$(id -u):$(id -g)::$HOME:/bin/zsh|" /etc/passwd


# Step 9.) Changing powerlevel10k shorten strategy to truncate_to_last 
echo '################################################'
echo 'Changing powerlevel10k shorten strategy to truncate_to_last'
echo '################################################'
sed -i 's|typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique|typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last|' ~/.p10k.zsh