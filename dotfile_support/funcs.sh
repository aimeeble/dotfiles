#!/bin/bash
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

CHECKOUT_PATH="$(pwd)"
INSTALL_PATH="${HOME}"
SYS="$(uname -s)"
VERBOSE=0
INSTALL_PKGS=0

log1() {
  if [[ "${VERBOSE}" -gt 0 ]]; then echo "==> $*"; fi
}
log2() {
  if [[ "${VERBOSE}" -gt 0 ]]; then echo "    $*"; fi
}
log_always() {
  echo "==> $* <=="
}

parse_flags() {
  local -a POSARGS
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--source|--src)
        CHECKOUT_PATH="$2"
        shift
        shift
        ;;
      --system)
        SYS="$2"
        shift
        shift
        ;;
      -d|--destination|--dest|--dst|-t|--target)
        INSTALL_PATH="$2"
        shift
        shift
        ;;
      -v|--verbose)
        VERBOSE=1
        shift
        ;;
      -p|--pkgs)
        INSTALL_PKGS=1
        shift
        ;;
      -h|--help)
        echo "./setup.sh [OPTIONS]"
        echo ""
        echo "  -s|--source|--src CHECKOUT_PATH"
        echo "      Specify alternate source. Currently ${CHECKOUT_PATH}"
        echo "  -d|--destination|--dest|-t|--target INSTALL_PATH"
        echo "      Specify destination/target path to install dotfile repo into. Currently ${INSTALL_PATH}"
        echo "  -v|--verbose"
        echo "      Verbose mode -- more logs. Currently ${VERBOSE}"
        echo "  -p|--pkgs"
        echo "      Install 3rd-party packages. Currently ${INSTALL_PKGS}"
        echo "  --system TYPE"
        echo "      override system type for system-specific configs. Currently ${SYS}"
        echo ""
        exit 1
        ;;
      -*)
        echo "Unknown arg '$1'"
        exit 1
        ;;
      *)
        POSARGS+=("$1")
        shift
        ;;
    esac
  done
  set -- "${POSARGS[@]:-}"

  # Check for our source dotfile repo based on priority list.
  if [[ -z "${CHECKOUT_PATH}" || ! -f "${CHECKOUT_PATH}/.dotfiles" ]]; then
    echo "Cannot find dotfile source indicator file '${CHECKOUT_PATH}/.dotfiles'"
    exit 1
  fi

  # Check the install path
  INSTALL_PATH="${INSTALL_PATH:-"${HOME}"}"
  if [[ ! -d "${INSTALL_PATH}" || ! -w "${INSTALL_PATH}" ]]; then
    echo "Cannot write to destination directory '${INSTALL_PATH}'"
    exit 1
  fi

  log1 "parse_flags:"
  log2 "source ............ ${CHECKOUT_PATH}"
  log2 "destination ....... ${INSTALL_PATH}"
  log2 "system type ....... ${SYS}"
  log2 "VERBOSE ........... ${VERBOSE}"
  log2 "install packages .. ${INSTALL_PKGS}"
}

init_submodules() {
  log1 "init_submodules"
  git submodule init
  git submodule update
}

linkit() {
  local SRC="$1"
  local DST="$2"
  local DST_DIR
  local EXISTING
  DST_DIR="$(dirname "${DST}")"
  EXISTING="$(readlink "${DST}")"

  if [[ -e "${DST}" && ! -L "${DST}" ]]; then
    log_always "${RED}WARNING! ${DST} exists and isn't a symlink!${NORM}"
    return
  elif [[ -L "${DST}" && "${EXISTING}" != "${SRC}" ]]; then
    log_always "${YELLOW}Warning: ${DST} exists but links to ${EXISTING} and not ${SRC}${NORM}"
    if [[ -z "${FORCE}" ]]; then
      return
    fi
    log_always "  FORCE set; continuing"
    rm "${DST}"
  elif [[ -L "${DST}" ]]; then
    log2 "Already done ${DST}."
    return
  fi

  # Ensure destination directory exists
  if [[ ! -d "${DST_DIR}" ]]; then
    mkdir -p "${DST_DIR}"
  fi
  if [[ ! -d "${DST_DIR}" || ! -w "${DST_DIR}" ]]; then
    log_always "${RED}WARNING! Failed to create dest dir ${DST_DIR}${NORM}"
    return
  fi

  # Finally, link it!
  log2 "${GREEN}Linking ${DST}...${NORM}"
  ln -s "${SRC}" "${DST}"
}

