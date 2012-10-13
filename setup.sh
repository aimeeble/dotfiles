#!/bin/bash

SYS=`uname -s`
VERBOSE=0

log1() {
   [[ $VERBOSE -gt 0 ]] && echo "==> $*"
}
log2() {
   [[ $VERBOSE -gt 0 ]] && echo "    $*"
}
log_always() {
   echo "   ==> $* <=="
}

validate_env() {
   if [ "$1" == "-v" ]; then
      VERBOSE=1
      shift
   fi

   if [ -z "$DOTFILE_PATH" ]; then
      DOTFILE_PATH=$1
   fi
   if [ -z "$DOTFILE_PATH" ]; then
      DOTFILE_PATH="`pwd`"
   fi
   if [ ! -f "$DOTFILE_PATH/.dotfiles" ]; then
      echo "Cannot find dotfiles in DOTFILE_PATH=$DOTFILE_PATH"
      exit 1
   fi
}

init_submodules() {
   log1 "init_submodules"
   git submodule init
   git submodule update
}

linkit() {
   SRC=$1
   DST=$2

   if [ -e "$DST" -a ! -L "$DST" ]; then
      log_always "WARNING! $DST exists and isn't a symlink!"
   elif [ -L "$DST" ]; then
      log2 "Already done $DST."
   else
      log2 "Linking $DST..."
      ln -s "$SRC" "$DST"
   fi
}

linkit_if_exists() {
   SRC=$1
   DST=$2

   if [ ! -e "$SRC" ]; then
      log2 "Skipping optional file $SRC"
      return
   fi

   linkit "$SRC" "$DST"
}

link_bash() {
   log1 "link_bash"
   linkit "$DOTFILE_PATH/bash/_bashrc" "$HOME/.bashrc"
   linkit "$DOTFILE_PATH/bash/_git-completion.bash" "$HOME/.git-completion.bash"
   linkit_if_exists "$DOTFILE_PATH/bash/_bashrc-$SYS" "$HOME/.bashrc-$SYS"
}

link_vim() {
   log1 "link_vim"
   mkdir -p "$HOME/.vim"
   linkit "$DOTFILE_PATH/vim/_vimrc" "$HOME/.vimrc"
   linkit "$DOTFILE_PATH/vim/_vimrc" "$HOME/.gvimrc"
   mkdir -p "$HOME/.vim/autoload"
   for i in $DOTFILE_PATH/vim/autoload/*; do
      BASE=`basename $i`
      linkit "$i" "$HOME/.vim/autoload/$BASE"
   done
   mkdir -p "$HOME/.vim/bundle"
   for i in $DOTFILE_PATH/vim/bundle/*; do
      BASE=`basename $i`
      linkit "$i" "$HOME/.vim/bundle/$BASE"
   done
}

link_screen_mgmt() {
   log1 "link_screen_mgmt"
   linkit "$DOTFILE_PATH/screen/_screenrc" "$HOME/.screenrc"
   linkit "$DOTFILE_PATH/tmux/_tmux.conf" "$HOME/.tmux.conf"
}

link_scm() {
   log1 "link_scm"
   linkit "$DOTFILE_PATH/git/_gitconfig" "$HOME/.gitconfig"
}

link_irssi() {
   log1 "link_irssi"
   mkdir -p "$HOME/.irssi/scripts/autorun"
   linkit "$DOTFILE_PATH/irssi/trackbar.pl" "$HOME/.irssi/scripts/trackbar.pl"
   linkit "$HOME/.irssi/scripts/trackbar.pl" "$HOME/.irssi/scripts/autorun/trackbar.pl"
}

link_misc() {
   log1 "link_misc"
   linkit "$DOTFILE_PATH/mutt/_muttrc" "$HOME/.muttrc"
   linkit "$DOTFILE_PATH/top/_toprc" "$HOME/.toprc"
}

validate_env $*
init_submodules

link_bash
link_vim
link_scm
link_screen_mgmt
link_irssi
