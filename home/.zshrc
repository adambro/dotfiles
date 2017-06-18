# yaourt -S antigen-git
source /usr/share/zsh/share/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

# Load the theme.
antigen bundle dfurnes/purer
PURE_PROMPT_SYMBOL_COLOR=blue
PURE_CMD_MAX_EXEC_TIME=10

# Notifies when running command finished. Dependencies:
# yaourt -S wmctrl xdotool
antigen bundle marzocchi/zsh-notify

antigen bundle zsh-users/zsh-autosuggestions

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you're done.
antigen apply
