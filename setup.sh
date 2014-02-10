#!/bin/bash

if [[ ! -f "dotfile_support/funcs.sh" ]]; then
   echo "Missing `pwd`/dotfile_support/funcs.sh"
   exit 1
fi
. "dotfile_support/funcs.sh"

link_bash() {
   log1 "link_bash"
   linkit "$DOTFILE_PATH/bash/_bashrc" "$INSTALL_PATH/.bashrc"
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

   linkit "$DOTFILE_PATH/zsh/_zsh/fpath" "$INSTALL_PATH/.zsh/fpath"
   linkit "$DOTFILE_PATH/zsh/_zsh/env.zsh" "$INSTALL_PATH/.zsh/env.zsh"
   linkit "$DOTFILE_PATH/zsh/_zsh/interactive.zsh" "$INSTALL_PATH/.zsh/interactive.zsh"
   linkit "$DOTFILE_PATH/zsh/_zsh/login-post.zsh" "$INSTALL_PATH/.zsh/login-post.zsh"
   linkit "$DOTFILE_PATH/zsh/_zsh/login-pre.zsh" "$INSTALL_PATH/.zsh/login-pre.zsh"
   linkit "$DOTFILE_PATH/zsh/_zsh/logout.zsh" "$INSTALL_PATH/.zsh/logout.zsh"

   linkit "$DOTFILE_PATH/zsh/_zsh/errors.zsh" "$INSTALL_PATH/.zsh/errors.zsh"
   linkit "$DOTFILE_PATH/zsh/_zsh/tmux.zsh" "$INSTALL_PATH/.zsh/tmux.zsh"
   linkit "$DOTFILE_PATH/zsh/_zsh/chezpina.zsh" "$INSTALL_PATH/.zsh/chezpina.zsh"

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

    # Plugins
    linkit "$DOTFILE_PATH/weechat/python/notification_center.py" "$INSTALL_PATH/.weechat/python/notification_center.py"
    linkit "$DOTFILE_PATH/weechat/python/notify.py" "$INSTALL_PATH/.weechat/python/notify.py"
    linkit "$DOTFILE_PATH/weechat/python/title.py" "$INSTALL_PATH/.weechat/python/title.py"
    linkit "$DOTFILE_PATH/weechat/python/tmux_env.py" "$INSTALL_PATH/.weechat/python/tmux_env.py"
    linkit "$DOTFILE_PATH/weechat/python/screen_away.py" "$INSTALL_PATH/.weechat/python/screen_away.py"
    linkit "$DOTFILE_PATH/weechat/perl/iset.pl" "$INSTALL_PATH/.weechat/perl/iset.pl"

    # Auto-load plugins
    linkit "$DOTFILE_PATH/weechat/python/title.py" "$INSTALL_PATH/.weechat/python/autoload/title.py"
    linkit "$DOTFILE_PATH/weechat/python/tmux_env.py" "$INSTALL_PATH/.weechat/python/autoload/tmux_env.py"
    linkit "$DOTFILE_PATH/weechat/python/screen_away.py" "$INSTALL_PATH/.weechat/python/autoload/screen_away.py"
    linkit "$DOTFILE_PATH/weechat/perl/iset.pl" "$INSTALL_PATH/.weechat/perl/autoload/iset.pl"
}

link_misc() {
   log1 "link_misc"
   linkit "$DOTFILE_PATH/mutt/_muttrc" "$INSTALL_PATH/.muttrc"
   linkit "$DOTFILE_PATH/mutt/_mutt/muttrc" "$INSTALL_PATH/.mutt/muttrc"
   linkit "$DOTFILE_PATH/mutt/_mutt/crypto" "$INSTALL_PATH/.mutt/crypto"

   linkit "$DOTFILE_PATH/top/_toprc" "$INSTALL_PATH/.toprc"
   linkit "$DOTFILE_PATH/dircolors/default.cfg" "$INSTALL_PATH/.dircolorsrc"
}

umask 077
validate_env $*
init_submodules

link_bash
link_zsh
link_vim
link_scm
link_screen_mgmt
link_irssi
link_weechat
link_misc

update_stamp
