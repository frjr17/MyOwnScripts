#!/bin/bash

sudo dnf update -y && sudo dnf upgrade -y && sudo dnf autoremove -y

./snapper.sh
./favoriteShell.sh
./softwares.sh
./apps.sh
./ui.sh