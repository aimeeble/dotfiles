# If the shell is running in tmux, get the tmux environment variable update
# from the client that attached and update the shell's environment.
precmd_tmux_env_update() {
  if [[ -z "$TMUX" ]]; then
    return
  fi

  typeset -g TMUX_ENV_VARS
  TMUX_ENV_VARS=("${(@f)$(tmux show-environment)}")
  for var in $TMUX_ENV_VARS; do
    KEY="$(echo $var | cut -d'=' -f1)"
    VAL=("${(@)$(echo $var | cut -d'=' -f2)}")
    if [[ "${KEY:0:1}" == "-" ]]; then
      OLDVAL="${(P)${KEY:1}}"
      # unset
      if [[ -n "${OLDVAL}" ]]; then
        print -P "%F{red}Unsetting%f ${KEY:1} (was: '${OLDVAL}')"
        unset "${KEY:1}"
      fi
    else
      OLDVAL="${(P)KEY}"
      # set
      if [[ "${OLDVAL}" != "${VAL}" ]]; then
        print -P "%F{green}Updating%f ${KEY}='${VAL}' (was: '${OLDVAL}')"
        eval "$KEY='$VAL'"
      fi
    fi
  done
}

# Initializes this module.
tmux_init() {
  precmd_functions+=(precmd_tmux_env_update)
}
