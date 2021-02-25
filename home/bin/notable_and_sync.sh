#!/bin/sh

cd ~/Dropbox/notes
pwd
git pull

notable

git add -A && git commit -am 'Script Notable sync' && git push

