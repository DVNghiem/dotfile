#!/bin/bash
sudo dnf install cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel g++
cargo install alacritty

# We use Alacritty's default Linux config directory as our storage location here.
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

mkdir -p ~/.config/alacritty 

cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
