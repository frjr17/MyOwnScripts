#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Constants & Variables
# ─────────────────────────────────────────────

GITHUB_NAME="Hernán Valencia"
GITHUB_USERNAME="frjr17"
GITHUB_EMAIL="hernanadrianv17@gmail.com"

FONTS_DIR="$HOME/fonts"
FONTS_DEST="$HOME/.local/share/fonts"

ZSHRC="$HOME/.zshrc"
P10K_FILE="$HOME/.p10k.zsh"

# ─────────────────────────────────────────────
# Git Configuration
# ─────────────────────────────────────────────

echo "🛠️ Setting up Git..."
git config --global user.name "$GITHUB_NAME"
git config --global user.username "$GITHUB_USERNAME"
git config --global user.email "$GITHUB_EMAIL"

# ─────────────────────────────────────────────
# Install Fonts
# ─────────────────────────────────────────────

echo "📦 Installing fonts from: $FONTS_DIR"
mkdir -p "$FONTS_DEST"

if [[ -d "$FONTS_DIR" ]]; then
    unzip -o "$FONTS_DIR/FiraCodeNF.zip" -d "$FONTS_DIR"
    unzip -o "$FONTS_DIR/OperatorMonoLig.zip" -d "$FONTS_DIR"
    mv "$FONTS_DIR"/*.ttf "$FONTS_DEST" || true
    mv "$FONTS_DIR"/*.otf "$FONTS_DEST" || true
else
    echo "⚠️ Fonts directory '$FONTS_DIR' not found. Skipping fonts installation."
fi

# ─────────────────────────────────────────────
# Install Packages
# ─────────────────────────────────────────────

echo "📦 Installing required packages..."
sudo dnf install -y \
    zsh curl ruby ruby-devel \
    rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} ruby-bundled-gems \
    make automake gcc gcc-c++ kernel-devel

sudo gem install colorls

# ─────────────────────────────────────────────
# Zsh, Oh My Zsh, and Plugins
# ─────────────────────────────────────────────

echo "🎨 Installing Oh My Zsh and plugins..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# ─────────────────────────────────────────────
# Zsh Configuration
# ─────────────────────────────────────────────

echo "⚙️ Configuring Zsh..."
sed -i 's/^plugins=.*/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' "$ZSHRC"
sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"

cat << 'EOF' >> "$ZSHRC"

# Custom Aliases and Enhancements
if command -v colorls &> /dev/null; then
    alias ls="colorls"
    alias la="colorls -al"
fi

alias update='sudo dnf update && sudo dnf upgrade && sudo dnf autoremove'
alias rmdir='rm -rf'
alias open='xdg-open'
alias python='python3'
alias venv_activate='source ./venv/bin/activate'
alias create_venv='python -m venv venv && venv_activate'

EOF

# Powerlevel10k tweak (optional)
[[ -f "$P10K_FILE" ]] && sed -i 's|POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique|POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last|' "$P10K_FILE" || true

# ─────────────────────────────────────────────
# Set Zsh as Default Shell
# ─────────────────────────────────────────────

echo "💻 Setting Zsh as default shell for user: $USER"
chsh -s "$(which zsh)" "$USER"

echo "✅ Setup complete! Restart your terminal or run: exec zsh"
