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

link_misc() {
   log1 "link_misc"
   linkit "$DOTFILE_PATH/mutt/_muttrc" "$INSTALL_PATH/.muttrc"
   linkit "$DOTFILE_PATH/top/_toprc" "$INSTALL_PATH/.toprc"
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
