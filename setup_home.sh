#!/bin/sh

cd ~/

ln -s ~/.dotfiles/home/bin .
for FILE in ~/.dotfiles/home/.*; do ln -s $FILE . ; done;

ln -s ~/.dotfiles/Code/settings.json ~/.config/Code/User/settings.json
ln -s ~/.dotfiles/Code/snippets/ ~/.config/Code/User/snippets

cd -

