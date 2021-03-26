# Config files

The setup (configuration and application install) is automated using `make` tool.

## Manual setup

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
❯ .dotfiles master* code --list-extensions
alexclewontin.make-lsp-vscode
atlassian.atlascode
aws-scripting-guy.cform
bierner.markdown-yaml-preamble
christian-kohler.path-intellisense
cssho.vscode-svgviewer
Dart-Code.dart-code
DavidAnson.vscode-markdownlint
dbaeumer.vscode-eslint
eamodio.gitlens
EditorConfig.EditorConfig
emeraldwalk.RunOnSave
esbenp.prettier-vscode
foam.foam-vscode
hashicorp.terraform
ipedrazas.kubernetes-snippets
kddejong.vscode-cfn-lint
kortina.vscode-markdown-notes
ms-azuretools.vscode-docker
ms-kubernetes-tools.vscode-kubernetes-tools
philipbe.theme-gray-matter
redhat.vscode-yaml
shd101wyy.markdown-preview-enhanced
streetsidesoftware.code-spell-checker
streetsidesoftware.code-spell-checker-polish
tchayen.markdown-links
thomas-baumgaertner.vcl
WallabyJs.quokka-vscode
wholroyd.jinja
yzhang.markdown-all-in-one
```
