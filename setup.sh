#!/bin/bash

set -eu -o pipefail

if [[ ! -f "dotfile_support/funcs.sh" ]]; then
  echo "Missing `pwd`/dotfile_support/funcs.sh"
  exit 1
fi
. "dotfile_support/funcs.sh"

link_bash() {
  log1 "link_bash"
  linkit "$CHECKOUT_PATH/bash/_bashrc" "$INSTALL_PATH/.bashrc"
  linkit "$CHECKOUT_PATH/bash/_bashrc.prod" "$INSTALL_PATH/.bashrc.prod"
  linkit "$CHECKOUT_PATH/bash/_git-completion.bash" "$INSTALL_PATH/.git-completion.bash"
  linkit_if_exists "$CHECKOUT_PATH/bash/_bashrc-$SYS" "$INSTALL_PATH/.bashrc-$SYS"
}

link_zsh() {
  log1 "link_zsh"
  linkit "$CHECKOUT_PATH/zsh/_zshrc" "$INSTALL_PATH/.zshrc"
  linkit "$CHECKOUT_PATH/zsh/_zlogin" "$INSTALL_PATH/.zlogin"
  linkit "$CHECKOUT_PATH/zsh/_zlogout" "$INSTALL_PATH/.zlogout"
  linkit "$CHECKOUT_PATH/zsh/_zprofile" "$INSTALL_PATH/.zprofile"
  linkit "$CHECKOUT_PATH/zsh/_zshenv" "$INSTALL_PATH/.zshenv"

  linkit "$CHECKOUT_PATH/zsh/_zsh/env.zsh" "$INSTALL_PATH/.zsh/env.zsh"
  linkit "$CHECKOUT_PATH/zsh/_zsh/interactive.zsh" "$INSTALL_PATH/.zsh/interactive.zsh"
  linkit "$CHECKOUT_PATH/zsh/_zsh/login-post.zsh" "$INSTALL_PATH/.zsh/login-post.zsh"
  linkit "$CHECKOUT_PATH/zsh/_zsh/login-pre.zsh" "$INSTALL_PATH/.zsh/login-pre.zsh"
  linkit "$CHECKOUT_PATH/zsh/_zsh/logout.zsh" "$INSTALL_PATH/.zsh/logout.zsh"
  linkit "$CHECKOUT_PATH/zsh/_zsh/colour.zsh" "$INSTALL_PATH/.zsh/colour.zsh"

  link_all_in_dir "$CHECKOUT_PATH/zsh/_zsh/fpath" "$INSTALL_PATH/.zsh/fpath"
  link_all_in_dir "$CHECKOUT_PATH/zsh/_zsh/modules.d" "$INSTALL_PATH/.zsh/modules.d"

  linkit_if_exists "$CHECKOUT_PATH/zsh/_zshrc-$SYS" "$INSTALL_PATH/.zshrc-$SYS"
  linkit_if_exists "$CHECKOUT_PATH/zsh/_zshenv-$SYS" "$INSTALL_PATH/.zshenv-$SYS"

  make_dir "$INSTALL_PATH/.zsh/history"
  make_dir "$INSTALL_PATH/.zsh/cache"
}

