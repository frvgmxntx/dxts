#!/usr/bin/env bash

source /home/frvg/.config/hypr/scripts/archdroid-icon-theme/color.sh

if [ -z "$COLOR" ]; then
  echo "Error: COLOR variable not found in color.sh"
  exit 1
fi

/home/frvg/.config/hypr/scripts/archdroid-icon-theme/change_color.sh -o archdroid -c "$COLOR"

gtk-update-icon-cache -f -t -i ~/.local/share/icons/archdroid-icon-theme/ && /home/frvg/.config/hypr/scripts/archdroid-icon-theme/reload-gtk.sh
