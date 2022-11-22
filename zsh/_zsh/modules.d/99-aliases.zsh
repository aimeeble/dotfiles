
_setup_ls() {
   local LS="ls"
   local LS_OPTS=""

   local HOMEBREW_BASE=""
    if [[ "$SYS" == "Darwin" ]]; then
      if [[ "$ARC" == "arm64" ]]; then
        HOMEBREW_BASE="/opt/homebrew"
      else
        HOMEBREW_BASE="/usr/local"
      fi
    fi

   case `uname -s` in
      "Linux")
         eval `dircolors ~/.dircolorsrc`
         zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
         LS="ls"
         LS_OPTS="--color=auto"
         ;;
      "Darwin"|"FreeBSD")
         if [[ -x "$HOMEBREW_BASE/bin/gdircolors" ]]; then
            eval `$HOMEBREW_BASE/bin/gdircolors ~/.dircolorsrc`
            zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
            LS="gls"
            LS_OPTS="--color=auto"
         else
            # Use built-in ls, but at least enable colors :-)
            export CLICOLOR=1
         fi
         ;;
      *)
         echo "unknown system `uname -s`"
         ;;
   esac

   alias ls="$LS $LS_OPTS"
   alias ll="$LS $LS_OPTS -l"
   alias la="$LS $LS_OPTS -a"
   alias lla="$LS $LS_OPTS -la"

   alias k='kubectl'
   # l. now in fpath
}

_setup_ip() {
  ip --color link &> /dev/null
  if [[ $? != 0 ]]; then
    return
  fi

  alias ip='ip --color'
}

_aliases_init() {
  _setup_ls
  _setup_ip
}

module_add "aliases" _aliases_init
