#!/bin/sh

# track the system config in local git repo
sudo apt install -y etckeeper git

# ZSH as default shell + Antigen + plugin dependencies
sudo apt install -y zsh-antigen wmctrl xdotool
echo '/usr/share/zsh-antigen/antigen.zsh'
sudo chsh -s $(which zsh)

# CLI tools
sudo apt install -y vim htop silversearcher-ag

# VS Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
sudo sh -c 'echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf'
sudo etckeeper commit "Allow VS Code (and webpack) to watch many files"

# APT update repos & install
sudo apt update
sudo apt install code


