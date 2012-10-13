#
# Aimee's zsh config.
#
# refs:
#   http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
#   https://github.com/erynofwales/dotfiles
#   http://superuser.com/questions/49092/how-to-format-the-path-in-a-zsh-prompt
#   http://aperiodic.net/phil/prompt/
#   http://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
#

echo "interactive"

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
   create_prompt "`zle_get_mode`"
   zle reset-prompt
}

prompt_git_branch() {
   local BRANCH
   BRANCH=`git symbolic-ref HEAD 2>&1 | sed "s/refs\/heads\///"`

   echo "$BRANCH" | grep -qs fatal
   if [ $? -eq 0 ]; then
      return
   else
      if [ -z "$1" ]; then
         print "%B%F{yellow}%{${BRANCH}%}%${#BRANCH}G%f%b "
      else
         echo "${BRANCH} "
      fi
   fi
}

prompt_virtual_env() {
   if [ -z "$VIRTUAL_ENV" ]; then
      return
   fi
   if [ -z "$1" ]; then
      print "%F{red}`basename ${VIRTUAL_ENV}`%f "
   else
      echo "`basename ${VIRTUAL_ENV}` "
   fi
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
      print -P "%F{black}%K{red}$USER%k%f"
   else
      print -P "%B%F{green}$USER%f%b"
   fi
}

create_prompt() {
   local PR_MODE="$1"

   # Initially, grab these w/o color
   local PR_GIT_BRANCH="`prompt_git_branch no`"
   local PR_VIRTUAL_ENV="`prompt_virtual_env no`"
   local PR_USER="`prompt_username no`"

   # Fancy graphics?
   typeset -A altchar
   set -A altchar ${(s::)terminfo[acsc]}
   local PR_SET_CHARSET="%{$terminfo[enacs]%}"
   local PR_SHIFT_IN="%{$terminfo[smacs]%}"
   local PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
   local PR_NW=${altchar[l]:--}
   local PR_NE=${altchar[k]:--}
   local PR_SW=${altchar[m]:--}
   local PR_SE=${altchar[j]:--}
   local PR_BAR=${altchar[q]:--}
   local PR_VBAR=${altchar[x]:-1}

   # Figure out how much padding goes into the prompt
   local PR_WIDTH=$(( $COLUMNS ))
   local PR_LINE1="$(print -P -- '--( ${PR_USER}@%m ${PR_GIT_BRANCH}${PR_VIRTUAL_ENV})--#--( %~ )--' )"
   local PR_LEN=${#PR_LINE1}
   local PR_FILL_LEN=$(( $PR_WIDTH - $PR_LEN ))
   local PR_FILL="\${(l:$PR_FILL_LEN::$PR_BAR:)}"

   # Reset, now with color!
   local PR_GIT_BRANCH="`prompt_git_branch`"
   local PR_VIRTUAL_ENV="`prompt_virtual_env`"
   local PR_USER="`prompt_username`"

   # Finally, set the prompt vars.
   RPS1="%B%F{black}${PR_SHIFT_IN}${PR_BAR}%f%b${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b ${PR_MODE} %B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_SE}${PR_SHIFT_OUT}%f%b"
   RPS2="%B%F{black}${PR_SHIFT_IN}${PR_BAR}%f%b${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b ${PR_MODE} %B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_SE}${PR_SHIFT_OUT}%f%b"

   PS1="${PR_SET_CHARSET}%B%F{black}${PR_SHIFT_IN}${PR_NW}${PR_SHIFT_OUT}%f%b${PR_SHIFT_IN}${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b ${PR_USER}%B%F{green}@%m%f%b ${PR_GIT_BRANCH}${PR_VIRTUAL_ENV}%B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_BAR}${(e)PR_FILL}${PR_BAR}%f%b${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b %B%F{blue}%~%f%b %B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_NE}${PR_SHIFT_OUT}%f%b
%B%F{black}${PR_SHIFT_IN}${PR_SW}%f%b${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b %* !%h %B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_BAR}${PR_SHIFT_OUT}%f%b%# "
   PS2="%B%F{black}${PR_SHIFT_IN}${PR_VBAR}${PR_SHIFT_OUT}%f%b %_> "
   PS3="%B%F{black}${PR_SHIFT_IN}${PR_VBAR}${PR_SHIFT_OUT}%f%b %_> "
}

TRAPWINCH() {
   create_prompt
   zle reset-prompt
}

pre_xterm() {
   print -Pn "\e]0;%n@%m: %~\a"
}

precmd() {
   pre_xterm
   create_prompt "vi-ins"
}

export CLICOLOR=1

# Initialize the prompt and zle
zle -N zle-keymap-select zle_keymap_select
setopt \
   PROMPT_SUBST \
   EXTENDED_GLOB

# Command history
setopt \
   APPEND_HISTORY \
   EXTENDED_HISTORY \
   HIST_FIND_NO_DUPS \
   HIST_IGNORE_SPACE \
   HIST_NO_STORE \
   HIST_REDUCE_BLANKS
HIST_SIZE=1000000
SAVEHIST=1000000
HISTFILE="$HOME/.zsh/history"

# Completion and zle
bindkey -v
create_prompt "vi-ins"
setopt \
   AUTO_REMOVE_SLASH \
   COMPLETE_IN_WORD \
   AUTO_LIST \
   LIST_AMBIGUOUS \
   LIST_TYPES \
   REC_EXACT
# don't cycle completion options
unsetopt \
   MENU_COMPLETE \
   AUTO_MENU
zstyle ':completion:*:ls:*' ignore-line yes

# Python virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1
export WORKON_HOME=$HOME/.venvs
VENV="/usr/local/share/python/virtualenvwrapper.sh"
[ -f $VENV ] && . $VENV

if [[ "$SHELL" != "/bin/zsh" ]]; then
   echo "Warning: shell not set to zsh: '$SHELL'"
fi
