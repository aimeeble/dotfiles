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
      # unset
      eval "unset ${KEY:1}"
    else
      # set
      eval "$KEY='$VAL'"
    fi
  done
}

# Initializes this module.
tmux_init() {
  precmd_functions+=(precmd_tmux_env_update)
}
