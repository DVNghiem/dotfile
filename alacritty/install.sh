#!/bin/bash

cargo install alacritty

# We use Alacritty's default Linux config directory as our storage location here.
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

cp alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
