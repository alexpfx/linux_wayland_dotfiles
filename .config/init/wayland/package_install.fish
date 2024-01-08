#!/usr/bin/fish
set -l wl_tools "wl-clipboard" "wofi" "waybar" "wtype" "ydotool" "slurp" "grim" "swappy" "rofi-lbonn-wayland-git" "qt5-wayland" "qt6-wayland" "hyprpaper" "dunst" "xdg-desktop-portal-hyprland"
set -l other "ttf-font-awesome" "sddm" "hyprland" "kwayland5"


set -l pacotes $wl_tools $other

sudo ls -la
yay -Sy

# Itera sobre o array e exibe todos os elementos
for pk in $pacotes
    yay -S -q --needed --noconfirm $pk
end
