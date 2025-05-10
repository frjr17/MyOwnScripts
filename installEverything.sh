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

# Installing snapper for automatic backups
sudo dnf install snapper libdnf5-plugin-actions btrfs-assistant inotify-tools git make

sudo bash -c "cat > /etc/dnf/libdnf5-plugins/actions.d/snapper.actions" <<'EOF'
# Get snapshot description
pre_transaction::::/usr/bin/sh -c echo\ "tmp.cmd=$(ps\ -o\ command\ --no-headers\ -p\ '${pid}')"

# Creates pre snapshot before the transaction and stores the snapshot number in the "tmp.snapper_pre_number"  variable.
pre_transaction::::/usr/bin/sh -c echo\ "tmp.snapper_pre_number=$(snapper\ create\ -t\ pre\ -c\ number\ -p\ -d\ '${tmp.cmd}')"

# If the variable "tmp.snapper_pre_number" exists, it creates post snapshot after the transaction and removes the variable "tmp.snapper_pre_number".
post_transaction::::/usr/bin/sh -c [\ -n\ "${tmp.snapper_pre_number}"\ ]\ &&\ snapper\ create\ -t\ post\ --pre-number\ "${tmp.snapper_pre_number}"\ -c\ number\ -d\ "${tmp.cmd}"\ ;\ echo\ tmp.snapper_pre_number\ ;\ echo\ tmp.cmd
EOF

sudo snapper -c root create-config /
sudo snapper -c home create-config /home

sudo restorecon -RFv /.snapshots
sudo restorecon -RFv /home/.snapshots

sudo snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes
sudo snapper -c home set-config ALLOW_USERS=$USER SYNC_ACL=yes

echo 'PRUNENAMES = ".snapshots"' | sudo tee -a /etc/updatedb.conf

# Installing grub-btrfs
cd /tmp 
git clone https://github.com/Antynea/grub-btrfs
cd grub-btrfs

sed -i.bkp \
  -e '/^#GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS=/a \
GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS="rd.live.overlay.overlayfs=1"' \
  -e '/^#GRUB_BTRFS_GRUB_DIRNAME=/a \
GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"' \
  -e '/^#GRUB_BTRFS_MKCONFIG=/a \
GRUB_BTRFS_MKCONFIG=/usr/bin/grub2-mkconfig' \
  -e '/^#GRUB_BTRFS_SCRIPT_CHECK=/a \
GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check' \
  config

sudo make install
sudo systemctl enable --now grub-btrfsd.service

cd ..
rm -rfv grub-btrfs

# Enabling automatic snapshots
sudo snapper -c home set-config TIMELINE_CREATE=no
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

#Cleaning Up
cd 
sudo rm -rf $WHITESUR_DIR
sudo rm -rf ~/.frjr17Scripts
