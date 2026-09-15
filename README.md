# MacOS Theme for GNOME

This describes how to make your GNOME desktop look like macOS, with some resources included.

# GNOME Shell, GTK

Run this in your terminal

```
# 1. Extract the master archive
mkdir -p ~/GnomeRestore
tar -xzvf ./desktop/desktop.tar.gz -C ~/GnomeRestore

# 2. Put the asset and configuration directories back where they belong
mkdir -p ~/.themes ~/.icons ~/.config ~/.local/share/gnome-shell
cp -r ~/GnomeRestore/files/extensions ~/.local/share/gnome-shell/
cp -r ~/GnomeRestore/files/gtk-3.0 ~/.config/
cp -r ~/GnomeRestore/files/gtk-4.0 ~/.config/
[ -d "~/GnomeRestore/files/.themes" ] && cp -r ~/GnomeRestore/files/.themes ~/
[ -d "~/GnomeRestore/files/.icons" ] && cp -r ~/GnomeRestore/files/.icons ~/

# 3. Restore the layout database and the extension variables
dconf load / < ~/GnomeRestore/system-layout.dconf
dconf load /org/gnome/shell/extensions/ < ~/GnomeRestore/extensions-settings.dconf

# 4. Clean up staging environment
rm -rf ~/GnomeRestore
```

# Applications

Copy everything from ./applaunchers to ~/.local/share/applications.

# Super + Space to open Applications + macOS window buttons

```
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"

gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>space']"

gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
```

# Vivaldi

Copy ./vivaldi to somewhere in your home directory and
point Vivaldi Custom CSS to there.

# VS Code CSS

Get an extension that lets you do custom CSS, copy ./vs-code.css to somewhere in your home directory, then add this to your VS Code settings:

```json
"window.menuStyle": "custom",
"window.controlsStyle": "custom",
"window.titleBarStyle": "custom",

"vscode_custom_css.imports": ["(Path to the vs-code.css file)"],
"window.menuBarVisibility": "toggle",
```

# MEGA

MEGA sync will not work by default if you have system tray disabled; either enable it or use mega-cmd.
