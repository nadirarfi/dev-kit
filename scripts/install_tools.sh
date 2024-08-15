#!/bin/bash


################## ZSH
# https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
sudo apt install zsh
zsh --version 
# https://ohmyz.sh/#install
sudo chsh -s $(which zsh) 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

################## ASDF
# https://asdf-vm.com/guide/getting-started.html
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0


################## Helper tools
sudo apt-get install build-essential
sudo apt-get install xclip
sudo apt-get install yq