link_all_in_dir() {
  SRC_DIR="$1"
  DST_DIR="$2"
  for f in "${SRC_DIR}"/*; do
    BASE="$(basename "${f}")"
    SRC="${SRC_DIR}/${BASE}"
    DST="${DST_DIR}/${BASE}"
    linkit "${SRC}" "${DST}"
  done
}

copyit() {
  local SRC="$1"
  local DST="$2"
  local DST_DIR
  DST_DIR="$(dirname "${DST}")"

  if [[ -e "${DST}" ]]; then
    log2 "Already done ${DST}."
    return
  fi

  # Ensure destination directory exists
  if [[ ! -d "${DST_DIR}" ]]; then
    mkdir -p "${DST_DIR}"
  fi
  if [[ ! -d "${DST_DIR}" || ! -w "${DST_DIR}" ]]; then
    log_always "${RED}WARNING! Failed to create dest dir ${DST_DIR}${NORM}"
    return
  fi

  # Finally, link it!
  log2 "${GREEN}Copying ${DST}...${NORM}"
  cp "${SRC}" "${DST}"
}

linkit_if_exists() {
  local SRC="$1"
  local DST="$2"

  if [[ ! -e "${SRC}" ]]; then
    log2 "${YELLOW}Skipping optional file ${SRC}${NORM}"
    return
  fi

  linkit "${SRC}" "${DST}"
}

link_if_newer() {
  local SRC="$1"
  local DST="$2"
  local TEST_VER="$3"
  local REQ_VER="$4"

  if [[ $(dotted_version "${TEST_VER}") -ge $(dotted_version "${REQ_VER}") ]]; then
    linkit "${SRC}" "${DST}"
  else
    log2 "${YELLOW}Version check failed; skipping file ${SRC}${NORM}"
  fi
}

make_dir() {
  local DIR="$1"

  if [[ -e "${DIR}" && ! -d "${DIR}" ]]; then
    log_always "${RED}WARNING: ${DIR} exists and isn't a directory${NORM}"
    return
  fi

  if [[ -d "${DIR}" && -r "${DIR}" ]]; then
    # done!
    log2 "Skipping existing directory ${DIR}"
    return
  fi

  log2 "${GREEN}Creating directory ${DIR}${NORM}"
  mkdir -p "${DIR}"

  if [[ ! -d "${DIR}" ]]; then
    log_always "${RED}WARNING: failed to create directory ${DIR}${NORM}"
    return
  fi
}

update_stamp() {
  local SHA
  SHA="$(git --git-dir="${CHECKOUT_PATH}/.git" rev-parse HEAD)"
  echo "${SHA}:${CHECKOUT_PATH}" > "${INSTALL_PATH}/.dotfile_version"
}

dotted_version() {
  local DOTVER="$1"
  local NUM_DOTS="${2:-3}"
  local num_done=0
  local n=0
  for i in $(echo "${DOTVER}" | tr '.' ' '); do
    n=$((n * 100))
    n=$((n + i))
    num_done=$((num_done + 1))
    if [[ "${num_done}" -ge "${NUM_DOTS}" ]]; then
      break
    fi
  done
  while [[ "${num_done}" -lt "${NUM_DOTS}" ]]; do
    n=$((n * 100))
    num_done=$((num_done + 1))
  done
  echo "${n}"
}

set_default() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    return
  fi
  LOG="$1"
  APP="$2"
  PROP="$3"
  VALUE="$4"
  MODE="${5:-}"

  log2 "${LOG}"
  if [[ -n "${MODE}" ]]; then
    defaults write "${APP}" "${PROP}" "${MODE}" "${VALUE}"
  else
    defaults write "${APP}" "${PROP}" "${VALUE}"
  fi
}
