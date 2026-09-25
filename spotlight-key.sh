gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"
gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]"
gsettings --schemadir "$HOME/.local/share/gnome-shell/extensions/lightning-gnome-launcher@mihierkansal/schemas" \
  set org.gnome.shell.extensions.lightning-launcher shortcut-key "['<Super>space']"