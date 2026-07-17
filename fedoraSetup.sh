#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Keyboard Commands
# ─────────────────────────────────────────────

echo "⌨️ Setting up custom keyboard shortcuts..."

# Window movement between monitors
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "['<Shift><Super>Down']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "['<Shift><Super>Left']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "['<Shift><Super>Right']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "['<Shift><Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"

# Workspace navigation
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Shift><Alt>Left']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Shift><Alt>Right']"

# Fullscreen toggle
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['F4']"

# Show applications (Activities)
gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>a']"

# Notifications
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>n']"


# Settings
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>i']"

# "Open File Explorer" shortcut (custom one)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Open File Explorer'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'nautilus'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>e'

echo "✅ Keyboard shortcuts configured!"

# ─────────────────────────────────────────────
# Display Behavior
# ─────────────────────────────────────────────

# Prevent suspend when the laptop lid is closed
echo "🛑 Configuring lid-close behavior..."
sudo mkdir -p /etc/systemd/logind.conf.d
cat <<'EOF' | sudo tee /etc/systemd/logind.conf.d/99-ignore-lid.conf >/dev/null
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF

# Also set the power button to show the interactive dialog instead of shutting down immediately
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'

echo "✅ Lid-close behavior configured! (Requires reboot to take effect)"