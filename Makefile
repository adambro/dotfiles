
## Configure development tools.
config: ~/.antigen.zsh ~/.config/Code/User/settings.json ~/bin ~/.npm-global
	dconf load /org/gnome/terminal/ < terminal-profile.cfg

# Install CLI tools for development.
install: /usr/bin/jq /usr/bin/bat /usr/lib/openarena ~/.local/bin/k9s

backup_dotfiles.tgz: ~/.aws ~/.k9s ~/.openarena
	tar czf $@ $^

backup_etc.tgz:
	sudo tar czf $@ /etc

/usr/bin/jq:
	sudo apt install -y curl grep vim jq awscli silversearcher-ag

/snap/bpytop:
	sudo snap install bpytop
	sudo snap connect bpytop:mount-observe
	sudo snap connect bpytop:network-control
	sudo snap connect bpytop:hardware-observe
	sudo snap connect bpytop:system-observe
	sudo snap connect bpytop:process-control
	sudo snap connect bpytop:physical-memory-observe

/usr/bin/npm:
	sudo apt install -y npm

## Setup NPM cache without sudo
## https://docs.npmjs.com/getting-started/fixing-npm-permissions
~/.npm-global: /usr/bin/npm
	mkdir ~/.npm-global
	npm config set prefix '~/.npm-global'
	# make NPM global packages available in PATH
	echo 'export PATH=~/.npm-global/bin:$$PATH' >> ~/.profile

/usr/bin/etckeeper:
	sudo apt install -y etckeeper git curl

/usr/bin/curl: /usr/bin/etckeeper

/usr/bin/code: /usr/bin/curl /usr/bin/etckeeper
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
	sudo mv /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	# APT update repos & install
	sudo apt update
	sudo apt install -y code
	# https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
	sudo sh -c 'echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf'
	sudo etckeeper commit "Allow VS Code (and webpack) to watch many files"

## Use shared VS Code configuration
~/.config/Code/User/settings.json: /usr/bin/code
	mkdir -p ~/.config/Code/User
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

/usr/lib/openarena:
	sudo apt install -y openarena
	# Fix broken 3D engine on Ubuntu 18.04, from https://bugs.launchpad.net/ubuntu/+source/openarena/+bug/1651561/comments/23
	wget http://mirrors.kernel.org/ubuntu/pool/universe/i/ioquake3/ioquake3_1.36+u20160122+dfsg1-1_amd64.deb -O /tmp/ioquake.deb
	cd /tmp && ar x ioquake.deb data.tar.xz && tar Jxf data.tar.xz ./usr/lib/ioquake3/ioquake3
	sudo mv /tmp/usr/lib/ioquake3/ioquake3 /usr/lib/ioquake3/ioquake3

/usr/bin/bat:
	@$(eval VER = 0.17.1)
	wget --quiet https://github.com/sharkdp/bat/releases/download/v$(VER)/bat_$(VER)_amd64.deb
	sudo dpkg -i bat_$(VER)_amd64.deb
	rm bat_$(VER)_amd64.deb


.PHONY: kube
kube: /usr/local/bin/kubectl ~/.local/bin/k9s /usr/local/bin/docker-compose

/usr/local/bin/kubectl:
	$(eval VER = $(shell curl -L -s https://dl.k8s.io/release/stable.txt))
	curl -LO "https://dl.k8s.io/release/$(VER)/bin/linux/amd64/kubectl"
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

~/.local/bin/k9s:
	mkdir -p ~/.local/bin
	@$(eval VER = 0.24.2)
	wget --quiet -O /tmp/k9s.tar.gz https://github.com/derailed/k9s/releases/download/v$(VER)/k9s_Linux_x86_64.tar.gz
	tar xzf /tmp/k9s.tar.gz --directory /tmp k9s
	mv /tmp/k9s $@

/usr/local/bin/docker-compose:
	@$(eval VER = 1.28.5)
	sudo curl -L "https://github.com/docker/compose/releases/download/$(VER)/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
	sudo chmod +x $@
