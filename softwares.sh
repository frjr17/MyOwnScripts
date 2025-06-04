#!/bin/bash

set -euo pipefail

echo "🔧 Installing toolbox if not present..."
sudo dnf install -y toolbox

# ─────────────────────────────────────────────
# Create Toolbox Container
# ─────────────────────────────────────────────

if toolbox list | grep -q '^dev\s'; then
  echo "⚠️  Toolbox container 'dev' already exists. Skipping creation."
else
  echo "📦 Creating toolbox container 'dev'..."
  toolbox create --container dev
fi

# ─────────────────────────────────────────────
# Define Dev Setup Script Inside Toolbox
# ─────────────────────────────────────────────

echo "🚀 Installing development tools inside toolbox..."

toolbox run --container dev bash << 'EOF'
set -euo pipefail

echo "📥 Updating container packages..."
sudo dnf update -y

echo "📥 Installing snap"
sudo dnf install snapd -y
sudo ln -sf /var/lib/snapd/snap /snap

# ───────────── ZSH Setup ─────────────
echo "📦 Installing Zsh..."
sudo dnf install -y zsh
echo '[ -n "$PS1" ] && exec zsh' >> ~/.bashrc

# ───────────── Language Tools ─────────────
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

echo "📥 Installing VS Code...(It requires a 10 seconds sleep to avoid snap bugs)"
sleep 10
sudo snap install code --classic

echo "📥 Installing my favorite shell"
sudo dnf install -y \
    zsh curl ruby ruby-devel \
    rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} ruby-bundled-gems \
    make automake gcc gcc-c++ kernel-devel

sudo gem install colorls

echo "💻 Setting Zsh as default shell for user: $(whoami)"
chsh -s "$(which zsh)" "$(whoami)"

echo "✅ All tools installed in toolbox: dev"
EOF

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────

echo "🎉 Dev toolbox 'dev' is ready!"
echo "👉 Enter it anytime with: toolbox enter dev"
