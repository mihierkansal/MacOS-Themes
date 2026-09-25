# MacOS Theme for GNOME

This describes how to make your GNOME desktop look like macOS, with some resources included.

# GNOME Shell, GTK

Run ./install-desktop.sh in your terminal. Warning, it will log you out of GNOME. If it doesn't apply to some apps, copy the contents of ~/.themes/MacTahoe-Dark-Solid/gtk-4.0 (entire directory contents) into ~/.config/gtk-4.0.

# Wallpapers

You can get them from ./wallpaper.

# Applications

Copy everything from ./applaunchers to ~/.local/share/applications.

# Spotlight search

By default, Spotlight opens when you press Ctrl + Super + Space, to avoid conflicting with other shortcuts.

But, if you want Super + Space (since, on macOS, Command is equivalent to Super, and Spotlight opens on Command + Space), you can run `./spotlight-key.sh`.

# Firefox

Enable CSS customizations, then use ./firefox/theme.css as your userChrome.css. Note, unlike some themes, this does not make Firefox look like Safari; rather, it makes it look like the macOS Firefox (mainly styles the window buttons).
Trying to make it look like Safari would be impossible to do correctly, and it's anyway not the macOS experience; on real macOS, Firefox still looks like Firefox.

# Email Clients

This doesn't include a Thunderbird theme; theming that is harder than Firefox. If you want native macOS look, use a GTK-based email client: **Convey**, **Hylki**, or **Postcard** for example. (note: I am not affiliated with those projects; they're just ones I happened to find that respect the GTK theme)

# Vivaldi

Copy ./vivaldi to somewhere in your home directory and point Vivaldi Custom CSS to there. Note, this does not make Vivaldi look like Safari; it makes it look like the macOS Vivaldi.

# Chrome, other Chromium-based browsers

Unfortunately, Vivaldi is the only Chromium-based browser that supports this kind of theming.

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
