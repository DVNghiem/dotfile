#!/bin/bash

sudo dnf install zsh zsh-autosuggestions zsh-syntax-highlighting 

chsh -s $(which zsh)

# Copy .zshrc to home directory
cp zsh/.zshrc ~/
