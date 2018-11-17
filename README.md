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

VS Code extensions via `code --list-extensions` command:

```
castwide.solargraph
christian-kohler.npm-intellisense
cssho.vscode-svgviewer
dbaeumer.vscode-eslint
dbankier.vscode-quick-select
eamodio.gitlens
eg2.vscode-npm-script
formulahendry.auto-close-tag
formulahendry.auto-complete-tag
formulahendry.auto-rename-tag
formulahendry.code-runner
jasonnutter.search-node-modules
kisstkondoros.vscode-codemetrics
mikestead.dotenv
ms-vscode.azure-account
naereen.makefiles-support-for-vscode
PeterJausovec.vscode-docker
quicktype.quicktype
rebornix.ruby
WallabyJs.quokka-vscode
ziyasal.vscode-open-in-github
```
