#!/usr/bin/env bash
cd ~/Projects/Git/materia-theme/src/gtk-3.0
~/Projects/Git/materia-theme/src/gtk-3.0/render-assets.sh &&
cd ~/Projects/Git/materia-theme
meson _build -Dprefix="$HOME/.local" -Dcolors=dark -Dsizes=default &&
meson install -C _build
