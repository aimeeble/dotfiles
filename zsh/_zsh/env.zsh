[[ -d /usr/local/share/python ]] && PATH="/usr/local/share/python:$PATH"
export PATH="$HOME/bin:/usr/local/bin:$PATH"

export VISUAL=vim
export EDITOR=vim
export VIRTUAL_ENV_DISABLE_PROMPT=1
export WORKON_HOME=$HOME/.venvs

# Pull in various other config files
PLATFORMRC="$HOME/.zshenv-`uname -s`"
[ -f "$PLATFORMRC" ] && . "$PLATFORMRC"
LOCALRC="$HOME/.zshenv-local"
[ -f "$LOCALRC" ] && . "$LOCALRC"
