
_sshagent_preshell() {
  typeset -g SSH_AUTH_SOCK
  typeset -l NEEDS_LAUNCH

  if [[ -n "$SSH_AUTH_SOCK" && -n "$SSH_CLIENT" ]]; then
    print -P "%F{green}SSH agent:%f forwarded over SSH..."
  elif [[ -n "$SSH_AGENT_PID" ]]; then
    print -P "%F{green}SSH agent:%f reattaching to PID..."
  elif [[ -n "$SSH_AUTH_SOCK" ]]; then
    print -P "%F{green}SSH agent:%f reattaching to UDS (system)..."
  elif [[ -e "$HOME/.ssh/agent-$(hostname)" ]]; then
    print -P "%F{green}SSH agent:%f reattaching to UDS (custom)..."
    export SSH_AUTH_SOCK="$HOME/.ssh/agent-$(hostname)"
    ssh-add -l >/dev/null 2>&1
    if [[ $$? -ne 0 ]]; then
      rm "$SSH_AUTH_SOCK"
      NEEDS_LAUNCH=1
    fi
  else
    NEEDS_LAUNCH=1
  fi

  if [[ -n "$NEEDS_LAUNCH" ]]; then
    print -P "%F{green}SSH agent:%f launching new instance..."
    ENV="$(ssh-agent -a $HOME/.ssh/agent-$(hostname))"
    if [[ $? -ne 0 ]]; then
      print -P "%F{red}SSH agent:%f failed to launch."
      return
    fi
    eval "$ENV"
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
