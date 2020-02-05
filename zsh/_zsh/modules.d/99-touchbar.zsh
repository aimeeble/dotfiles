

_aimee_touchbar_init() {
  module_add_ping _aimee_touchbar_ping
}

_aimee_touchbar_ping() {
  if [[ ! -x "$HOME/.iterm2/it2setkeylabel" ]]; then
    return
  fi

  local PR_MOD_FRAGMENTS
  for pf in $_aimee_mod_fragments; do
      local NEW="$($pf no)"
      PR_MOD_FRAGMENTS="${PR_MOD_FRAGMENTS}${NEW}"
  done
  "$HOME/.iterm2/it2setkeylabel" set status "${PR_MOD_FRAGMENTS}"
}

module_add "MBP Touchbar" _aimee_touchbar_init
