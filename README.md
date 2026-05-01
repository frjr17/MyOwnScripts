# My Own Scripts

Small collection of Bash scripts for setting up a Fedora desktop, configuring GNOME shortcuts, and bootstrapping a development shell.

## 📦 What's Inside

- `dev.sh` - installs a basic developer toolchain and calls the shell setup script. 🛠️
- `favoriteShell.sh` - configures Zsh, Oh My Zsh, Powerlevel10k, fonts, aliases, and Git identity. 🎨
- `fedoraSetup.sh` - installs a Fedora desktop setup with GNOME tweaks, apps, extensions, and theming. 🖥️
- `ui.sh` - configures GNOME keyboard shortcuts and workspace/window bindings. ⌨️
- `fonts/` - local font archives used by the shell setup script. 🔤

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

