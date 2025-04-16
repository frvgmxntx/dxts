#!/usr/bin/env bash

waypaper

# MATUGEN POST HOOKS SINGLE SCRIPT
echo -e '---MATUGEN POST HOOK STARTING---'

# [templates.avatar]
magick -background none /home/frvg/.config/hypr/avatar.svg /home/frvg/.config/hypr/avatar.png &
echo -e '[templates.avatar]'

# [templates.fish]
echo -e '[templates.fish]'

# [templates.hyprland]
hyprctl reload &
echo -e '[templates.hyprland]'

# [templates.kitty]
killall -SIGUSR1 kitty &
echo -e '[templates.kitty]'

# [templates.kvantum]
kvantummanager --set KvLibadwaitaDark &
echo -e '[templates.kvantum]'

# [templates.mako]
makoctl reload &
echo -e '[templates.mako]'

# [templates.material-gtk-theme-color]

cd /home/frvg/.config/hypr/scripts/materia-theme/src/gtk-3.0

/home/frvg/.config/hypr/scripts/materia-theme/src/gtk-3.0/render-assets.sh > /dev/null 2>&1 && sleep 0.1

cd /home/frvg/.config/hypr/scripts/materia-theme
rm -r _build

meson setup _build -Dprefix="$HOME/.local" -Dcolors=dark -Dsizes=default > /dev/null 2>&1

meson install -C _build > /dev/null 2>&1
echo -e '[templates.material-gtk-theme-color]'

# [templates.gtk-archdroid-icons]
source /home/frvg/.config/hypr/scripts/archdroid-icon-theme/color.sh
cd /home/frvg/.config/hypr/scripts/archdroid-icon-theme/
/home/frvg/.config/hypr/scripts/archdroid-icon-theme/change_color.sh -o archdroid -c "$COLOR" > /dev/null 2>&1 && gtk-update-icon-cache -f -t -i ~/.local/share/icons/archdroid-icon-theme/ > /dev/null 2>&1

theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
gsettings set org.gnome.desktop.interface gtk-theme '' && gsettings set org.gnome.desktop.interface gtk-theme $theme

echo -e '[templates.gtk-archdroid-icons]'

echo -e '---MATUGEN POST HOOK ENDED---'
exit 0
