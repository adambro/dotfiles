CREDENTIALS := ~/.aws ~/.ssh ~/.kube/config ~/.osprey ~/.config/git
RM := rm -r -i # Change -i to -f when really need to wipe data.

help: ## Display targets with comments.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z._-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: config install kube apps ## Do all is needed for new laptop.

config: /usr/bin/etckeeper ~/.antigen.zsh ~/.config/Code/User ~/bin ~/.npm-global ## Config system and tools.
	dconf load /org/gnome/terminal/ < terminal-profile.cfg

install: /usr/bin/etckeeper /usr/bin/jq /usr/bin/bat ## Install CLI tools.

apps: /usr/bin/dropbox /snap/btop /usr/bin/epiphany-browser /snap/obsidian ~/.local/bin/dasel /usr/bin/espanso ## Install GUI apps.

kube: /usr/bin/curl ~/.local/bin/kubectl ~/.krew ~/.local/bin/kubecolor ~/.local/bin/k9s ~/.local/bin/helm ## Install Kubernetes CLI tools.

cleanup: backup_dotfiles.tgz ## Remove sensitive data in dotfiles.
	# Browsers synced via cloud, no need for local backup.
	$(RM) ~/.mozilla ~/.config/google-chrome
	dropbox stop && $(RM) ~/Dropbox
	$(RM) $(CREDENTIALS)

backup: backup_dotfiles.tgz backup_etc.tgz ## Backup of (some) dotfiles and /etc dir.

.PHONY: help all config install apps kube cleanup backup


backup_dotfiles.tgz: $(CREDENTIALS) ~/.z ~/.zsh_history ~/.k9s ~/.local/share/gnome-shell ~/.openarena ~/.local/share/epiphany ~/.netrc
	tar czf $@ $^

backup_etc.tgz:
	sudo tar czf $@ /etc

/usr/bin/jq:
	sudo apt install -y curl grep vim jq awscli silversearcher-ag

# Install Web browser with plugins for videos.
/usr/bin/epiphany-browser:
	sudo apt install epiphany-browser gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad

/usr/bin/dropbox:
	echo "deb [arch=i386,amd64] http://linux.dropbox.com/ubuntu disco main" | sudo tee /etc/apt/sources.list.d/dropbox.list
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
	# APT update repos & install
	sudo apt update
	sudo apt install -y dropbox

/snap/btop:
	sudo snap install slack --classic
	sudo snap install btop foliate spotify teams
	sudo snap connect btop:mount-observe
	sudo snap connect btop:network-observe
	sudo snap connect btop:hardware-observe
	sudo snap connect btop:system-observe
	sudo snap connect btop:process-control
	sudo snap connect btop:physical-memory-observe

/snap/obsidian:
	sudo snap install obsidian
	ln -s ~/.config/google-chrome ~/snap/obsidian/current/.config/google-chrome
	ln -s ~/.config/mimeapps.list ~/snap/obsidian/current/.config/mimeapps.list

