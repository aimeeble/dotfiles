
_sshagent_maybe_launch() {
  typeset -g SSH_AUTH_SOCK

  # Test that some combo of SSH_AUTH_SOCK/SSH_AGENT_PID works.
  ssh-add -l >/dev/null 2>&1
  if [[ $? -ne 2 ]]; then
    # It's running (possibly with no keys).
    return 42
  fi

  if [[ -S "$SSH_AUTH_SOCK" ]]; then
    rm "$SSH_AUTH_SOCK"
    unset SSH_AUTH_SOCK
  fi

  print -P "%F{green}SSH agent:%f launching new instance..."
  ENV="$(ssh-agent -a "$HOME/.ssh/agent-$(hostname)")"
  if [[ $? -ne 0 ]]; then
    print -P "%F{red}SSH agent:%f failed to launch."
    return 1
  fi
  eval "$ENV"
}

_sshagent_preshell() {
  typeset -g SSH_AUTH_SOCK
  typeset WANT_SSH_AUTH_SOCK
  WANT_SSH_AUTH_SOCK="$HOME/.ssh/agent-$(hostname)"

  if [[ -n "$SSH_AUTH_SOCK" && -n "$SSH_CLIENT" ]]; then
    _sshagent_maybe_launch
    if [[ $? -eq 42 ]]; then
      print -P "%F{green}SSH agent:%f forwarded over SSH..."
    fi
  elif [[ -n "$SSH_AGENT_PID" ]]; then
    _sshagent_maybe_launch
    if [[ $? -eq 42 ]]; then
      print -P "%F{green}SSH agent:%f reattaching to PID..."
    fi
  elif [[ -n "$SSH_AUTH_SOCK" ]]; then
    _sshagent_maybe_launch
    if [[ $? -eq 42 ]]; then
      print -P "%F{green}SSH agent:%f reattaching to UDS (system)..."
    fi
  elif [[ -S "${WANT_SSH_AUTH_SOCK}" ]]; then
    export SSH_AUTH_SOCK="${WANT_SSH_AUTH_SOCK}"
    _sshagent_maybe_launch
    if [[ $? -eq 42 ]]; then
      print -P "%F{green}SSH agent:%f reattaching to UDS (custom)..."
    fi
  else
    print -P "%F{red}SSH agent not detected.%f"
    _sshagent_maybe_launch
  fi

  if [[ "$(uname -s)" == "Darwin" ]]; then
    ssh-add --apple-load-keychain >/dev/null 2>&1
  fi
  ssh-add -l
}

_sshagent_init() {
  preshell_functions+=(_sshagent_preshell)
}

module_add "SSH Agent" _sshagent_init
