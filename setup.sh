#!/bin/bash

set -eu -o pipefail

if [[ ! -f "dotfile_support/funcs.sh" ]]; then
  echo "Missing `pwd`/dotfile_support/funcs.sh"
  exit 1
fi
. "dotfile_support/funcs.sh"

link_bash() {
  log1 "link_bash"
  linkit "$DOTFILE_PATH/bash/_bashrc" "$INSTALL_PATH/.bashrc"
  linkit "$DOTFILE_PATH/bash/_bashrc.prod" "$INSTALL_PATH/.bashrc.prod"
  linkit "$DOTFILE_PATH/bash/_git-completion.bash" "$INSTALL_PATH/.git-completion.bash"
  linkit_if_exists "$DOTFILE_PATH/bash/_bashrc-$SYS" "$INSTALL_PATH/.bashrc-$SYS"
}

link_zsh() {
  log1 "link_zsh"
  linkit "$DOTFILE_PATH/zsh/_zshrc" "$INSTALL_PATH/.zshrc"
  linkit "$DOTFILE_PATH/zsh/_zlogin" "$INSTALL_PATH/.zlogin"
  linkit "$DOTFILE_PATH/zsh/_zlogout" "$INSTALL_PATH/.zlogout"
  linkit "$DOTFILE_PATH/zsh/_zprofile" "$INSTALL_PATH/.zprofile"
  linkit "$DOTFILE_PATH/zsh/_zshenv" "$INSTALL_PATH/.zshenv"

  linkit "$DOTFILE_PATH/zsh/_zsh/env.zsh" "$INSTALL_PATH/.zsh/env.zsh"
  linkit "$DOTFILE_PATH/zsh/_zsh/interactive.zsh" "$INSTALL_PATH/.zsh/interactive.zsh"
  linkit "$DOTFILE_PATH/zsh/_zsh/login-post.zsh" "$INSTALL_PATH/.zsh/login-post.zsh"
  linkit "$DOTFILE_PATH/zsh/_zsh/login-pre.zsh" "$INSTALL_PATH/.zsh/login-pre.zsh"
  linkit "$DOTFILE_PATH/zsh/_zsh/logout.zsh" "$INSTALL_PATH/.zsh/logout.zsh"
  linkit "$DOTFILE_PATH/zsh/_zsh/colour.zsh" "$INSTALL_PATH/.zsh/colour.zsh"

  link_all_in_dir "$DOTFILE_PATH/zsh/_zsh/fpath" "$INSTALL_PATH/.zsh/fpath"
  link_all_in_dir "$DOTFILE_PATH/zsh/_zsh/modules.d" "$INSTALL_PATH/.zsh/modules.d"

  linkit_if_exists "$DOTFILE_PATH/zsh/_zshrc-$SYS" "$INSTALL_PATH/.zshrc-$SYS"
  linkit_if_exists "$DOTFILE_PATH/zsh/_zshenv-$SYS" "$INSTALL_PATH/.zshenv-$SYS"

  make_dir "$INSTALL_PATH/.zsh/history"
  make_dir "$INSTALL_PATH/.zsh/cache"
}

