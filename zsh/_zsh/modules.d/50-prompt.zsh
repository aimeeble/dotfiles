. "$HOME/.zsh/colour.zsh"

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
     RC_COLOR_ON="${CL_ERROR_ON}"
     RC_COLOR_OFF="${CL_ERROR_OFF}"
   fi

   # Finally, set the prompt vars. Note: escape ZSH_VI_CMD_MODE so it's
   # evaluated when the prompt is displayed, not now.
   RPS1="%{${PR_SHIFT_IN}%}${CL_SHADED_ON}${PR_BAR}${CL_SHADED_OFF}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}%{${PR_SHIFT_OUT}%}${CL_HIGHLIGHT_ON}(${CL_HIGHLIGHT_OFF} \${ZSH_VI_CMD_MODE} ${CL_HIGHLIGHT_ON})${CL_HIGHLIGHT_OFF}%{${PR_SHIFT_IN}%}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}${CL_SHADED_ON}${PR_SE}${CL_SHADED_OFF}%{${PR_SHIFT_OUT}%}"
   RPS2="%{${PR_SHIFT_IN}%}${CL_SHADED_ON}${PR_BAR}${CL_SHADED_OFF}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}%{${PR_SHIFT_OUT}%}${CL_HIGHLIGHT_ON}(${CL_HIGHLIGHT_OFF} \${ZSH_VI_CMD_MODE} ${CL_HIGHLIGHT_ON})${CL_HIGHLIGHT_OFF}%{${PR_SHIFT_IN}%}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}${CL_SHADED_ON}${PR_SE}${CL_SHADED_OFF}%{${PR_SHIFT_OUT}%}"

   PS1="%{${PR_SET_CHARSET}${PR_SHIFT_IN}%}${CL_SHADED_ON}${PR_NW}${CL_SHADED_OFF}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}%{${PR_SHIFT_OUT}%}${CL_HIGHLIGHT_ON}(${CL_HIGHLIGHT_OFF} ${PR_USER}${CL_HOST_ON}@%2m${CL_HOST_OFF} ${PR_MOD_FRAGMENTS}${CL_HIGHLIGHT_ON})${CL_HIGHLIGHT_OFF}%{${PR_SHIFT_IN}%}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}${CL_SHADED_ON}${PR_BAR}${(e)PR_FILL}${PR_BAR}${CL_SHADED_OFF}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}%{${PR_SHIFT_OUT}%}${CL_HIGHLIGHT_ON}(${CL_HIGHLIGHT_OFF} ${CL_PWD_ON}$(collapse_pwd)${CL_PWD_OFF} ${CL_HIGHLIGHT_ON})${CL_HIGHLIGHT_OFF}%{${PR_SHIFT_IN}%}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}${CL_SHADED_ON}${PR_NE}${CL_SHADED_OFF}%{${PR_SHIFT_OUT}%}
%{${PR_SHIFT_IN}%}${CL_SHADED_ON}${PR_SW}${CL_SHADED_OFF}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}%{${PR_SHIFT_OUT}%}${CL_HIGHLIGHT_ON}(${CL_HIGHLIGHT_OFF} ${RC_COLOR_ON}%* !%h${RC_COLOR_OFF} ${CL_HIGHLIGHT_ON})${CL_HIGHLIGHT_OFF}%{${PR_SHIFT_IN}%}${CL_NORM_ON}${PR_BAR}${CL_NORM_OFF}${CL_SHADED_ON}${PR_BAR}${CL_SHADED_OFF}%{${PR_SHIFT_OUT}%}%# "
   PS2="%{${PR_SHIFT_IN}%}${CL_SHADED_ON}${PR_VBAR}${CL_SHADED_OFF}%{${PR_SHIFT_OUT}%} %_> "
   PS3="%{${PR_SHIFT_IN}%}${CL_SHADED_ON}${PR_VBAR}${CL_SHADED_OFF}%{${PR_SHIFT_OUT}%} %_> "
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
