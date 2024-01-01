#!/usr/bin/fish

pacotes=(
	"wl-clipboard"	 		
	"wofi" "waybar" 
	"ttf-font-awesome" 	 
)



sudo pacman -Sy


# Itera sobre o array e exibe todos os elementos
for pk in "${pacotes[@]}"
do
    sudo pacman -S -q --needed --noconfirm $pk
done
