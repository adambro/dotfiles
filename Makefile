
## Install and configure everything.
config: ~/.antigen.zsh ~/.config/Code/User/settings.json ~/bin
	dconf load /org/gnome/terminal/ < terminal-profile.cfg

/usr/bin/etckeeper:
	sudo apt install -y etckeeper git

/usr/bin/curl: /usr/bin/etckeeper
	sudo apt install -y curl vim htop silversearcher-ag

/usr/bin/code: /usr/bin/curl /usr/bin/etckeeper
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
	sudo mv /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	# APT update repos & install
	sudo apt update
	sudo apt install code
	# https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
	sudo sh -c 'echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf'
	sudo etckeeper commit "Allow VS Code (and webpack) to watch many files"

## Use shared VS Code configuration
~/.config/Code/User/settings.json: /usr/bin/code
	ln -s ~/.dotfiles/Code/settings.json ~/.config/Code/User/settings.json
	ln -s ~/.dotfiles/Code/snippets/ ~/.config/Code/User/snippets

## ZSH as default shell + Antigen + plugin dependencies
/bin/zsh:
	sudo apt install -y zsh wmctrl xdotool
	sudo chsh -s /bin/zsh

~/.antigen.zsh: /bin/zsh
	curl -L git.io/antigen > ~/.antigen.zsh

~/bin: ./home/bin
	ln -s ~/.dotfiles/home/bin ~/bin
	cd ~/ && for FILE in ~/.dotfiles/home/.*; do ln -s $$FILE . ; done;
