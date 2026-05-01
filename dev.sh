#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Installing Dev Setup
# ─────────────────────────────────────────────
echo "🚀 Setting up development environment..."

echo "Installing Vim"
sudo dnf install -y vim
echo "✅ Vim installed!"

# Oh My Zsh with Powerlevel10k
./favoriteShell.sh

# Install NVM (Node Version Manager with Node.js & npm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install --lts
echo "✅ NVM and Node.js installed!"

echo "✅ Development environment setup complete!"