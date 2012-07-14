#!/bin/bash

ST=`uname -s`

if [ -z "$DOTFILE_PATH" ]; then
   DOTFILE_PATH=$1
fi
if [ -z "$DOTFILE_PATH" ]; then
   DOTFILE_PATH="$HOME/Dropbox/dotfiles"
fi
if [ ! -d "$DOTFILE_PATH" ]; then
   echo "Cannot find DOTFILE_PATH=$DOTFILE_PATH"
   exit 1
fi

linkit() {
   SRC=$1
   DST=$2

   if [ -e "$DST" -a ! -L "$DST" ]; then
      echo "WARNING! $DST exists and isn't a symlink!"
   elif [ -L "$DST" ]; then
      echo "Already done $DST."
   else
      echo "Linking $DST..."
      ln -s "$SRC" "$DST"
   fi
}

linkit "$DOTFILE_PATH/bash/_bashrc" "$HOME/.bashrc"
linkit "$DOTFILE_PATH/bash/_git-completion.bash" "$HOME/.git-completion.bash"
if [ -e "$DOTFILE_PATH/bash/_bashrc-$ST" ]; then
   linkit "$DOTFILE_PATH/bash/_bashrc-$ST" "$HOME/.bashrc-$ST"
fi

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

linkit "$DOTFILE_PATH/mutt/_muttrc" "$HOME/.muttrc"

linkit "$DOTFILE_PATH/screen/_screenrc" "$HOME/.screenrc"

linkit "$DOTFILE_PATH/top/_toprc" "$HOME/.toprc"

mkdir -p "$HOME/.irssi/scripts/autorun"
linkit "$DOTFILE_PATH/irssi/trackbar.pl" "$HOME/.irssi/scripts/trackbar.pl"
linkit "$HOME/.irssi/scripts/trackbar.pl" "$HOME/.irssi/scripts/autorun/trackbar.pl"

linkit "$DOTFILE_PATH/tmux/_tmux.conf" "$HOME/.tmux.conf"

linkit "$DOTFILE_PATH/git/_gitconfig" "$HOME/.gitconfig"
