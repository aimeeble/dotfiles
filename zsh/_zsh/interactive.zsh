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

typeset -ga precmd_functions
typeset -ga preexec_functions
typeset -ga postexec_functions
typeset -ga chpwd_functions
export ZSH_VI_CMD_MODE="vi-ins"

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
   # Initially, grab these w/o color
   local PR_GIT_BRANCH="`prompt_git_branch no`"
   local PR_VIRTUAL_ENV="`prompt_virtual_env no`"
   local PR_USER="`prompt_username no`"
   local PR_ERRORS="`get_prompt_errors no`"

   # Fancy graphics?
   typeset -A altchar
   set -A altchar ${(s::)terminfo[acsc]}
   #altchar=()
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
   local PR_LINE1="$(print -P -- '--( ${PR_USER}@%m ${PR_GIT_BRANCH}${PR_VIRTUAL_ENV}${PR_ERRORS})--#--( %~ )--' )"
   local PR_LEN=${#PR_LINE1}
   local PR_FILL_LEN=$(( $PR_WIDTH - $PR_LEN ))
   local PR_FILL="\${(l:$PR_FILL_LEN::$PR_BAR:)}"

   # Reset, now with color!
   local PR_GIT_BRANCH="`prompt_git_branch`"
   local PR_VIRTUAL_ENV="`prompt_virtual_env`"
   local PR_USER="`prompt_username`"
   local PR_ERRORS="`get_prompt_errors`"

   # Finally, set the prompt vars. Note: escape ZSH_VI_CMD_MODE so it's
   # evaluated when the prompt is displayed, not now.
   RPS1="%B%F{black}${PR_SHIFT_IN}${PR_BAR}%f%b${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b \${ZSH_VI_CMD_MODE} %B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_SE}${PR_SHIFT_OUT}%f%b"
   RPS2="%B%F{black}${PR_SHIFT_IN}${PR_BAR}%f%b${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b \${ZSH_VI_CMD_MODE} %B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_SE}${PR_SHIFT_OUT}%f%b"

   PS1="${PR_SET_CHARSET}%B%F{black}${PR_SHIFT_IN}${PR_NW}${PR_SHIFT_OUT}%f%b${PR_SHIFT_IN}${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b ${PR_USER}%B%F{green}@%m%f%b ${PR_GIT_BRANCH}${PR_VIRTUAL_ENV}${PR_ERRORS}%B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_BAR}${(e)PR_FILL}${PR_BAR}%f%b${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b %B%F{blue}%~%f%b %B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_NE}${PR_SHIFT_OUT}%f%b
%B%F{black}${PR_SHIFT_IN}${PR_SW}%f%b${PR_BAR}${PR_SHIFT_OUT}%B%F{white}(%f%b %* !%h %B%F{white})%f%b${PR_SHIFT_IN}${PR_BAR}%B%F{black}${PR_BAR}${PR_SHIFT_OUT}%f%b%# "
   PS2="%B%F{black}${PR_SHIFT_IN}${PR_VBAR}${PR_SHIFT_OUT}%f%b %_> "
   PS3="%B%F{black}${PR_SHIFT_IN}${PR_VBAR}${PR_SHIFT_OUT}%f%b %_> "
}

TRAPWINCH() {
   # Must re-recreate prompt so it can re-calculate the prompt length with the
   # new term width
   create_prompt
   # Redirect errors to /dev/null, since sometimes this gets called when a new
   # xterm is opened and before zsh hits the line editor.
   zle reset-prompt 2> /dev/null
}

pre_xterm() {
   print -Pn "\e]0;%n@%m: %~\a"
}

setup_hooks() {
   precmd_functions+=(pre_xterm)
}

setup_keybindings() {
   # vi-mode
   bindkey -v
   bindkey -M viins 'jj' vi-cmd-mode
   # ...but keep ^R for searching command history
   bindkey '^R' history-incremental-search-backward

   # Fix some stuff that Debian distros like to mess with. Basically, it likes
   # to set vi-up-line-or-history, which places the cursor at the beginning of
   # the line. I prefer having the cursor at the end of the line.
   #
   # Ref: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=383737
   #
   (( ${+terminfo[cuu1]}  )) && bindkey -M viins "$terminfo[cuu1]" up-line-or-history
   (( ${+terminfo[kcuu1]} )) && bindkey -M viins "$terminfo[kcuu1]" up-line-or-history
   [[ "${terminfo[kcuu1]:-}" == "O"* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-history
   (( ${+terminfo[kcud1]} )) && bindkey -M viins "$terminfo[kcud1]" down-line-or-history
   [[ "${terminfo[kcud1]:-}" == "O"* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-history

   # VIM-style backspace (delete back beyond the start of insert mode)
   zle -A .backward-delete-char vi-backward-delete-char

   # Open command line in $EDITOR when pressing v
   zle -N edit-command-line
   bindkey -M vicmd v edit-command-line
}

prompt_preexec() {
  if [[ "$1" =~ "git.*(checkout)|(reset)|(rebase)" ]]; then
    __GIT_REPROMPT=1
  fi
}
prompt_precmd() {
  if [[ -n "$__GIT_REPROMPT" ]]; then
    create_prompt
    unset __GIT_REPROMPT
  fi
}

setup_prompt() {
   zle -N zle-keymap-select zle_keymap_select
   setopt \
      PROMPT_SUBST \
      EXTENDED_GLOB

   chpwd_functions+=(create_prompt)
   preexec_functions+=(prompt_preexec)
   precmd_functions+=(prompt_precmd)
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

setup_history() {
   setopt \
      APPEND_HISTORY \
      EXTENDED_HISTORY \
      HIST_FIND_NO_DUPS \
      HIST_IGNORE_SPACE \
      HIST_NO_STORE \
      HIST_REDUCE_BLANKS
   HISTSIZE=1000000
   SAVEHIST=1000000
   HISTFILE="$HOME/.zsh/history/$HOST.history"
}

setup_ls() {
   local LS="ls"
   local LS_OPTS=""

   case `uname -s` in
      "Linux")
         LS="ls"
         LS_OPTS="--color=auto"
         ;;
      "Darwin")
         if [[ -x "/usr/local/bin/gdircolors" ]]; then
            eval `gdircolors`
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

setup_virtualenv() {
   # Python virtualenv
   local VENV="/usr/local/share/python/virtualenvwrapper.sh"
   [ -f $VENV ] && . $VENV
}

setup_local_config() {
   # Pull in various other config files
   PLATFORMRC="$HOME/.zshrc-`uname -s`"
   [ -f "$PLATFORMRC" ] && . "$PLATFORMRC"
   LOCALRC="$HOME/.zshrc-local"
   [ -f "$LOCALRC" ] && . "$LOCALRC"
}

setup_warnings() {
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

# Bah, these are somewhat needed by other modules...
setup_functions
setup_completion

# Import modules
source ~/.zsh/errors.zsh && errors_init
source ~/.zsh/tmux.zsh && tmux_init

setup_hooks
setup_keybindings
setup_prompt
setup_history
setup_ls
setup_vim
setup_virtualenv
setup_warnings

create_prompt
