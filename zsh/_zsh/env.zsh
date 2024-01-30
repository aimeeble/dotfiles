SYS="$(uname -s)"
ARC="$(uname -m)"

if [[ "$COLORSCHEMES_DIR" =~ "cool-retro-term" ]]; then
  ARC="arm64"
fi
HOMEBREW_BASE=""
if [[ "$SYS" == "Darwin" ]]; then
  if [[ "$ARC" == "arm64" ]]; then
    HOMEBREW_BASE="/opt/homebrew"
  else
    HOMEBREW_BASE="/usr/local"
  fi
fi

_PATH=(
  "$HOME/bin"
)

if [[ -n "$HOMEBREW_BASE" ]]; then
  _PATH+=(
    "$HOMEBREW_BASE/bin"
    "$HOMEBREW_BASE/sbin"
  )
fi
_PATH+=(
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/bin"
  "/usr/sbin"
  "/bin"
  "/sbin"
)
_PATH=(${(u)_PATH[@]})

export PATH=${(pj.:.)_PATH}


export VISUAL=vim
export EDITOR=vim
export VIRTUAL_ENV_DISABLE_PROMPT=1
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export WORKON_HOME=$HOME/.venvs
# make `time` command do fancy output.
TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'
TIMEFMT="$TIMEFMT"'avg shared (code):         %X KB'$'\n'
TIMEFMT="$TIMEFMT"'avg unshared (data/stack): %D KB'$'\n'
TIMEFMT="$TIMEFMT"'total (sum):               %K KB'$'\n'
TIMEFMT="$TIMEFMT"'max memory:                %M MB'$'\n'
TIMEFMT="$TIMEFMT"'page faults from disk:     %F'$'\n'
TIMEFMT="$TIMEFMT"'other page faults:         %R'$'\n'
TIMEFMT="$TIMEFMT"'voln ctx switches (waits): %w'$'\n'
TIMEFMT="$TIMEFMT"'invln ctx switches:        %c'$'\n'
TIMEFMT="$TIMEFMT"'I/O:                       %I/%O'$'\n'
export TIMEFMT

# Pull in various other config files
PLATFORMRC="$HOME/.zshenv-`uname -s`"
[ -f "$PLATFORMRC" ] && . "$PLATFORMRC"
LOCALRC="$HOME/.zshenv-local"
[ -f "$LOCALRC" ] && . "$LOCALRC"
