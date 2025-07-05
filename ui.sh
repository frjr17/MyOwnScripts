#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Update system
# ─────────────────────────────────────────────

echo "📦 Updating system packages..."
sudo dnf update -y

git clone https://github.com/frjr17/WhiteSur_Installer.git /tmp/WhiteSur_Installer
cd /tmp/WhiteSur_Installer
chmod +x *.sh

firefox
sleep 5
pkill firefox
echo "🌟 Installing WhiteSur theme and icons..."
./install.sh

# ─────────────────────────────────────────────
# Install pipx and gnome-extensions-cli
# ─────────────────────────────────────────────

echo "🐍 Ensuring pipx is available..."
if ! command -v pipx &> /dev/null; then
    sudo dnf install -y pipx python3-pip
fi

echo "🔁 Ensuring pipx path is in shell..."
pipx ensurepath

# Reload shell environment to make pipx available immediately
export PATH="$HOME/.local/bin:$PATH"

echo "📦 Installing gnome-extensions-cli..."
pipx install gnome-extensions-cli --system-site-packages

# ─────────────────────────────────────────────
# Install Extension Manager (GUI)
# ─────────────────────────────────────────────

echo "🧩 Installing GNOME Extension Manager GUI..."
sudo flatpak install -y flathub com.mattjakeman.ExtensionManager

# ─────────────────────────────────────────────
# Install GNOME Extensions via CLI
# ─────────────────────────────────────────────

echo "🎨 Installing GNOME Shell extensions..."

extensions=(
  user-theme@gnome-shell-extensions.gcampax.github.com
  blur-my-shell@aunetx
  dash-to-dock@micxgx.gmail.com
  logomenu@aryan_k
  Hide_Activities@shay.shayel.org
  just-perfection-desktop@just-perfection
  compiz-alike-magic-lamp-effect@hermes83.github.com
  moveclock@kuvaus.org
)

for ext in "${extensions[@]}"; do
  echo "→ Installing $ext"
  gnome-extensions-cli install "$ext" || echo "⚠️ Failed to install: $ext"
done

echo "✅ All done! Restart your GNOME session or run: gnome-shell --replace (on X11)"