/usr/bin/espanso:
	$(eval URL = $(shell curl -sSLf https://api.github.com/repos/espanso/espanso/releases/latest | jq -r .name))
	curl -sL -o /tmp/espanso-debian-wayland-amd64.deb https://github.com/federico-terzi/espanso/releases/download/$(VER)/espanso-debian-wayland-amd64.deb
	sudo apt install -y /tmp/espanso-debian-wayland-amd64.deb
	sudo setcap "cap_dac_override+p" $$(which espanso)
	# Register espanso as a systemd service (required only once)
	espanso service register
	# Start in SystemD managed mode
	espanso start

/usr/bin/npm:
	curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt install -y nodejs

## Setup NPM cache without sudo
## https://docs.npmjs.com/getting-started/fixing-npm-permissions
~/.npm-global: /usr/bin/npm
	mkdir -p ~/.npm-global
	npm config set prefix '~/.npm-global'
	# make NPM global packages available in PATH
	echo 'export PATH=~/.npm-global/bin:$$PATH' >> ~/.profile

/usr/bin/etckeeper:
	sudo apt install -y etckeeper git curl

# To be used as dependency for other targets.
.PHONY: curl
curl: /usr/bin/curl

/usr/bin/curl:
	sudo apt install -y curl

/etc/sysctl.d/88-max_user_watches.conf: curl
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
	sudo mv /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	# APT update repos & install
	sudo apt update
	sudo apt install -y code
	# https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
	sudo sh -c 'echo "# https://code.visualstudio.com/docs/setup/linux#_common-questions" > $@'
	sudo sh -c 'echo fs.inotify.max_user_watches=524288 >> $@'
	sudo etckeeper commit "Allow VS Code (and webpack) to watch many files"

## Use shared VS Code configuration
~/.config/Code/User: /etc/sysctl.d/88-max_user_watches.conf
	mkdir -p $@
	ln -s ~/.dotfiles/Code/settings.json ~/.config/Code/User/settings.json
	ln -s ~/.dotfiles/Code/snippets/ ~/.config/Code/User/snippets
	touch -m $@

## ZSH as default shell + Antigen + plugin dependencies
/bin/zsh:
	sudo apt install -y zsh wmctrl xdotool
	chsh -s /bin/zsh

~/.antigen.zsh: /bin/zsh curl
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

/usr/bin/bat: curl
	$(eval VER = $(shell curl -L -s https://raw.githubusercontent.com/sharkdp/bat/master/Cargo.toml | grep version -m 1 | grep -Po "(\d+\.)+\d+"))
	curl -sL -o /tmp/bat.deb https://github.com/sharkdp/bat/releases/download/v$(VER)/bat_$(VER)_amd64.deb
	sudo dpkg -i /tmp/bat.deb


~/.local/bin/dasel: curl
	mkdir -p ~/.local/bin
	$(eval URL = $(shell curl -sSLf https://api.github.com/repos/tomwright/dasel/releases/latest | grep browser_download_url | grep 'linux_amd64"' | cut -d\" -f 4))
	curl -sL "$(URL)" -o $@
	chmod +x $@

~/.local/bin/kubectl: curl
	mkdir -p ~/.local/bin
	$(eval VER = $(shell curl -L -s https://dl.k8s.io/release/stable.txt))
	curl -sL "https://dl.k8s.io/release/$(VER)/bin/linux/amd64/kubectl" -o $@
	chmod +x $@

~/.krew:
	curl -o /tmp/krew.tar.gz -fsSL "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-linux_amd64.tar.gz"
	tar xzvf /tmp/krew.tar.gz
	./krew-linux_amd64 install krew
	echo 'export PATH=~"$${PATH}:$${HOME}/.krew/bin"' >> ~/.profile

~/.local/bin/kubecolor:
	mkdir -p ~/.local/bin
	@$(eval VER = 0.0.20)
	curl -sL -o /tmp/kubecolor.tar.gz https://github.com/hidetatz/kubecolor/releases/download/v$(VER)/kubecolor_$(VER)_Linux_x86_64.tar.gz
	tar xzf /tmp/kubecolor.tar.gz --directory /tmp kubecolor
	mv /tmp/kubecolor $@

~/.local/bin/k9s: curl
	mkdir -p ~/.local/bin
	$(eval VER = $(shell curl -L -s https://raw.githubusercontent.com/derailed/k9s/master/Makefile | grep -Po "v(\d+\.)+\d+"))
	curl -sL -o /tmp/k9s.tar.gz https://github.com/derailed/k9s/releases/download/$(VER)/k9s_Linux_x86_64.tar.gz
	tar xzf /tmp/k9s.tar.gz --directory /tmp k9s
	mv /tmp/k9s $@

~/.local/bin/helm: curl
	mkdir -p ~/.local/bin
	@$(eval VER = v3.6.2)
	curl -sL -o /tmp/helm.tar.gz https://get.helm.sh/helm-$(VER)-linux-amd64.tar.gz
	tar xzf /tmp/helm.tar.gz --directory /tmp linux-amd64/helm
	mv /tmp/linux-amd64/helm $@

~/.local/bin/docker-compose: curl
	@$(eval VER = 1.29.2)
	curl -sL -o $@ "https://github.com/docker/compose/releases/download/$(VER)/docker-compose-Linux-x86_64"
	sudo chmod +x $@

