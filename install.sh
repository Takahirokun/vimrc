#!/bin/bash
# Install Requirements for Linux

# apt update and install
sudo apt update -y
sudo apt install unzip -y

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install deno 
curl -fsSL https://deno.land/x/install/install.sh | sh