link_vim() {
  log1 "link_vim"
  linkit "$CHECKOUT_PATH/vim/_vimrc" "$INSTALL_PATH/.vimrc"
  linkit "$CHECKOUT_PATH/vim/_vimrc" "$INSTALL_PATH/.gvimrc"
  for i in $CHECKOUT_PATH/vim/autoload/*; do
    BASE=`basename $i`
    linkit "$i" "$INSTALL_PATH/.vim/autoload/$BASE"
  done
  for i in $CHECKOUT_PATH/vim/bundle/*; do
    BASE=`basename $i`
    linkit "$i" "$INSTALL_PATH/.vim/bundle/$BASE"
  done
}

link_nvim() {
  log1 "link_nvim"
  mkdir -p "$INSTALL_PATH/.config/nvim"
  mkdir -p "$INSTALL_PATH/.local/share/nvim/site/autoload"

  linkit "$CHECKOUT_PATH/nvim/init.vim" "$INSTALL_PATH/.config/nvim/init.vim"
  linkit "$CHECKOUT_PATH/nvim/plug.vim" "$INSTALL_PATH/.local/share/nvim/site/autoload/plug.vim"
}

link_screen_mgmt() {
  log1 "link_screen_mgmt"
  linkit "$CHECKOUT_PATH/screen/_screenrc" "$INSTALL_PATH/.screenrc"
  linkit "$CHECKOUT_PATH/tmux/_tmux.conf" "$INSTALL_PATH/.tmux.conf"
}

link_scm() {
  log1 "link_scm"
  linkit "$CHECKOUT_PATH/git/_gitconfig" "$INSTALL_PATH/.gitconfig"
}

link_irssi() {
  log1 "link_irssi"
  linkit "$CHECKOUT_PATH/irssi/trackbar.pl" "$INSTALL_PATH/.irssi/scripts/trackbar.pl"
  linkit "$INSTALL_PATH/.irssi/scripts/trackbar.pl" "$INSTALL_PATH/.irssi/scripts/autorun/trackbar.pl"
}

link_weechat() {
  log1 "link_weechat"

  linkit "$CHECKOUT_PATH/weechat/alias.conf" "$INSTALL_PATH/.weechat/alias.conf"
  linkit "$CHECKOUT_PATH/weechat/charset.conf" "$INSTALL_PATH/.weechat/charset.conf"
  linkit "$CHECKOUT_PATH/weechat/irc.conf" "$INSTALL_PATH/.weechat/irc.conf"
  linkit "$CHECKOUT_PATH/weechat/iset.conf" "$INSTALL_PATH/.weechat/iset.conf"
  linkit "$CHECKOUT_PATH/weechat/logger.conf" "$INSTALL_PATH/.weechat/logger.conf"
  linkit "$CHECKOUT_PATH/weechat/plugins.conf" "$INSTALL_PATH/.weechat/plugins.conf"
  linkit "$CHECKOUT_PATH/weechat/relay.conf" "$INSTALL_PATH/.weechat/replay.conf"
  linkit "$CHECKOUT_PATH/weechat/rmodifier.conf" "$INSTALL_PATH/.weechat/rmodifier.conf"
  linkit "$CHECKOUT_PATH/weechat/script.conf" "$INSTALL_PATH/.weechat/script.conf"
  linkit "$CHECKOUT_PATH/weechat/sec.conf" "$INSTALL_PATH/.weechat/sec.conf"
  linkit "$CHECKOUT_PATH/weechat/weechat.conf" "$INSTALL_PATH/.weechat/weechat.conf"
  linkit "$CHECKOUT_PATH/weechat/xfer.conf" "$INSTALL_PATH/.weechat/xfer.conf"
  linkit "$CHECKOUT_PATH/weechat/trigger.conf" "$INSTALL_PATH/.weechat/trigger.conf"

  linkit "$CHECKOUT_PATH/weechat/ca-certificates.crt" "$INSTALL_PATH/.weechat/ca-certificates.crt"

  # Plugins
  linkit "$CHECKOUT_PATH/weechat/python/notification_center.py" "$INSTALL_PATH/.weechat/python/notification_center.py"
  linkit "$CHECKOUT_PATH/weechat/python/notify.py" "$INSTALL_PATH/.weechat/python/notify.py"
  linkit "$CHECKOUT_PATH/weechat/python/title.py" "$INSTALL_PATH/.weechat/python/title.py"
  linkit "$CHECKOUT_PATH/weechat/python/tmux_env.py" "$INSTALL_PATH/.weechat/python/tmux_env.py"
  linkit "$CHECKOUT_PATH/weechat/python/screen_away.py" "$INSTALL_PATH/.weechat/python/screen_away.py"
  linkit "$CHECKOUT_PATH/weechat/python/flip.py" "$INSTALL_PATH/.weechat/python/flip.py"
  linkit "$CHECKOUT_PATH/weechat/perl/iset.pl" "$INSTALL_PATH/.weechat/perl/iset.pl"

  # Auto-load plugins
  linkit "$CHECKOUT_PATH/weechat/python/title.py" "$INSTALL_PATH/.weechat/python/autoload/title.py"
  linkit "$CHECKOUT_PATH/weechat/python/tmux_env.py" "$INSTALL_PATH/.weechat/python/autoload/tmux_env.py"
  linkit "$CHECKOUT_PATH/weechat/python/screen_away.py" "$INSTALL_PATH/.weechat/python/autoload/screen_away.py"
  linkit "$CHECKOUT_PATH/weechat/python/flip.py" "$INSTALL_PATH/.weechat/python/autoload/flip.py"
  linkit "$CHECKOUT_PATH/weechat/perl/iset.pl" "$INSTALL_PATH/.weechat/perl/autoload/iset.pl"
}

link_bin() {
  log1 "link_bin"
  link_all_in_dir "$CHECKOUT_PATH/bin" "$INSTALL_PATH/bin"
}

link_i3() {
  log1 "link_i3"
  linkit "$CHECKOUT_PATH/i3/_i3/config" "$INSTALL_PATH/.i3/config"
  linkit "$CHECKOUT_PATH/i3/_i3/config.chromoting" "$INSTALL_PATH/.i3/config.chromoting"
  linkit "$CHECKOUT_PATH/i3/_i3/i3status.conf" "$INSTALL_PATH/.i3/i3status.conf"
  linkit "$CHECKOUT_PATH/i3/_i3/statusbar.py" "$INSTALL_PATH/.i3/statusbar.py"
}

link_misc() {
  log1 "link_misc"
  linkit "$CHECKOUT_PATH/mutt/_muttrc" "$INSTALL_PATH/.muttrc"
  linkit "$CHECKOUT_PATH/mutt/_mutt/muttrc" "$INSTALL_PATH/.mutt/muttrc"
  linkit "$CHECKOUT_PATH/mutt/_mutt/crypto" "$INSTALL_PATH/.mutt/crypto"

  linkit "$CHECKOUT_PATH/top/_toprc" "$INSTALL_PATH/.toprc"
  linkit "$CHECKOUT_PATH/dircolors/default.cfg" "$INSTALL_PATH/.dircolorsrc"

  linkit "$CHECKOUT_PATH/gpg/_gnupg/gpg.conf" "$INSTALL_PATH/.gnupg/gpg.conf"
}

link_fonts() {
  log1 "link_fonts"
  if [[ "$(uname -s)" == "Darwin" ]]; then
    copyit "$CHECKOUT_PATH/fonts/source code pro black.ttf" "$INSTALL_PATH/Library/Fonts/source code pro black.ttf"
    copyit "$CHECKOUT_PATH/fonts/source code pro bold.ttf" "$INSTALL_PATH/Library/Fonts/source code pro bold.ttf"
    copyit "$CHECKOUT_PATH/fonts/source code pro extra light.ttf" "$INSTALL_PATH/Library/Fonts/source code pro extra light.ttf"
    copyit "$CHECKOUT_PATH/fonts/source code pro light.ttf" "$INSTALL_PATH/Library/Fonts/source code pro light.ttf"
    copyit "$CHECKOUT_PATH/fonts/source code pro regular.ttf" "$INSTALL_PATH/Library/Fonts/source code pro regular.ttf"
    copyit "$CHECKOUT_PATH/fonts/source code pro semibold.ttf" "$INSTALL_PATH/Library/Fonts/source code pro semibold.ttf"
    copyit "$CHECKOUT_PATH/fonts/Terminus.ttf" "$INSTALL_PATH/Library/Fonts/Terminus.ttf"
    copyit "$CHECKOUT_PATH/fonts/TerminusBold.ttf" "$INSTALL_PATH/Library/Fonts/TerminusBold.ttf"

    copyit "$CHECKOUT_PATH/fonts/Go Mono Bold Italic Nerd Font Complete Mono.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Bold Italic Nerd Font Complete Mono.ttf"
    copyit "$CHECKOUT_PATH/fonts/Go Mono Bold Italic Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Bold Italic Nerd Font Complete.ttf"
    copyit "$CHECKOUT_PATH/fonts/Go Mono Bold Nerd Font Complete Mono.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Bold Nerd Font Complete Mono.ttf"
    copyit "$CHECKOUT_PATH/fonts/Go Mono Bold Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Bold Nerd Font Complete.ttf"
    copyit "$CHECKOUT_PATH/fonts/Go Mono Italic Nerd Font Complete Mono.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Italic Nerd Font Complete Mono.ttf"
    copyit "$CHECKOUT_PATH/fonts/Go Mono Italic Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Italic Nerd Font Complete.ttf"
    copyit "$CHECKOUT_PATH/fonts/Go Mono Nerd Font Complete Mono.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Nerd Font Complete Mono.ttf"
    copyit "$CHECKOUT_PATH/fonts/Go Mono Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Nerd Font Complete.ttf"

    copyit "$CHECKOUT_PATH/fonts/Comic Mono Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Comic Mono Nerd Font Complete.ttf"
    copyit "$CHECKOUT_PATH/fonts/Comic Mono Bold Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Comic Mono Bold Nerd Font Complete.ttf"
  elif [[ "$(uname -s)" == "Linux" ]]; then
    linkit "$CHECKOUT_PATH/fonts/source code pro black.ttf" "$INSTALL_PATH/.fonts/source code pro black.ttf"
    linkit "$CHECKOUT_PATH/fonts/source code pro bold.ttf" "$INSTALL_PATH/.fonts/source code pro bold.ttf"
    linkit "$CHECKOUT_PATH/fonts/source code pro extra light.ttf" "$INSTALL_PATH/.fonts/source code pro extra light.ttf"
    linkit "$CHECKOUT_PATH/fonts/source code pro light.ttf" "$INSTALL_PATH/.fonts/source code pro light.ttf"
    linkit "$CHECKOUT_PATH/fonts/source code pro regular.ttf" "$INSTALL_PATH/.fonts/source code pro regular.ttf"
    linkit "$CHECKOUT_PATH/fonts/source code pro semibold.ttf" "$INSTALL_PATH/.fonts/source code pro semibold.ttf"
    linkit "$CHECKOUT_PATH/fonts/Terminus.ttf" "$INSTALL_PATH/.fonts/Terminus.ttf"
    linkit "$CHECKOUT_PATH/fonts/TerminusBold.ttf" "$INSTALL_PATH/.fonts/TerminusBold.ttf"

    linkit "$CHECKOUT_PATH/fonts/Go Mono Bold Italic Nerd Font Complete Mono.ttf" "$INSTALL_PATH/.fonts/Go Mono Bold Italic Nerd Font Complete Mono.ttf"
    linkit "$CHECKOUT_PATH/fonts/Go Mono Bold Italic Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Go Mono Bold Italic Nerd Font Complete.ttf"
    linkit "$CHECKOUT_PATH/fonts/Go Mono Bold Nerd Font Complete Mono.ttf" "$INSTALL_PATH/.fonts/Go Mono Bold Nerd Font Complete Mono.ttf"
    linkit "$CHECKOUT_PATH/fonts/Go Mono Bold Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Go Mono Bold Nerd Font Complete.ttf"
    linkit "$CHECKOUT_PATH/fonts/Go Mono Italic Nerd Font Complete Mono.ttf" "$INSTALL_PATH/.fonts/Go Mono Italic Nerd Font Complete Mono.ttf"
    linkit "$CHECKOUT_PATH/fonts/Go Mono Italic Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Go Mono Italic Nerd Font Complete.ttf"
    linkit "$CHECKOUT_PATH/fonts/Go Mono Nerd Font Complete Mono.ttf" "$INSTALL_PATH/.fonts/Go Mono Nerd Font Complete Mono.ttf"
    linkit "$CHECKOUT_PATH/fonts/Go Mono Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Go Mono Nerd Font Complete.ttf"

    linkit "$CHECKOUT_PATH/fonts/Comic Mono Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Comic Mono Nerd Font Complete.ttf"
    linkit "$CHECKOUT_PATH/fonts/Comic Mono Bold Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Comic Mono Bold Nerd Font Complete.ttf"
  fi
}

set_preferences() {
  log1 "Setting preferences"
  OS_PREF_SH="${CHECKOUT_PATH}/prefs/${SYS}.sh"

  if [[ -f "${OS_PREF_SH}" ]]; then
    . "${OS_PREF_SH}"
    set_os_prefs
  fi
}

install_packages() {
  if [[ ${INSTALL_PKGS} -eq 0 ]]; then
    return
  fi
  log_always "Installing 3rd-party packages"
  OS_PKG_SH="${CHECKOUT_PATH}/pkgs/${SYS}.sh"
  if [[ -f "${OS_PREF_SH}" ]]; then
    . "${OS_PKG_SH}"
    install_os_packages
  fi
}

umask 077
parse_flags $*
init_submodules

set_preferences

link_bash
link_zsh
link_vim
link_nvim
link_scm
link_screen_mgmt
link_irssi
link_weechat
link_misc
link_bin
link_fonts

install_packages

update_stamp

log_always "${GREEN}dotfile installation complete!${NORM}"
