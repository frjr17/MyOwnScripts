# Step 1.) Update Everything
echo '\n################################################'
echo 'Updating Everything'
echo '################################################\n'
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

# Step 2.) Installing zsh
echo '\n################################################'
echo 'Installing ZSH'
echo '################################################\n'
sudo apt-get install zsh -y

# Step 3.) Installing Oh My Zsh (Unattended mode)
echo '\n################################################'
echo 'Installing Oh my ZSH in unattended mode'
echo '################################################\n'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Step 4.) Installing Powerlevel10k files, but not initiating anything
echo '\n################################################'
echo 'Installing Powerlevel10k files'
echo '################################################\n'
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# Step 5.) Installing plugins
echo '\n################################################'
echo 'Installing Powerlevel10k plugins'
echo '################################################\n'
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sudo apt install ruby-full
sudo gem install colorls

# ------- Adding plugins to .zshrc file 
sed -i 's/^plugins=.*/plugins=( git zsh-syntax-highlighting zsh-autosuggestions )/' ~/.zshrc

# Step 6.) Setting up powerlevel10k as ZSH main theme
echo '\n################################################'
echo 'Setting up Powerlevel 10k as ZSH main theme'
echo '################################################\n'
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
echo '\n################################################'
echo 'Setting up ZSH as default shell'
echo '################################################\n'
echo 'Please enter your password below'
chsh -s /bin/zsh
zsh


# Step 9.) Changing powerlevel10k shorten strategy to truncate_to_last 
echo '\n################################################'
echo 'Changing powerlevel10k shorten strategy to truncate_to_last'
echo '################################################\n'
sed -i 's|typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique|typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last|' ~/.p10k.zsh

# Done
exit

