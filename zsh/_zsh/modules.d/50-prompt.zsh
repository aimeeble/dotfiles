

_prompt_calculate() {
  # NOTE: this must be first.
  local RC=${_aimee_last_rc:-0}

  if [[ "$ITERM_PROFILE" == "Present" ]]; then
    _basicPrompt "$RC"
    return
  fi

  _fancyPrompt "$RC"
}

_basicPrompt() {
  local RC="$1"

  local PR_MOD_FRAGMENTS
  for pf in $_aimee_mod_fragments; do
    local NEW="$($pf)"
    PR_MOD_FRAGMENTS="${PR_MOD_FRAGMENTS}${NEW}"
  done
  PR_MOD_FRAGMENTS="$(echo "${PR_MOD_FRAGMENTS}" | xargs)"
  if [[ -n "$PR_MOD_FRAGMENTS" ]] then
    PR_MOD_FRAGMENTS="[${PR_MOD_FRAGMENTS}] "
  fi

  PS1="${PR_MOD_FRAGMENTS}%m:%~ %# "
  PS2="%_> "
  PS3="%_> "
}

_fancyPrompt() {
   local RC="$1"

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
   #
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
  _prompt_calculate
  # Redirect errors to /dev/null, since sometimes this gets called when a new
  # xterm is opened and before zsh hits the line editor.
  zle reset-prompt 2> /dev/null
}

_prompt_init() {
   zle -N zle-keymap-select zle_keymap_select
   setopt \
      PROMPT_SUBST \
      EXTENDED_GLOB

   chpwd_functions+=(_prompt_calculate)
   precmd_functions+=(_prompt_calculate)
  _prompt_calculate
}

module_add "Prompt" _prompt_init
