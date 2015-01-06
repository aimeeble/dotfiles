# If the shell is running in tmux, get the tmux environment variable update
# from the client that attached and update the shell's environment.
precmd_tmux_env_update() {
  if [[ -z "$TMUX" ]]; then
    return
  fi


  local FORCE
  if [[ -n "$1" ]]; then
    FORCE="yes"
  fi

  local CURRENT_TMUX_CLIENT
  CURRENT_TMUX_CLIENT=$(tmux display-message -p '#{client_tty}')

  if [[ -n "$LAST_TMUX_CLIENT" && "$CURRENT_TMUX_CLIENT" != "$LAST_TMUX_CLIENT" ]]; then
    print -P "%F{yellow}Client changed--updating all vars%f"
    FORCE="yes"
  fi
  LAST_TMUX_CLIENT=$CURRENT_TMUX_CLIENT

  typeset -l TMUX_ENV_VARS
  TMUX_ENV_VARS=("${(@f)$(tmux show-environment)}")
  for var in $TMUX_ENV_VARS; do
    KEY="$(echo $var | cut -d'=' -f1)"
    VAL=("${(@)$(echo $var | cut -d'=' -f2-)}")
    if [[ "${KEY:0:1}" == "-" ]]; then
      OLDVAL="${(P)${KEY:1}}"
      # unset
      if [[ -n "${OLDVAL}" || -n "$FORCE" ]]; then
        print -P "%F{red}Unsetting%f ${KEY:1} (was: '${OLDVAL}')"
        unset "${KEY:1}"
      fi
    else
      OLDVAL="${(P)KEY}"
      # set
      if [[ "${OLDVAL}" != "${VAL}" || -n "$FORCE" ]]; then
        print -P "%F{green}Updating%f ${KEY}='${VAL}' (was: '${OLDVAL}')"
        eval export "$KEY='$VAL'"
      fi
    fi
  done
}

# Initializes this module.
tmux_init() {
  precmd_functions+=(precmd_tmux_env_update)
}
