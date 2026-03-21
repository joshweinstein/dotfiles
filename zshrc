# Keep PATH entries unique even when multiple startup files prepend paths.
typeset -U path PATH

. ~/bin/dotfiles/zsh/config
. ~/bin/dotfiles/zsh/aliases
. ~/bin/dotfiles/zsh/env

export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "/Users/josh/.bun/_bun" ] && source "/Users/josh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
