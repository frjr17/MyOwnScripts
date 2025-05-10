
#!/bin/bash

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