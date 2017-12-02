#!/bin/sh

cd ~/
ln -s ~/.dotfiles/home/bin .
for FILE in ~/.dotfiles/home/.*; do ln -s $FILE . ; done;
cd -

