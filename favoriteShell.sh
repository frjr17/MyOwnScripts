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

# Step 6.) Adding custom .zshrc file
rm ~/.zshrc
cp .zshrc ~

# Step 8.) Setting up ZSH as default shell (password required) 
echo '################################################'
echo 'Setting up ZSH as default shell'
echo '################################################'
sudo sed -i "s|^$USER:.*:$SHELL|$USER:x:$(id -u):$(id -g)::$HOME:/bin/zsh|" /etc/passwd


# Step 9.) Copying powerlevel10k config to user folder
cp .p10k.zsh ~
