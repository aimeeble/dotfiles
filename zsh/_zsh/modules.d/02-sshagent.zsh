
_sshagent_preshell() {
  typeset -g SSH_AUTH_SOCK

  if [[ -n "$SSH_AUTH_SOCK" && -n "$SSH_CLIENT" ]]; then
    print -P "%F{green}SSH agent:%f forwarded over SSH..."
  elif [[ -n "$SSH_AGENT_PID" ]]; then
    print -P "%F{green}SSH agent:%f reattaching to PID..."
  elif [[ -e "$HOME/.ssh/agent-$(hostname)" ]]; then
    print -P "%F{green}SSH agent:%f reattaching to UDS..."
    export SSH_AUTH_SOCK="$HOME/.ssh/agent-$(hostname)"
  else
    ENV="$(ssh-agent -a $HOME/.ssh/agent-$(hostname))"
    if [[ $? -ne 0 ]]; then
      print -P "%F{red}SSH agent:%f failed to launch."
      return
    fi
    eval "$ENV"
  fi

  ssh-add -l
}

_sshagent_init() {
  preshell_functions+=(_sshagent_preshell)
}

module_add "SSH Agent" _sshagent_init
