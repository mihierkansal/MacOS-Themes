#!/usr/bin/env bash

# 1. Create clean staging directory structure
mkdir -p ~/GnomeBackup/configs/gtk-3.0 ~/GnomeBackup/configs/gtk-4.0
mkdir -p ~/GnomeBackup/assets/themes
mkdir -p ~/GnomeBackup/assets/icons
mkdir -p ~/GnomeBackup/assets/extensions

echo "-> Gathering GNOME Dconf settings..."
# 2. Extract strictly visual layout configuration keys
dconf dump /org/gnome/desktop/interface/ > ~/GnomeBackup/configs/interface.dconf
dconf dump /org/gnome/desktop/wm/preferences/ > ~/GnomeBackup/configs/wm-preferences.dconf
dconf dump /org/gnome/desktop/wm/keybindings/ > ~/GnomeBackup/configs/wm-keybindings.dconf
dconf dump /org/gnome/mutter/ > ~/GnomeBackup/configs/mutter.dconf

# 3. Surgically dump shell extension states
dconf read /org/gnome/shell/enabled-extensions > ~/GnomeBackup/configs/enabled-extensions.txt
dconf dump /org/gnome/shell/extensions/ > ~/GnomeBackup/configs/extensions-settings.dconf

# 4. Copy current manual GTK tweaks if they exist
[ -f ~/.config/gtk-3.0/gtk.css ] && cp ~/.config/gtk-3.0/gtk.css ~/GnomeBackup/configs/gtk-3.0/ 2>/dev/null
[ -f ~/.config/gtk-4.0/gtk.css ] && cp ~/.config/gtk-4.0/gtk.css ~/GnomeBackup/configs/gtk-4.0/ 2>/dev/null

echo "-> Moving physical assets into backup staging area..."
# 5. Use rsync to pool physical themes, icons, and extensions
[ -d ~/.themes ] && rsync -a ~/.themes/ ~/GnomeBackup/assets/themes/
[ -d ~/.local/share/themes ] && rsync -a ~/.local/share/themes/ ~/GnomeBackup/assets/themes/
[ -d ~/.icons ] && rsync -a ~/.icons/ ~/GnomeBackup/assets/icons/
[ -d ~/.local/share/icons ] && rsync -a ~/.local/share/icons/ ~/GnomeBackup/assets/icons/
[ -d ~/.local/share/gnome-shell/extensions ] && rsync -a ~/.local/share/gnome-shell/extensions/ ~/GnomeBackup/assets/extensions/

echo "-> Running Python asset inliner engine..."
# ==============================================================================
# INLINE ASSET CONVERTER: Smart-resolves paths for both physical themes and isolated user configs
# ==============================================================================
python3 - << 'EOF'
import os
import re
import base64
from pathlib import Path

def file_to_base64_url(file_path):
    try:
        ext = file_path.suffix.lower().replace('.', '')
        if ext not in ['png', 'svg', 'jpg', 'jpeg']: return None
        mime = "image/svg+xml" if ext == "svg" else f"image/{ext}"
        with open(file_path, "rb") as f:
            return f"data:{mime};base64,{base64.b64encode(f.read()).decode('utf-8')}"
    except Exception:
        return None

def process_css_files():
    backup_root = Path("~/GnomeBackup").expanduser()
    themes_assets_path = backup_root / "assets/themes"
    
    url_pattern = re.compile(r'url\s*\(\s*[\'"]?([^\'"\)]+)[\'()"]?\s*\)')
    
    # 1. Walk through every CSS file anywhere inside the staging area
    for root, dirs, files in os.walk(backup_root):
        for file in files:
            if file.endswith('.css'):
                css_file = Path(root) / file
                gtk_version = "gtk-4.0" if "gtk-4.0" in css_file.parts else "gtk-3.0" if "gtk-3.0" in css_file.parts else None
                
                if not gtk_version:
                    continue
                    
                print(f"    Processing stylesheet: {css_file.relative_to(backup_root)}")
                try:
                    with open(css_file, "r", encoding="utf-8", errors="ignore") as f:
                        content = f.read()
                    
                    def replace_match(match):
                        rel_path = match.group(1)
                        if rel_path.startswith(('data:', 'http')): return match.group(0)
                        
                        # Strategy A: Try resolving relative to the CSS file itself (works for standard theme folders)
                        target_img = Path(os.path.normpath(css_file.parent / rel_path))
                        
                        # Strategy B: If it's a standalone config file, find the missing assets inside the extracted themes
                        if not target_img.is_file() and "configs" in css_file.parts:
                            # Global search for the asset filename inside the themed assets directory
                            asset_filename = Path(rel_path).name
                            for img_root, _, img_files in os.walk(themes_assets_path):
                                if asset_filename in img_files:
                                    potential_match = Path(img_root) / asset_filename
                                    if gtk_version in potential_match.parts:
                                        target_img = potential_match
                                        break
                        
                        if target_img.is_file():
                            b64 = file_to_base64_url(target_img)
                            if b64: return f"url('{b64}')"
                        return match.group(0)
                        
                    updated = url_pattern.sub(replace_match, content)
                    with open(css_file, "w", encoding="utf-8") as f:
                        f.write(updated)
                except Exception as e:
                    print(f"    ! Error handling {css_file.name}: {e}")

process_css_files()
print(" -> Python file conversion parsing complete.")
EOF
# ==============================================================================

echo "-> Packaging archive into final tarball..."
# 6. Archive the workspace securely with the self-contained physical themes
tar -czf ~/desktop.tar.gz -C ~/GnomeBackup .
rm -rf ~/GnomeBackup
echo "=========================================================================="
echo "SUCCESS: Standalone archive generated at: ~/desktop.tar.gz"
