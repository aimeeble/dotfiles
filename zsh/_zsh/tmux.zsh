# If the shell is running in tmux, get the tmux environment variable update
# from the client that attached and update the shell's environment.
precmd_tmux_env_update() {
  if [[ -z "$TMUX" ]]; then
    return
  fi

  typeset -g TMUX_ENV_VARS
  TMUX_ENV_VARS=("${(@f)$(tmux show-environment)}")
  for var in $TMUX_ENV_VARS; do
    if [[ "${var:0:1}" == "-" ]]; then
      # unset
      eval "unset ${var:1}"
    else
      # set
      eval "$var"
    fi
  done
}

# Initializes this module.
tmux_init() {
  precmd_functions+=(precmd_tmux_env_update)
}
