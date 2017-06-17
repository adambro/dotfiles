# yaourt -S antigen-git
source /usr/share/zsh/share/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell

# Notifies when running command finished. Dependencies:
# yaourt -S wmctrl xdotool
antigen bundle marzocchi/zsh-notify

# Tell Antigen that you're done.
antigen apply
