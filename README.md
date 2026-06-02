# My Own Scripts

Small collection of Bash scripts for setting up a Fedora desktop, configuring GNOME shortcuts, and bootstrapping a development shell.

## 📦 What's Inside

- `dev.sh` — Bootstraps a development environment. Installs common developer packages, runtime managers (e.g., `nvm` for Node), language tooling, and then calls the shell setup to ensure your interactive environment is ready. Run from the repo root with `./dev.sh`.

- `favoriteShell.sh` — Sets up your preferred interactive shell. Installs/configures Zsh, Oh My Zsh, Powerlevel10k theme, required fonts (from `fonts/`), common aliases, and writes Git identity values (from `.env`) to your global Git config. Review before running as it updates shell defaults.

- `fedoraSetup.sh` — Installs and configures a Fedora desktop environment. Installs packages, Flatpaks, GNOME extensions, themes, and other desktop utilities. Intended for setting up a fresh Fedora workstation; it may change system packages and settings.

- `ui.sh` — Applies GNOME UI tweaks and keyboard bindings. Uses `gsettings`/`dconf` to create or update workspace behavior, shortcut mappings, and window-management preferences.

- `googleDrive.sh` — Utility for configuring or syncing Google Drive resources. Depending on your system tools (e.g., `rclone`), this script helps set up authentication and mount/sync workflows. Inspect the script for the exact flow before use.

- `snapper.sh` — Helpers around `snapper` (Btrfs snapshot management). Provides shortcuts for creating, listing, and cleaning snapshots so you can manage system rollbacks. Run with care on systems using Btrfs.

- `fonts/` — Local font archives referenced by the shell setup. Place required font ZIPs here so `favoriteShell.sh` can install them.

- Other scripts (one-off helpers) — Review each script's header comments for usage examples and options before running. Many scripts expect to be executed from the repository root.

## ✅ Requirements

These scripts are written for Fedora/Linux and assume a GNOME-based desktop for the UI setup.

Common dependencies include:

- `bash`
- `sudo`
- `dnf`
- `git`
- `curl`
- `unzip`

Some scripts also expect tools such as `zsh`, `pipx`, `flatpak`, `snap`, `gnome-extensions`, and `firefox` to be available or installable on the system.

## ▶️ Usage

Run the scripts directly from the repository root:

```bash
chmod +x *.sh
./favoriteShell.sh
./dev.sh
./ui.sh
./fedoraSetup.sh
```

## 📝 Notes

- `favoriteShell.sh` updates global Git config values and changes your default shell to Zsh. 🔐
- `fedoraSetup.sh` installs desktop apps, GNOME extensions, and theming packages, so it can take a while. ⏳
- `dev.sh` depends on `favoriteShell.sh` and installs Node.js through `nvm`. 📦
- The font installation step expects `FiraCodeNF.zip` and `OperatorMonoLig.zip` inside `fonts/`. 🗂️

## ⚠️ Safety

These scripts make system-wide changes. Review them before running, especially if you want to adjust package lists, shell settings, or GNOME keybindings.

## 🔧 Configuration

- Copy `.env.example` to `.env` and fill in your values before running scripts that rely on Git identity or other environment variables:

```bash
cp .env.example .env
# Edit .env and provide values for:
# GITHUB_NAME (e.g., Jane Doe)
# GITHUB_USERNAME (e.g., janedoe)
# GITHUB_EMAIL (e.g., jane@example.com)
```

The repository includes a commented `.env.example` with placeholders and descriptions to help you set these values.

