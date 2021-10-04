#
# Aimee's zsh config.
#
# refs:
#   http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
#   https://github.com/erynofwales/dotfiles
#   http://superuser.com/questions/49092/how-to-format-the-path-in-a-zsh-prompt
#   http://aperiodic.net/phil/prompt/
#   http://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
#   http://zsh.sourceforge.net/Guide/zshguide06.html
#   http://www.xsteve.at/prg/zsh/.zshrc
#   http://grml.org/zsh/zsh-lovers.html
#

typeset -ga preshell_functions
typeset -ga precmd_functions
typeset -ga preexec_functions
typeset -ga chpwd_functions
typeset -ga _aimee_zsh_modules
typeset -ga _aimee_mod_fragments
typeset -ga _aimee_mod_pings
typeset -g _aimee_last_rc
export ZSH_VI_CMD_MODE="vi-ins"

MODDIR="$HOME/.zsh/modules.d"

zle_get_mode() {
   case "$KEYMAP" in
      "main"|"viins")
         echo "vi-ins"
         ;;
      "vicmd")
         echo "vi-cmd"
         ;;
   esac
}

zle_keymap_select() {
   ZSH_VI_CMD_MODE=`zle_get_mode`
   zle reset-prompt
}

prompt_username() {
   if [[ "$USER" == "aimeeble" ]]; then
      return
   fi

   if [ -n "$1" ]; then
      echo "$USER"
      return
   fi

   if [[ "$USER" == "root" ]]; then
      print "%F{black}%K{red}$USER%k%f"
   else
      print "%B%F{green}$USER%f%b"
   fi
}

collapse_pwd() {
    local MYPWD="$(print -P %~)"
    local MAX=$(( $COLUMNS / 4 ))
    if [[ $#MYPWD -gt $MAX ]]; then
        MAX=$(( $MAX - 3 ))
        MYPWD="...${(l:$MAX:)${MYPWD}}"
    fi
    echo $MYPWD
}

_set_xterm_title() {
   print -Pn "\e]0;%n@%2m: %~\a"
}

_module_ping() {
  for mp in $_aimee_mod_pings; do
    $mp
  done
}

_capture_exit_status() {
  _aimee_last_rc=$?
}

setup_hooks() {
   print -P "    Setting up hooks..."
   precmd_functions+=(_capture_exit_status _set_xterm_title _module_ping)
}

setup_completion() {
   # Load up completion
   autoload -U compinit
   compinit

   # Completion options and zle
   setopt \
      AUTO_REMOVE_SLASH \
      COMPLETE_IN_WORD \
      AUTO_LIST \
      LIST_AMBIGUOUS \
      LIST_TYPES
   # don't cycle completion options
   unsetopt \
      MENU_COMPLETE \
      AUTO_MENU

   zstyle ':completion:*' use-cache on
   zstyle ':completion:*' cache-path "$HOME/.zsh/cache/$HOST.cache"

   # Colorize the PID and give menu selection for kill auto-completion.
   zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
   zstyle ':completion:*:*:kill:*' menu yes select
   zstyle ':completion:*:processes' command 'ps -aU$USER'

   zstyle ':completion:*' squeeze-slashes 'yes'

   #zstyle ':completion:*:cd:*' ignore-parents parent pwd

   # Highlight matched part in completion list
   zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==33=00}:${(s.:.)LS_COLORS}")'
}

up-line-or-local-history() {
  zle set-local-history 1
  zle up-line-or-history
  zle set-local-history 0
}
down-line-or-local-history() {
  zle set-local-history 1
  zle down-line-or-history
  zle set-local-history 0
}

setup_history() {
   print "    Setting up history..."

   setopt \
      APPEND_HISTORY \
      INC_APPEND_HISTORY \
      EXTENDED_HISTORY \
      SHARE_HISTORY \
      HIST_FIND_NO_DUPS \
      HIST_IGNORE_SPACE \
      HIST_NO_STORE \
      HIST_REDUCE_BLANKS
   HISTSIZE=1000000
   SAVEHIST=1000000
   HISTFILE="$HOME/.zsh/history/$HOST.history"

   zle -N up-line-or-local-history
   zle -N down-line-or-local-history
}

setup_vim() {
   if [[ -d "/Applications/MacVim.app" ]]; then
      alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
      alias gvim="/Applications/MacVim.app/Contents/MacOS/Vim -g"
   fi
   if [[ -f "$HOME/bin/nvim.appimage" ]]; then
     alias nvim="$HOME/bin/nvim.appimage"
   fi
   # TODO(aimeeble) find the homebrew version if it exists
}

setup_local_config() {
   # Pull in various other config files
   PLATFORMRC="$HOME/.zshrc-`uname -s`"
   [ -f "$PLATFORMRC" ] && . "$PLATFORMRC"
   LOCALRC="$HOME/.zshrc-local"
   [ -f "$LOCALRC" ] && . "$LOCALRC"
}

_check_zsh_is_shell() {
   if [[ ! "$SHELL" =~ "zsh" ]]; then
      echo "Warning: shell not set to zsh: '$SHELL'"
   fi
}

setup_functions() {
   if [[ -d "/usr/local/share/zsh-completions" ]]; then
      fpath=("/usr/local/share/zsh-completions" $fpath)
   fi
   fpath=("$HOME/.zsh/fpath"  $fpath)
   for file in $HOME/.zsh/fpath/*; do
      local fun="`basename $file`"
      autoload "$fun"
   done

   autoload -U edit-command-line
}

##############################################################################
# zsh module management functions

module_add() {
  if [[ $# -ne 2 ]]; then
    echo "usage: module_add MOD_NAME INIT_FUNCTION"
    return 1
  fi
  typeset -la mod
  mod=("$1" "$2")
  _aimee_zsh_modules+=($mod)
}

module_add_prompt_fragment() {
  if [[ $# -ne 1 ]]; then
    echo "usage: module_add_prompt_fragment FUNCTION"
    return 1
  fi
  _aimee_mod_fragments+=($1)
}

module_add_ping() {
  if [[ $# -ne 1 ]]; then
    echo "usage: module_add_ping FUNCTION"
    return 1
  fi
  _aimee_mod_pings+=($1)
}

##############################################################################
# Load up modules. First, add the internal/core modules. Then, find all the
# modules in the add-on directory and load all of them.

# Early internal support modules.
module_add "zsh fpath functions"  setup_functions
module_add "completions"          setup_completion

# Load modules from the dynamic module directory.
if [[ -d "$MODDIR" ]]; then
  for mod in ${MODDIR}/*.zsh; do
    source $mod
  done
fi

##############################################################################
# Done with the core support code. Now do actual initialization of the shell
# environment.

print -P "%F{green}Initializing core...%f"
setup_hooks
setup_history

print -P "%F{green}Initializing modules...%f"
for mod_name mod_init in ${_aimee_zsh_modules}; do
  print "    $mod_name"
  eval $mod_init
done
print

_check_zsh_is_shell
setup_vim

# Call new-shell hooks
for f in ${preshell_functions}; do
  eval $f
done

# Run anything
if [[ "$1" == "eval" ]]; then
  eval "${(q)@}"
  set --
fi
