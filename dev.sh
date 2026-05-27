#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Installing Dev Setup
# ─────────────────────────────────────────────
echo "🚀 Setting up development environment..."

echo "Installing Vim"
sudo dnf install -y vim
echo "✅ Vim installed!"

# Install NVM (Node Version Manager with Node.js & npm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install --lts
echo "✅ NVM and Node.js installed!"

# Docker
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
echo "✅ Docker installed and running!"


echo "✅ Development environment setup complete!"
