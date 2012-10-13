#
# Support functions for manipulating the dotfiles.
#

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
