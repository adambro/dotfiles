#!/bin/sh

# set NPM cache without sudo
# https://docs.npmjs.com/getting-started/fixing-npm-permissions
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

# make NPM global packages available in PATH
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
source ~/.profile

