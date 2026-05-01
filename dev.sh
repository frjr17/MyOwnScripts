#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Installing Dev Setup
# ─────────────────────────────────────────────
echo "🚀 Setting up development environment..."

echo "Installing Vim"
sudo dnf install -y vim
echo "✅ Vim installed!"

echo "Installing favorite shell (Zsh) and Oh My Zsh..."
./favoriteShell.sh
echo "✅ Shell setup complete!"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash


echo "✅ Development environment setup complete!"