link_vim() {
  log1 "link_vim"
  linkit "$DOTFILE_PATH/vim/_vimrc" "$INSTALL_PATH/.vimrc"
  linkit "$DOTFILE_PATH/vim/_vimrc" "$INSTALL_PATH/.gvimrc"
  for i in $DOTFILE_PATH/vim/autoload/*; do
    BASE=`basename $i`
    linkit "$i" "$INSTALL_PATH/.vim/autoload/$BASE"
  done
  for i in $DOTFILE_PATH/vim/bundle/*; do
    BASE=`basename $i`
    linkit "$i" "$INSTALL_PATH/.vim/bundle/$BASE"
  done
}

link_nvim() {
  log1 "link_nvim"
  mkdir -p "$INSTALL_PATH/.config/nvim"
  mkdir -p "$INSTALL_PATH/.local/share/nvim/site/autoload"

  linkit "$DOTFILE_PATH/nvim/init.vim" "$INSTALL_PATH/.config/nvim/init.vim"
  linkit "$DOTFILE_PATH/nvim/plug.vim" "$INSTALL_PATH/.local/share/nvim/site/autoload/plug.vim"
}

link_screen_mgmt() {
  log1 "link_screen_mgmt"
  linkit "$DOTFILE_PATH/screen/_screenrc" "$INSTALL_PATH/.screenrc"
  linkit "$DOTFILE_PATH/tmux/_tmux.conf" "$INSTALL_PATH/.tmux.conf"
}

link_scm() {
  log1 "link_scm"
  linkit "$DOTFILE_PATH/git/_gitconfig" "$INSTALL_PATH/.gitconfig"
}

link_irssi() {
  log1 "link_irssi"
  linkit "$DOTFILE_PATH/irssi/trackbar.pl" "$INSTALL_PATH/.irssi/scripts/trackbar.pl"
  linkit "$INSTALL_PATH/.irssi/scripts/trackbar.pl" "$INSTALL_PATH/.irssi/scripts/autorun/trackbar.pl"
}

link_weechat() {
  log1 "link_weechat"

  linkit "$DOTFILE_PATH/weechat/alias.conf" "$INSTALL_PATH/.weechat/alias.conf"
  linkit "$DOTFILE_PATH/weechat/charset.conf" "$INSTALL_PATH/.weechat/charset.conf"
  linkit "$DOTFILE_PATH/weechat/irc.conf" "$INSTALL_PATH/.weechat/irc.conf"
  linkit "$DOTFILE_PATH/weechat/iset.conf" "$INSTALL_PATH/.weechat/iset.conf"
  linkit "$DOTFILE_PATH/weechat/logger.conf" "$INSTALL_PATH/.weechat/logger.conf"
  linkit "$DOTFILE_PATH/weechat/plugins.conf" "$INSTALL_PATH/.weechat/plugins.conf"
  linkit "$DOTFILE_PATH/weechat/relay.conf" "$INSTALL_PATH/.weechat/replay.conf"
  linkit "$DOTFILE_PATH/weechat/rmodifier.conf" "$INSTALL_PATH/.weechat/rmodifier.conf"
  linkit "$DOTFILE_PATH/weechat/script.conf" "$INSTALL_PATH/.weechat/script.conf"
  linkit "$DOTFILE_PATH/weechat/sec.conf" "$INSTALL_PATH/.weechat/sec.conf"
  linkit "$DOTFILE_PATH/weechat/weechat.conf" "$INSTALL_PATH/.weechat/weechat.conf"
  linkit "$DOTFILE_PATH/weechat/xfer.conf" "$INSTALL_PATH/.weechat/xfer.conf"
  linkit "$DOTFILE_PATH/weechat/trigger.conf" "$INSTALL_PATH/.weechat/trigger.conf"

  linkit "$DOTFILE_PATH/weechat/ca-certificates.crt" "$INSTALL_PATH/.weechat/ca-certificates.crt"

  # Plugins
  linkit "$DOTFILE_PATH/weechat/python/notification_center.py" "$INSTALL_PATH/.weechat/python/notification_center.py"
  linkit "$DOTFILE_PATH/weechat/python/notify.py" "$INSTALL_PATH/.weechat/python/notify.py"
  linkit "$DOTFILE_PATH/weechat/python/title.py" "$INSTALL_PATH/.weechat/python/title.py"
  linkit "$DOTFILE_PATH/weechat/python/tmux_env.py" "$INSTALL_PATH/.weechat/python/tmux_env.py"
  linkit "$DOTFILE_PATH/weechat/python/screen_away.py" "$INSTALL_PATH/.weechat/python/screen_away.py"
  linkit "$DOTFILE_PATH/weechat/python/flip.py" "$INSTALL_PATH/.weechat/python/flip.py"
  linkit "$DOTFILE_PATH/weechat/perl/iset.pl" "$INSTALL_PATH/.weechat/perl/iset.pl"

  # Auto-load plugins
  linkit "$DOTFILE_PATH/weechat/python/title.py" "$INSTALL_PATH/.weechat/python/autoload/title.py"
  linkit "$DOTFILE_PATH/weechat/python/tmux_env.py" "$INSTALL_PATH/.weechat/python/autoload/tmux_env.py"
  linkit "$DOTFILE_PATH/weechat/python/screen_away.py" "$INSTALL_PATH/.weechat/python/autoload/screen_away.py"
  linkit "$DOTFILE_PATH/weechat/python/flip.py" "$INSTALL_PATH/.weechat/python/autoload/flip.py"
  linkit "$DOTFILE_PATH/weechat/perl/iset.pl" "$INSTALL_PATH/.weechat/perl/autoload/iset.pl"
}

link_bin() {
  log1 "link_bin"
  link_all_in_dir "$DOTFILE_PATH/bin" "$INSTALL_PATH/bin"
}

link_i3() {
  log1 "link_i3"
  linkit "$DOTFILE_PATH/i3/_i3/config" "$INSTALL_PATH/.i3/config"
  linkit "$DOTFILE_PATH/i3/_i3/config.chromoting" "$INSTALL_PATH/.i3/config.chromoting"
  linkit "$DOTFILE_PATH/i3/_i3/i3status.conf" "$INSTALL_PATH/.i3/i3status.conf"
  linkit "$DOTFILE_PATH/i3/_i3/statusbar.py" "$INSTALL_PATH/.i3/statusbar.py"
}

link_misc() {
  log1 "link_misc"
  linkit "$DOTFILE_PATH/mutt/_muttrc" "$INSTALL_PATH/.muttrc"
  linkit "$DOTFILE_PATH/mutt/_mutt/muttrc" "$INSTALL_PATH/.mutt/muttrc"
  linkit "$DOTFILE_PATH/mutt/_mutt/crypto" "$INSTALL_PATH/.mutt/crypto"

  linkit "$DOTFILE_PATH/top/_toprc" "$INSTALL_PATH/.toprc"
  linkit "$DOTFILE_PATH/dircolors/default.cfg" "$INSTALL_PATH/.dircolorsrc"

  linkit "$DOTFILE_PATH/gpg/_gnupg/gpg.conf" "$INSTALL_PATH/.gnupg/gpg.conf"
}

link_fonts() {
  log1 "link_fonts"
  if [[ "$(uname -s)" == "Darwin" ]]; then
    copyit "$DOTFILE_PATH/fonts/source code pro black.ttf" "$INSTALL_PATH/Library/Fonts/source code pro black.ttf"
    copyit "$DOTFILE_PATH/fonts/source code pro bold.ttf" "$INSTALL_PATH/Library/Fonts/source code pro bold.ttf"
    copyit "$DOTFILE_PATH/fonts/source code pro extra light.ttf" "$INSTALL_PATH/Library/Fonts/source code pro extra light.ttf"
    copyit "$DOTFILE_PATH/fonts/source code pro light.ttf" "$INSTALL_PATH/Library/Fonts/source code pro light.ttf"
    copyit "$DOTFILE_PATH/fonts/source code pro regular.ttf" "$INSTALL_PATH/Library/Fonts/source code pro regular.ttf"
    copyit "$DOTFILE_PATH/fonts/source code pro semibold.ttf" "$INSTALL_PATH/Library/Fonts/source code pro semibold.ttf"
    copyit "$DOTFILE_PATH/fonts/Terminus.ttf" "$INSTALL_PATH/Library/Fonts/Terminus.ttf"
    copyit "$DOTFILE_PATH/fonts/TerminusBold.ttf" "$INSTALL_PATH/Library/Fonts/TerminusBold.ttf"

    copyit "$DOTFILE_PATH/fonts/Go Mono Bold Italic Nerd Font Complete Mono.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Bold Italic Nerd Font Complete Mono.ttf"
    copyit "$DOTFILE_PATH/fonts/Go Mono Bold Italic Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Bold Italic Nerd Font Complete.ttf"
    copyit "$DOTFILE_PATH/fonts/Go Mono Bold Nerd Font Complete Mono.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Bold Nerd Font Complete Mono.ttf"
    copyit "$DOTFILE_PATH/fonts/Go Mono Bold Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Bold Nerd Font Complete.ttf"
    copyit "$DOTFILE_PATH/fonts/Go Mono Italic Nerd Font Complete Mono.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Italic Nerd Font Complete Mono.ttf"
    copyit "$DOTFILE_PATH/fonts/Go Mono Italic Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Italic Nerd Font Complete.ttf"
    copyit "$DOTFILE_PATH/fonts/Go Mono Nerd Font Complete Mono.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Nerd Font Complete Mono.ttf"
    copyit "$DOTFILE_PATH/fonts/Go Mono Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Go Mono Nerd Font Complete.ttf"

    copyit "$DOTFILE_PATH/fonts/Comic Mono Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Comic Mono Nerd Font Complete.ttf"
    copyit "$DOTFILE_PATH/fonts/Comic Mono Bold Nerd Font Complete.ttf" "$INSTALL_PATH/Library/Fonts/Comic Mono Bold Nerd Font Complete.ttf"
  elif [[ "$(uname -s)" == "Linux" ]]; then
    linkit "$DOTFILE_PATH/fonts/source code pro black.ttf" "$INSTALL_PATH/.fonts/source code pro black.ttf"
    linkit "$DOTFILE_PATH/fonts/source code pro bold.ttf" "$INSTALL_PATH/.fonts/source code pro bold.ttf"
    linkit "$DOTFILE_PATH/fonts/source code pro extra light.ttf" "$INSTALL_PATH/.fonts/source code pro extra light.ttf"
    linkit "$DOTFILE_PATH/fonts/source code pro light.ttf" "$INSTALL_PATH/.fonts/source code pro light.ttf"
    linkit "$DOTFILE_PATH/fonts/source code pro regular.ttf" "$INSTALL_PATH/.fonts/source code pro regular.ttf"
    linkit "$DOTFILE_PATH/fonts/source code pro semibold.ttf" "$INSTALL_PATH/.fonts/source code pro semibold.ttf"
    linkit "$DOTFILE_PATH/fonts/Terminus.ttf" "$INSTALL_PATH/.fonts/Terminus.ttf"
    linkit "$DOTFILE_PATH/fonts/TerminusBold.ttf" "$INSTALL_PATH/.fonts/TerminusBold.ttf"

    linkit "$DOTFILE_PATH/fonts/Go Mono Bold Italic Nerd Font Complete Mono.ttf" "$INSTALL_PATH/.fonts/Go Mono Bold Italic Nerd Font Complete Mono.ttf"
    linkit "$DOTFILE_PATH/fonts/Go Mono Bold Italic Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Go Mono Bold Italic Nerd Font Complete.ttf"
    linkit "$DOTFILE_PATH/fonts/Go Mono Bold Nerd Font Complete Mono.ttf" "$INSTALL_PATH/.fonts/Go Mono Bold Nerd Font Complete Mono.ttf"
    linkit "$DOTFILE_PATH/fonts/Go Mono Bold Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Go Mono Bold Nerd Font Complete.ttf"
    linkit "$DOTFILE_PATH/fonts/Go Mono Italic Nerd Font Complete Mono.ttf" "$INSTALL_PATH/.fonts/Go Mono Italic Nerd Font Complete Mono.ttf"
    linkit "$DOTFILE_PATH/fonts/Go Mono Italic Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Go Mono Italic Nerd Font Complete.ttf"
    linkit "$DOTFILE_PATH/fonts/Go Mono Nerd Font Complete Mono.ttf" "$INSTALL_PATH/.fonts/Go Mono Nerd Font Complete Mono.ttf"
    linkit "$DOTFILE_PATH/fonts/Go Mono Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Go Mono Nerd Font Complete.ttf"

    linkit "$DOTFILE_PATH/fonts/Comic Mono Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Comic Mono Nerd Font Complete.ttf"
    linkit "$DOTFILE_PATH/fonts/Comic Mono Bold Nerd Font Complete.ttf" "$INSTALL_PATH/.fonts/Comic Mono Bold Nerd Font Complete.ttf"
  fi
}

set_preferences() {
  log1 "Setting preferences"
  OS_PREF_SH="${DOTFILE_PATH}/prefs/${SYS}.sh"

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
  OS_PKG_SH="${DOTFILE_PATH}/pkgs/${SYS}.sh"
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
