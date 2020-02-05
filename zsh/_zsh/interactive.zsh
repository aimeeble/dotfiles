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
typeset -ga postexec_functions
typeset -ga chpwd_functions
typeset -ga _aimee_zsh_modules
typeset -ga _aimee_mod_fragments
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

_calculate_prompt() {
   # NOTE: this must be first.
   local RC=$?

   # Fancy graphics?
   typeset -A altchar
   set -A altchar ${(s::)terminfo[acsc]}
   #set -A altchar ()
   local PR_SET_CHARSET="$terminfo[enacs]"
   local PR_SHIFT_IN="$terminfo[smacs]"
   local PR_SHIFT_OUT="$terminfo[rmacs]"
   local PR_NW=${altchar[l]:--}
   local PR_NE=${altchar[k]:--}
   local PR_SW=${altchar[m]:--}
   local PR_SE=${altchar[j]:--}
   local PR_BAR=${altchar[q]:--}
   local PR_VBAR=${altchar[x]:--}

   # Initially, grab these w/o color
   local PR_USER="`prompt_username no`"
   local PR_MOD_FRAGMENTS
   for pf in $_aimee_mod_fragments; do
      local NEW="$($pf no)"
      PR_MOD_FRAGMENTS="${PR_MOD_FRAGMENTS}${NEW}"
   done

   # Figure out how much padding goes into the prompt
   local PR_WIDTH=$(( $COLUMNS ))
   local PR_LINE1="$(print -P -- '--( ${PR_USER}@%2m ${PR_MOD_FRAGMENTS})--#--( $(collapse_pwd) )--' )"
   local PR_LEN=${#PR_LINE1}
   local PR_FILL_LEN=$(( $PR_WIDTH - $PR_LEN ))
   local PR_FILL="\${(l:$PR_FILL_LEN::$PR_BAR:)}"

   # Reset, now with color!
   local PR_USER="`prompt_username`"
   PR_MOD_FRAGMENTS=""
   for pf in $_aimee_mod_fragments; do
      local NEW="$($pf)"
      PR_MOD_FRAGMENTS="${PR_MOD_FRAGMENTS}${NEW}"
   done

   # Based on command status, decide what color the second line appears in
   local RC_COLOR_ON=""
   local RC_COLOR_OFF=""
   if [[ "$RC" -ne "0" ]]; then
     RC_COLOR_ON="%B%F{red}"
     RC_COLOR_OFF="%f%b"
   fi

   # Finally, set the prompt vars. Note: escape ZSH_VI_CMD_MODE so it's
   # evaluated when the prompt is displayed, not now.
   RPS1="%{${PR_SHIFT_IN}%}%B%F{black}${PR_BAR}%f%b${PR_BAR}%{${PR_SHIFT_OUT}%}%B%F{white}(%f%b \${ZSH_VI_CMD_MODE} %B%F{white})%f%b%{${PR_SHIFT_IN}%}${PR_BAR}%B%F{black}${PR_SE}%f%b%{${PR_SHIFT_OUT}%}"
   RPS2="%{${PR_SHIFT_IN}%}%B%F{black}${PR_BAR}%f%b${PR_BAR}%{${PR_SHIFT_OUT}%}%B%F{white}(%f%b \${ZSH_VI_CMD_MODE} %B%F{white})%f%b%{${PR_SHIFT_IN}%}${PR_BAR}%B%F{black}${PR_SE}%f%b%{${PR_SHIFT_OUT}%}"

   PS1="%{${PR_SET_CHARSET}${PR_SHIFT_IN}%}%B%F{black}${PR_NW}%f%b${PR_BAR}%{${PR_SHIFT_OUT}%}%B%F{white}(%f%b ${PR_USER}%B%F{green}@%2m%f%b ${PR_MOD_FRAGMENTS}%B%F{white})%f%b%{${PR_SHIFT_IN}%}${PR_BAR}%B%F{black}${PR_BAR}${(e)PR_FILL}${PR_BAR}%f%b${PR_BAR}%{${PR_SHIFT_OUT}%}%B%F{white}(%f%b %B%F{blue}$(collapse_pwd)%f%b %B%F{white})%f%b%{${PR_SHIFT_IN}%}${PR_BAR}%B%F{black}${PR_NE}%b%f%{${PR_SHIFT_OUT}%}
%{${PR_SHIFT_IN}%}%B%F{black}${PR_SW}%f%b${PR_BAR}%{${PR_SHIFT_OUT}%}%B%F{white}(%f%b ${RC_COLOR_ON}%* !%h${RC_COLOR_OFF} %B%F{white})%f%b%{${PR_SHIFT_IN}%}${PR_BAR}%B%F{black}${PR_BAR}%f%b%{${PR_SHIFT_OUT}%}%# "
   PS2="%{${PR_SHIFT_IN}%}%B%F{black}${PR_VBAR}%f%b%{${PR_SHIFT_OUT}%} %_> "
   PS3="%{${PR_SHIFT_IN}%}%B%F{black}${PR_VBAR}%f%b%{${PR_SHIFT_OUT}%} %_> "
}

TRAPWINCH() {
   # Must re-recreate prompt so it can re-calculate the prompt length with the
   # new term width
   _calculate_prompt
   # Redirect errors to /dev/null, since sometimes this gets called when a new
   # xterm is opened and before zsh hits the line editor.
   zle reset-prompt 2> /dev/null
}

_set_xterm_title() {
   print -Pn "\e]0;%n@%2m: %~\a"
}

setup_hooks() {
   print -P "    Setting up hooks..."
   precmd_functions+=(_set_xterm_title _calculate_prompt)
}

setup_prompt() {
   print -P "    Setting up prompt..."
   zle -N zle-keymap-select zle_keymap_select
   setopt \
      PROMPT_SUBST \
      EXTENDED_GLOB

   chpwd_functions+=(_calculate_prompt)
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

setup_ls() {
   local LS="ls"
   local LS_OPTS=""

   case `uname -s` in
      "Linux")
         eval `dircolors ~/.dircolorsrc`
         zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
         LS="ls"
         LS_OPTS="--color=auto"
         ;;
      "Darwin"|"FreeBSD")
         if [[ -x "/usr/local/bin/gdircolors" ]]; then
            eval `gdircolors ~/.dircolorsrc`
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
   # l. now in fpath
}

setup_vim() {
   if [[ -d "/Applications/MacVim.app" ]]; then
      alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
      alias gvim="/Applications/MacVim.app/Contents/MacOS/Vim -g"
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
setup_prompt
setup_history

print -P "%F{green}Initializing modules...%f"
for mod_name mod_init in ${_aimee_zsh_modules}; do
  print "    $mod_name"
  eval $mod_init
done
print

_check_zsh_is_shell
setup_ls
setup_vim

# Calculate the initial PS1 value.
_calculate_prompt

# Call new-shell hooks
for f in ${preshell_functions}; do
  eval $f
done

# Run anything
if [[ "$1" == "eval" ]]; then
  eval "${(q)@}"
  set --
fi
