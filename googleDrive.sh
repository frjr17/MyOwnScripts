#!/usr/bin/env bash
set -euo pipefail

REMOTE_NAME="${REMOTE_NAME:-googleDrive}"
REMOTE="${REMOTE_NAME}:"
LOCAL_DIR="${LOCAL_DIR:-$HOME/GoogleDrive}"
TIMER_INTERVAL="${TIMER_INTERVAL:-1m}"
MAX_DELETE="${MAX_DELETE:-100}"

SERVICE_NAME="rclone-gdrive.service"
TIMER_NAME="rclone-gdrive.timer"
WRAPPER="$HOME/.local/bin/rclone-gdrive-bisync-notify"
SYSTEMD_DIR="$HOME/.config/systemd/user"
CACHE_DIR="$HOME/.cache/rclone"
LATEST_LOG="$CACHE_DIR/rclone-gdrive-bisync.log"

RUN_INIT=0

for arg in "$@"; do
  case "$arg" in
    --init)
      RUN_INIT=1
      ;;
    --help|-h)
      cat <<EOF
Usage:
  $0              Install/update service, timer, and notifications only
  $0 --init       Also run first baseline bisync with --resync

Environment variables:
  REMOTE_NAME     Default: gdrive
  LOCAL_DIR       Default: \$HOME/GoogleDrive
  TIMER_INTERVAL  Default: 1m
  MAX_DELETE      Default: 100
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing command: $1"
    return 1
  fi
}

echo "Checking dependencies..."

MISSING=0
need_cmd rclone || MISSING=1
need_cmd systemctl || MISSING=1
need_cmd flock || MISSING=1
need_cmd awk || MISSING=1

if ! command -v notify-send >/dev/null 2>&1; then
  echo "Missing notify-send. Install it with:"
  echo "  sudo dnf install libnotify"
  MISSING=1
fi

if ! command -v fusermount3 >/dev/null 2>&1; then
  echo "Missing fusermount3. Install it with:"
  echo "  sudo dnf install fuse3"
  MISSING=1
fi

if [ "$MISSING" -ne 0 ]; then
  echo "Install missing packages, then rerun this script."
  exit 1
fi

echo "Checking rclone remote: $REMOTE"

if ! rclone listremotes | grep -qx "${REMOTE_NAME}:"; then
  echo "Remote ${REMOTE_NAME}: does not exist."
  echo "Create it first with:"
  echo "  rclone config"
  exit 1
fi

rclone lsf "$REMOTE" --drive-skip-dangling-shortcuts >/dev/null

echo "Stopping old rclone service/timer if present..."

systemctl --user disable --now "$TIMER_NAME" >/dev/null 2>&1 || true
systemctl --user disable --now "$SERVICE_NAME" >/dev/null 2>&1 || true

if findmnt "$LOCAL_DIR" >/dev/null 2>&1; then
  echo "$LOCAL_DIR is mounted. Trying to unmount stale/old rclone mount..."
  fusermount3 -uz "$LOCAL_DIR" >/dev/null 2>&1 || true
fi

if findmnt "$LOCAL_DIR" >/dev/null 2>&1; then
  echo "Could not unmount $LOCAL_DIR."
  echo "Check it manually with:"
  echo "  findmnt $LOCAL_DIR"
  echo "  fusermount3 -uz $LOCAL_DIR"
  exit 1
fi

mkdir -p "$LOCAL_DIR" "$SYSTEMD_DIR" "$CACHE_DIR" "$HOME/.local/bin"

echo "Importing GNOME notification environment..."

systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS >/dev/null 2>&1 || true
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS >/dev/null 2>&1 || true

echo "Writing notification wrapper: $WRAPPER"

cat > "$WRAPPER" <<'EOF'
#!/usr/bin/env bash
set -u

LOCAL="${LOCAL_DIR:-$HOME/GoogleDrive}"
REMOTE_NAME="${REMOTE_NAME:-googleDrive}"
REMOTE="${REMOTE_NAME}:"
MAX_DELETE="${MAX_DELETE:-100}"

LOG_DIR="$HOME/.cache/rclone"
RUN_ID="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$LOG_DIR/rclone-gdrive-bisync-$RUN_ID.log"
LATEST_LOG="$LOG_DIR/rclone-gdrive-bisync.log"
LOCK_FILE="$LOG_DIR/rclone-gdrive-bisync.lock"

mkdir -p "$LOG_DIR"

