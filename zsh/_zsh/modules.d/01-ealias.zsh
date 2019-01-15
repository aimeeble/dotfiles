# Creates aliases that get replaced with their expansion.
#
# Good for remembering that you are doing something special ;-)
#

typeset -a _ealiases
_ealiases=()

function ealias()
{
  alias $1
  _ealiases+=(${1%%\=*})
}

function _expand-ealias()
{
  if [[ $LBUFFER =~ "(^|[;|&])\s*(${(j:|:)_ealiases})\$" ]]; then
    zle _expand_alias
    zle expand-word
  fi
  zle magic-space
}

_ealias_init() {
  zle -N _expand-ealias

  bindkey -M viins ' '        _expand-ealias
  bindkey -M viins '^ '       magic-space
  bindkey -M isearch " "      magic-space
}

module_add "expanding aliases" _ealias_init
