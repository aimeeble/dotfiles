#
# Support functions for manipulating the dotfiles.
#

NUM_COLORS=$(tput colors)
if [[ "$?" -eq "0" && "${NUM_COLORS}" -gt "0" ]]; then
  RED='[31m'
  GREEN='[32m'
  YELLOW='[33m'
  NORM='[39m'
else
  RED=''
  GREEN=''
  YELLOW=''
  NORM=''
fi

SYS=`uname -s`
VERBOSE=0

log1() {
   [[ $VERBOSE -gt 0 ]] && echo "==> $*"
}
log2() {
   [[ $VERBOSE -gt 0 ]] && echo "    $*"
}
log_always() {
   echo "==> $* <=="
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
   local DST_DIR="`dirname "$DST"`"

   if [[ -e "$DST" && ! -L "$DST" ]]; then
      log_always "${RED}WARNING! $DST exists and isn't a symlink!${NORM}"
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
      log_always "${RED}WARNING! Failed to create dest dir ${DST_DIR}${NORM}"
      return
   fi

   # Finally, link it!
   log2 "${GREEN}Linking $DST...${NORM}"
   ln -s "$SRC" "$DST"
}

copyit() {
    local SRC="$1"
    local DST="$2"
    local DST_DIR="`dirname "$DST"`"

   if [[ -e "$DST" ]]; then
      log2 "Already done $DST."
      return
   fi

   # Ensure destination directory exists
   if [[ ! -d "$DST_DIR" ]]; then
      mkdir -p "$DST_DIR"
   fi
   if [[ ! -d "$DST_DIR" || ! -w "$DST_DIR" ]]; then
      log_always "${RED}WARNING! Failed to create dest dir ${DST_DIR}${NORM}"
      return
   fi

   # Finally, link it!
   log2 "${GREEN}Copying $DST...${NORM}"
   cp "$SRC" "$DST"
}

linkit_if_exists() {
   local SRC="$1"
   local DST="$2"

   if [[ ! -e "$SRC" ]]; then
      log2 "${YELLOW}Skipping optional file ${SRC}${NORM}"
      return
   fi

   linkit "$SRC" "$DST"
}

link_if_newer() {
    local SRC="$1"
    local DST="$2"
    local TEST_VER="$3"
    local REQ_VER="$4"

    if [[ $(dotted_version $TEST_VER) -ge $(dotted_version $REQ_VER) ]]; then
        linkit "$SRC" "$DST"
    else
      log2 "${YELLOW}Version check failed; skipping file ${SRC}${NORM}"
    fi
}

make_dir() {
   local DIR="$1"

   if [[ -e "$DIR" && ! -d "$DIR" ]]; then
      log_always "${RED}WARNING: $DIR exists and isn't a directory${NORM}"
      return
   fi

   if [[ -d "$DIR" && -r "$DIR" ]]; then
      # done!
      log2 "Skipping existing directory $DIR"
      return
   fi

   log2 "${GREEN}Creating directory ${DIR}${NORM}"
   mkdir -p "$DIR"

   if [[ ! -d "$DIR" ]]; then
      log_always "${RED}WARNING: failed to create directory ${DIR}${NORM}"
      return
   fi
}

update_stamp() {
    local SHA=$(git --git-dir="$DOTFILE_PATH/.git" rev-parse HEAD)
    echo "$SHA:$DOTFILE_PATH" > "$INSTALL_PATH/.dotfile_version"
}

dotted_version() {
    local DOTVER="$1"
    local NUM_DOTS="${2:-3}"
    local num_done=0
    local n=0
    for i in $(echo $DOTVER | tr '.' ' '); do
        n=$(($n * 100))
        n=$(($n + $i))
        num_done=$(($num_done + 1))
        if [[ $num_done -ge $NUM_DOTS ]]; then
            break
        fi
    done
    while [[ $num_done -lt $NUM_DOTS ]]; do
        n=$(($n * 100))
        num_done=$(($num_done + 1))
    done
    echo "$n"
}
