#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Keyboard Commands
# ─────────────────────────────────────────────

echo "⌨️ Setting up custom keyboard shortcuts..."

# Window movement between monitors
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "['<Control><Alt>Down']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "['<Control><Alt>Left']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "['<Control><Alt>Right']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "['<Control><Alt>Up']"

# Workspace navigation
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Shift><Super>Left']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Shift><Super>Right']"

# Fullscreen toggle
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['F4']"

# Show applications (Activities)
gsettings set org.gnome.shell.keybindings show-applications "['<Super>a']"

# Notifications
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>n']"

# Settings - open via dbus/Activities
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "[]"
dbus-launch gsettings set org.gnome.desktop.app-folders folder-children "['Utilities', 'Sundry']" 2>/dev/null || true

# Settings
gsettings set org.gnome.shell.keybindings open-application-grid "['<Super>i']"

# Custom shortcuts
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus-open/name "'Open Files'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus-open/command "'nautilus'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus-open/binding "'<Super>e'"

echo "✅ Keyboard shortcuts configured!"
