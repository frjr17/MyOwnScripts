#!/usr/bin/env bash
set -euo pipefail

APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$HOME/.local/share/icons"

# name|display name|url|brave profile directory|icon url (optional)|svg fill override (optional)
APPS=(
  "whatsapp|WhatsApp|https://web.whatsapp.com|Default|https://cdn.simpleicons.org/whatsapp"
  "work-whatsapp|Work WhatsApp|https://web.whatsapp.com|WorkWhatsApp|https://cdn.simpleicons.org/whatsapp"
  "chatgpt|ChatGPT|https://chatgpt.com|Default|https://cdn.jsdelivr.net/npm/simple-icons@11/icons/openai.svg|#ffffff"
  "claude|Claude|https://claude.ai|Default|https://cdn.simpleicons.org/claude"
  "canva|Canva|https://www.canva.com|Default"
  "notion|Notion|https://www.notion.so|Default|https://cdn.simpleicons.org/notion/white"
)

usage() {
  cat <<EOF
Usage:
  $0 install   [app ...]   Install all apps, or only the ones given
  $0 uninstall [app ...]   Uninstall all apps, or only the ones given
  $0 list                  List available apps

Apps: $(for entry in "${APPS[@]}"; do echo -n "${entry%%|*} "; done)
EOF
  exit 1
}

find_app() {
  for entry in "${APPS[@]}"; do
    [ "${entry%%|*}" = "$1" ] && echo "$entry" && return 0
  done
  echo "❌ Unknown app: $1" >&2
  return 1
}

install_app() {
  IFS='|' read -r name display url profile icon_url fill <<<"$1"
  local domain ext icon desktop
  domain="$(echo "$url" | sed -E 's|https?://||; s|/.*||')"
  desktop="$APPS_DIR/brave-pwa-$name.desktop"

  # ponytail: transparent-background icon urls where the favicon service ships a white plate
  icon_url="${icon_url:-https://www.google.com/s2/favicons?domain=$domain&sz=256}"
  ext=png
  case "$icon_url" in *simpleicons*|*.svg) ext=svg ;; esac
  icon="$ICONS_DIR/brave-pwa-$name.$ext"

  echo "📦 Installing $display..."

  rm -f "$ICONS_DIR/brave-pwa-$name".{png,svg}
  curl -fsSL -A "Mozilla/5.0" "$icon_url" -o "$icon" ||
    echo "⚠️ Could not download icon for $display"

  if [ -n "$fill" ] && [ "$ext" = svg ]; then
    sed -i "s|<svg |<svg fill=\"$fill\" |" "$icon"
  fi

  cat >"$desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$display
Exec=brave-browser --profile-directory=$profile --app=$url --class=brave-pwa-$name
Icon=$icon
Terminal=false
StartupWMClass=brave-pwa-$name
Categories=Network;
EOF

  echo "✅ $display installed."
}

uninstall_app() {
  IFS='|' read -r name display url profile _ <<<"$1"

  echo "🗑️ Uninstalling $display..."
  rm -f "$APPS_DIR/brave-pwa-$name.desktop" "$ICONS_DIR/brave-pwa-$name".{png,svg}

  if [ "$profile" != "Default" ]; then
    echo "ℹ️ Profile data kept. Remove it manually with:"
    echo "  rm -rf \"\$HOME/.config/BraveSoftware/Brave-Browser/$profile\""
  fi

  echo "✅ $display uninstalled."
}

[ $# -ge 1 ] || usage
cmd="$1"
shift

case "$cmd" in
  list)
    for entry in "${APPS[@]}"; do
      IFS='|' read -r name display url profile <<<"$entry"
      installed=" "
      [ -f "$APPS_DIR/brave-pwa-$name.desktop" ] && installed="✅"
      printf "%s %-15s %-15s %s\n" "$installed" "$name" "$display" "$url"
    done
    exit 0
    ;;
  install)
    if ! command -v brave-browser >/dev/null 2>&1; then
      echo "❌ brave-browser not found. Install it with:"
      echo "  curl -fsS https://dl.brave.com/install.sh | sh"
      exit 1
    fi
    mkdir -p "$APPS_DIR" "$ICONS_DIR"
    action=install_app
    ;;
  uninstall)
    action=uninstall_app
    ;;
  *)
    usage
    ;;
esac

if [ $# -eq 0 ]; then
  for entry in "${APPS[@]}"; do "$action" "$entry"; done
else
  for name in "$@"; do
    entry="$(find_app "$name")"
    "$action" "$entry"
  done
fi

command -v update-desktop-database >/dev/null 2>&1 &&
  update-desktop-database "$APPS_DIR" || true

echo "🎉 Done."
