#!/bin/bash
theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
gsettings set org.gnome.desktop.interface gtk-theme ''
sleep 0.01
gsettings set org.gnome.desktop.interface gtk-theme $theme
