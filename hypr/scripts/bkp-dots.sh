#!/bin/bash

cp -rf ~/.config/fish ~/Projects/Git/dxts/
cp -rf ~/.config/hypr ~/Projects/Git/dxts/
cp -rf ~/.config/ignis ~/Projects/Git/dxts/
cp -rf ~/.config/matugen ~/Projects/Git/dxts/
cp -rf ~/.config/waybar ~/Projects/Git/dxts/

cp -rf ~/.local/share/themes/FlatColor ~/Projects/Git/dxts/

cd ~/Projects/Git/dxts/
git add ./*
git commit -m "bang bang snapshoted!"
git push
