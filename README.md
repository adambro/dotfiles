# Config files

The idea is all files and directories in `./home` folder get symlinked to the actual user home folder.

    cd ~/ && for FILE in ~/.dotfiles/home/.*; do ln -s $FILE . ; done;

### ZSH

Uses Antigen to manage ZSH plugins.
`zsh-notify` plugin requires `wmctrl` and `xdotool` tools to be installed (available in Ubuntu and Arch repos).

### Visual Studio Code

```
ln -s ~/.dotfiles/Code/settings.json ~/.config/Code/User/settings.json
ln -s ~/.dotfiles/Code/snippets/ ~/.config/Code/User/snippets
```
