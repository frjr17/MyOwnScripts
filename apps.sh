#!/bin/bash

set -euo pipefail

echo "📦 Updating system..."
sudo dnf update -y

# ─────────────────────────────────────────────
# Snap Setup
# ─────────────────────────────────────────────

echo "🛠️ Installing Snap support..."
sudo dnf install -y snapd
sudo ln -sf /var/lib/snapd/snap /snap

# ─────────────────────────────────────────────
# Flatpak + Flathub Setup
# ─────────────────────────────────────────────

echo "🧩 Setting up Flatpak and Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "📥 Installing Flatpak apps..."
flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub com.spotify.Client
mkdir ~/.config/systemd/user
touch ~/.config/systemd/user/spotify.service

cat << 'EOF' >> ~/.config/systemd/user/spotify.service
[Unit]
Description=Launch Spotify (Flatpak)
After=graphical-session.target

[Service]
ExecStart=flatpak run com.spotify.Client
Restart=on-failure
TimeoutStopSec=5
KillSignal=SIGINT

[Install]
WantedBy=default.target
EOF


# Note: Microsoft Edge is unofficial via Flathub Beta
flatpak install -y flathub-beta com.microsoft.Edge || echo "⚠️ Edge Flatpak may be unavailable or unofficial."

# ─────────────────────────────────────────────
# RPM Package Installs
# ─────────────────────────────────────────────

echo "🌐 Installing Google Chrome and Variety..."
sudo dnf install -y google-chrome-stable variety

echo "💻 Setting up Visual Studio Code repository..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo tee /etc/yum.repos.d/vscode.repo > /dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

echo "📥 Installing VS Code...(It requires a 10 seconds sleep to avoid snap bugs)"
sleep 10
sudo snap install code --classic

sudo dnf install libreoffice -y

echo "✅ All apps installed successfully!"
