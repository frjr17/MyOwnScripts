#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Update system
# ─────────────────────────────────────────────

echo "📦 Updating system packages..."
sudo dnf update -y

git clone https://github.com/frjr17/WhiteSurInstaller.git /tmp/WhiteSur_Installer
cd /tmp/WhiteSur_Installer
chmod +x *.sh


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
)

for ext in "${extensions[@]}"; do
  echo "→ Installing $ext"
  gnome-extensions-cli install "$ext" || echo "⚠️ Failed to install: $ext"
done


# Install MoveClock extension from GitHub releases
cd /tmp
rm -rf moveclock moveclock@kuvaus.org.shell-extension.zip

wget https://github.com/kuvaus/moveclock/releases/latest/download/moveclock@kuvaus.org.shell-extension.zip

gnome-extensions install --force moveclock@kuvaus.org.shell-extension.zip
gnome-extensions enable moveclock@kuvaus.org

# Installing Compiz Alike Magic Lamp Effect
cd /tmp
rm -rf compiz-alike-magic-lamp-effect

git clone https://github.com/hermes83/compiz-alike-magic-lamp-effect.git
cd compiz-alike-magic-lamp-effect

bash install.sh

gnome-extensions enable compiz-alike-magic-lamp-effect@hermes83.github.com

# Installing Hide Top Bar extension
cd /tmp
rm -rf hidetopbar

git clone https://gitlab.gnome.org/tuxor1337/hidetopbar.git
cd hidetopbar

make
gnome-extensions install --force ./hidetopbar.zip

# ─────────────────────────────────────────────
# Installing apps
# ─────────────────────────────────────────────

sudo dnf install snapd -y
sudo ln -s /var/lib/snapd/snap /snap

# LibreOffice
echo "📚 Installing LibreOffice..."
sudo dnf install -y libreoffice
echo "✅ LibreOffice installed successfully."

# Brave
echo "🌐 Installing Brave..."
curl -fsS https://dl.brave.com/install.sh | sh
echo "✅ Brave installed successfully."

# Spotify
echo "🎵 Installing Spotify..."
sudo snap install spotify
echo "✅ Spotify installed successfully."

# Visual Studio Code
echo "💻 Installing Visual Studio Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update &&
sudo dnf install -y code 
echo "✅ Visual Studio Code installed successfully."

# Google Drive File Stream Driver
echo "📁 Installing Google Drive File Stream Driver..."
sudo dnf copr enable fluhus/gnome-googledrive
sudo dnf update --refresh
echo "✅ Google Drive File Stream Driver installed successfully."

# Telegram
echo "📱 Installing Telegram..."
sudo snap install telegram-desktop 

# Docker Desktop
echo "🚢 Installing Docker Desktop..."
cd /tmp
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm -O docker-desktop.rpm
sudo dnf install -y ./docker-desktop-x86_64.rpm
echo "✅ Docker Desktop installed successfully."

# Musecore
echo "🎼 Installing Musecore..."
wget https://cdn.jsdelivr.net/musescore/v4.6.5/MuseScore-Studio-4.6.5.253511702-x86_64.AppImage
chmod +x MuseScore-Studio-4.6.5.253511702-x86_64.AppImage
./MuseScore-Studio-4.6.5.253511702-x86_64.AppImage install
# Linux Dynamic Templates

echo "✅ All done! Restart your GNOME session or run: gnome-shell --replace (on X11)"
