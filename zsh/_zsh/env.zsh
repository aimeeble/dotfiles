echo "env"

export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Pull in various other config files
PLATFORMRC="$HOME/.zshenv-`uname -s`"
[ -f "$PLATFORMRC" ] && . "$PLATFORMRC"
LOCALRC="$HOME/.zshenv-local"
[ -f "$LOCALRC" ] && . "$LOCALRC"