notify() {
  local title="$1"
  local body="$2"
  local urgency="${3:-normal}"

  if command -v notify-send >/dev/null 2>&1; then
    notify-send -a "rclone Google Drive" -u "$urgency" "$title" "$body"
  fi
}

summarize_changes() {
  local file="$1"

  grep -E 'INFO  : .+: (Copied|Deleted|Moved|Renamed)' "$file" 2>/dev/null \
    | grep -vEi 'Duplicate object|Duplicate directory|ignoring' \
    | sed -E 's/^[0-9\/: ]+ INFO  : //' \
    | head -n 12
}

exec 9>"$LOCK_FILE"

if ! flock -n 9; then
  exit 0
fi

rclone bisync "$LOCAL" "$REMOTE" \
  --recover \
  --resilient \
  --max-lock 5m \
  --max-delete "$MAX_DELETE" \
  --conflict-resolve newer \
  --conflict-loser pathname \
  --create-empty-src-dirs \
  --drive-skip-dangling-shortcuts \
  --log-file "$LOG_FILE" \
  --log-level INFO

STATUS=$?

ln -sf "$LOG_FILE" "$LATEST_LOG"

if [ "$STATUS" -eq 0 ]; then
  SUMMARY="$(summarize_changes "$LOG_FILE")"

  if [ -n "$SUMMARY" ]; then
    notify "Google Drive synced changes" "$SUMMARY"
  fi

  exit 0
else
  ERROR_SUMMARY="$(tail -n 12 "$LOG_FILE" 2>/dev/null)"
  notify "Google Drive sync failed" "$ERROR_SUMMARY" "critical"
  exit "$STATUS"
fi
EOF

chmod +x "$WRAPPER"

echo "Writing systemd user service..."

cat > "$SYSTEMD_DIR/$SERVICE_NAME" <<EOF
[Unit]
Description=Bisync local Google Drive folder with Google Drive
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
Environment=REMOTE_NAME=$REMOTE_NAME
Environment=LOCAL_DIR=$LOCAL_DIR
Environment=MAX_DELETE=$MAX_DELETE
ExecStart=$WRAPPER
EOF

echo "Writing systemd user timer..."

cat > "$SYSTEMD_DIR/$TIMER_NAME" <<EOF
[Unit]
Description=Run Google Drive bisync every $TIMER_INTERVAL

[Timer]
OnBootSec=2m
OnUnitActiveSec=$TIMER_INTERVAL
AccuracySec=15s
Unit=$SERVICE_NAME
Persistent=true

[Install]
WantedBy=timers.target
EOF

if [ "$RUN_INIT" -eq 1 ]; then
  echo
  echo "Initial baseline requested."
  echo "Local folder:  $LOCAL_DIR"
  echo "Remote folder: $REMOTE"
  echo

  if [ -z "$(find "$LOCAL_DIR" -mindepth 1 -maxdepth 1 2>/dev/null | head -n 1)" ]; then
    echo "Local folder is empty. Downloading remote files first..."
    rclone copy "$REMOTE" "$LOCAL_DIR" \
      --progress \
      --drive-skip-dangling-shortcuts
  else
    echo "Local folder is not empty. Skipping initial rclone copy."
  fi

  echo
  echo "Running baseline dry-run..."
  rclone bisync "$LOCAL_DIR" "$REMOTE" \
    --resync \
    --resync-mode newer \
    --drive-skip-dangling-shortcuts \
    --dry-run \
    -v

  echo
  read -r -p "Proceed with real baseline bisync? Type YES to continue: " CONFIRM

  if [ "$CONFIRM" != "YES" ]; then
    echo "Baseline cancelled."
    echo "Service files were written, but timer will not be enabled."
    exit 1
  fi

  echo "Running real baseline..."
  rclone bisync "$LOCAL_DIR" "$REMOTE" \
    --resync \
    --resync-mode newer \
    --drive-skip-dangling-shortcuts \
    -v
fi

echo "Reloading systemd user units..."

systemctl --user daemon-reload
systemctl --user enable --now "$TIMER_NAME"

echo
echo "Done."
echo
echo "Local Google Drive folder:"
echo "  $LOCAL_DIR"
echo
echo "Timer status:"
systemctl --user --no-pager status "$TIMER_NAME" || true

echo
echo "Useful commands:"
echo "  systemctl --user list-timers | grep rclone"
echo "  systemctl --user start $SERVICE_NAME"
echo "  journalctl --user -u $SERVICE_NAME -f"
echo "  tail -f $LATEST_LOG"