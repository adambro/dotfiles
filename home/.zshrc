# yaourt -S antigen-git
source /usr/share/zsh/share/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found
antigen bundle z

# BitBucket integration, requires `ruby` installed
antigen bundle unixorn/bitbucket-git-helpers.plugin.zsh

# Load the theme.
antigen bundle mafredri/zsh-async
antigen bundle dfurnes/purer
PURE_PROMPT_SYMBOL_COLOR=blue
PURE_CMD_MAX_EXEC_TIME=10

# Notifies when running command finished. Dependencies:
# yaourt -S wmctrl xdotool
antigen bundle marzocchi/zsh-notify
zstyle ':notify:*' error-icon dialog-error
zstyle ':notify:*' success-icon dialog-information

antigen bundle zsh-users/zsh-autosuggestions

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you're done.
antigen apply

source ~/.aliases

# Fix a problem with CWD on Tilix and Gnome Terminal
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

