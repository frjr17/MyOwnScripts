#!/bin/bash

set -euo pipefail


# ─────────────────────────────────────────────
# Define Dev Setup Script
# ─────────────────────────────────────────────

echo "📥 Updating container packages..."
sudo dnf update -y

# ───────────── ZSH Setup ─────────────
echo "📦 Installing Zsh..."
sudo dnf install -y zsh
echo '[ -n "$PS1" ] && exec zsh' >> ~/.bashrc

# ───────────── Language Tools ─────────────
echo "🔧 Installing toolbox if not present..."
sudo dnf install -y toolbox

echo "🐍 Installing Python pip..."
sudo dnf install -y python3-pip

echo "💻 Installing Golang..."
sudo dnf install -y golang

echo "☕ Installing OpenJDK 21..."
sudo dnf install -y java-21-openjdk

# ───────────── NVM + Node.js ─────────────
echo "🟩 Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

cat << 'EOC' >> ~/.zshrc
# NVM config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOC

export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install --lts

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────

echo "🎉 All apps were installed succesfully!"
echo "🔄 Please restart your terminal to apply changes."