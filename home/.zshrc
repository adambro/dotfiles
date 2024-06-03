# yaourt -S antigen-git
source ~/.antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found
antigen bundle z
antigen bundle kubectl
antigen bundle asdf

# Load the theme.
antigen bundle mafredri/zsh-async@main
antigen bundle dfurnes/purer@main
PURE_PROMPT_SYMBOL_COLOR=blue
PURE_CMD_MAX_EXEC_TIME=10

# Notifies when running command finished. 
antigen bundle t413/zsh-background-notify

antigen bundle zsh-users/zsh-autosuggestions

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you're done.
antigen apply

source ~/.aliases
source ~/.profile
source ~/bin/awsp.bash

# It must be the last
# https://asdf-vm.com/more/faq.html#shell-not-detecting-newly-installed-shims
source $HOME/.asdf/asdf.sh

