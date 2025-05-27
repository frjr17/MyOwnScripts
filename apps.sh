#!/bin/bash
sudo dnf install snapd -y
sudo ln -s /var/lib/snapd/snap /snap

#   Spotify
sudo snap install spotify
#   Google Chrome
sudo dnf install google-chrome-stable -y
#   Telegram
sudo snap install telegram-desktop
#   Variety
sudo dnf install variety -y
#   VS Code
sudo snap install code --classic
