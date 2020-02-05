

_aimee_touchbar_init() {
  module_add_ping _aimee_touchbar_ping
}

_aimee_touchbar_ping() {
  if [[ ! -x "$HOME/.iterm2/it2setkeylabel" ]]; then
    return
  fi

  local TBAR_TEXT
  if [[ -n "$TMUX" ]]; then
    TBAR_TEXT="tmux:$(tmux display-message -p '#S')"
  fi

  local FRAGS
  for pf in $_aimee_mod_fragments; do
      local NEW="$($pf no)"
      FRAGS="${FRAGS}${NEW}"
  done
  if [[ -n "$FRAGS" ]]; then
    TBAR_TEXT="${TBAR_TEXT}    ${FRAGS}"
  fi

  "$HOME/.iterm2/it2setkeylabel" set status "${TBAR_TEXT}"
}

module_add "MBP Touchbar" _aimee_touchbar_init
