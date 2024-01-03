#!/usr/bin/fish
set -l tools fish fisher kitty micro fzf z gnome-disk-utility unzip sysbench ncdu pass lsof inxi fastfetch
set -l network chromium openssh nmap openconnect
set -l dev go git github-cli vscodium-bin vscodium-bin-marketplace insomnium-bin docker docker-compose docker-buildx python-pip python-pipx meld python

set -l fonts ttf-font-awesome ttf-jetbrains-mono
set -l token opensc pkcs11-helper pcsc-tools ca-certificates-icp_br safesignidentityclient sac-core

set -l pacotes $tools $fonts $dev $token $network

sudo ls -la
yay -Sy

# Itera sobre o array e exibe todos os elementos
for pk in $pacotes
    echo "instalando $pk"
    yay -S -q --needed --noconfirm $pk
end
