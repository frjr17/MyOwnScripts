#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Setting up development environment..."

# ─────────────────────────────────────────────
# Vim
# ─────────────────────────────────────────────
echo "Installing Vim"
sudo dnf install -y vim
echo "✅ Vim installed!"

# ─────────────────────────────────────────────
# NVM, Node.js & npm
# ─────────────────────────────────────────────
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install --lts
echo "✅ NVM and Node.js installed!"

# ─────────────────────────────────────────────
# npm Configuration
# ─────────────────────────────────────────────
# Install repository .npmrc into the user's home so npm uses consistent defaults
if [ -f "$(pwd)/.npmrc" ]; then
    cp "$(pwd)/.npmrc" "$HOME/.npmrc"
    echo "✅ .npmrc copied to $HOME/.npmrc"
else
    echo "ℹ️ .npmrc not found in repo; skipping npm config install"
fi

# ─────────────────────────────────────────────
# Docker
# ─────────────────────────────────────────────
echo "🚢 Setting up Docker..."
sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
newgrp docker

echo "✅ Docker installed and running!"


echo "✅ Development environment setup complete! (Please restart your computer to apply changes)"
