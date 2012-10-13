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
   if [[ "$1" == "-v" ]]; then
      VERBOSE=1
      shift
   fi

   if [[ -z "$DOTFILE_PATH" ]]; then
      DOTFILE_PATH=$1
      shift
   fi
   if [[ -z "$DOTFILE_PATH" ]]; then
      DOTFILE_PATH="`pwd`"
   fi
   if [[ ! -f "$DOTFILE_PATH/.dotfiles" ]]; then
      echo "Cannot find dotfiles in DOTFILE_PATH=$DOTFILE_PATH"
      exit 1
   fi

   if [[ -z "$INSTALL_PATH" ]]; then
      INSTALL_PATH=$1
      shift
   fi
   if [[ -z "$INSTALL_PATH" ]]; then
      INSTALL_PATH=$HOME
   fi
   if [[ ! -d "$INSTALL_PATH" || ! -w "$INSTALL_PATH" ]]; then
      echo "Cannot find write to destination directory $INSTALL_PATH"
      exit 1
   fi

   log1 "validate_env"
   log2 "VERBOSE ....... $VERBOSE"
   log2 "source ........ $DOTFILE_PATH"
   log2 "destination ... $INSTALL_PATH"
}

init_submodules() {
   log1 "init_submodules"
   git submodule init
   git submodule update
}

linkit() {
   local SRC="$1"
   local DST="$2"
   local DST_DIR="`dirname $DST`"

   if [[ -e "$DST" && ! -L "$DST" ]]; then
      log_always "WARNING! $DST exists and isn't a symlink!"
      return
   elif [[ -L "$DST" ]]; then
      log2 "Already done $DST."
      return
   fi

   # Ensure destination directory exists
   if [[ ! -d "$DST_DIR" ]]; then
      mkdir -p "$DST_DIR"
   fi
   if [[ ! -d "$DST_DIR" || ! -w "$DST_DIR" ]]; then
      log_always "WARNING! Failed to create dest dir $DST_DIR"
      return
   fi

   # Finally, link it!
   log2 "Linking $DST..."
   ln -s "$SRC" "$DST"
}

linkit_if_exists() {
   local SRC="$1"
   local DST="$2"

   if [[ ! -e "$SRC" ]]; then
      log2 "Skipping optional file $SRC"
      return
   fi

   linkit "$SRC" "$DST"
}

link_bash() {
   log1 "link_bash"
   linkit "$DOTFILE_PATH/bash/_bashrc" "$INSTALL_PATH/.bashrc"
   linkit "$DOTFILE_PATH/bash/_git-completion.bash" "$INSTALL_PATH/.git-completion.bash"
   linkit_if_exists "$DOTFILE_PATH/bash/_bashrc-$SYS" "$INSTALL_PATH/.bashrc-$SYS"
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

validate_env $*
init_submodules

link_bash
link_vim
link_scm
link_screen_mgmt
link_irssi
