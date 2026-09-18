# MacOS Theme for GNOME

This describes how to make your GNOME desktop look like macOS, with some resources included.

# GNOME Shell, GTK

Run ./install-desktop.sh in your terminal. Warning, it will log you out of GNOME. If it doesn't apply to some apps, copy the contents of ~/.themes/MacTahoe-Dark-Solid/gtk-4.0 (entire directory contents) into ~/.config/gtk-4.0.

# Wallpapers

You can get them from ./wallpaper.

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

# Updating/Contributing

Make your changes in your home theme folder (~/.themes), run ./pack.sh then copy desktop.tar.gz from your home directory into ./desktop.

Or, unpack desktop.tar.gz, make your edits, re-pack natively, and copy.
