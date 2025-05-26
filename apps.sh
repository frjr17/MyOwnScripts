#!/bin/bash

sudo ln -s /var/lib/snapd/snap /snap
#   VS Code
sudo snap install code --classic
#   Spotify
sudo snap install spotify
#   Google Chrome
sudo dnf install google-chrome-stable -Y
#   Telegram
sudo snap install telegram-desktop
#   Variety
sudo dnf install variety -y