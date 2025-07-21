#!/bin/bash

HOMEBREW_PACKAGES=(
  "colordiff"       # Color-highlighted diff(1) output
  "coreutils"       # GNU File, Shell, and Text utilities
  "duf"             # Disk Usage/Free Utility - a better 'df' alternative
  "dust"            # More intuitive version of du in rust
  "htop"            # Improved top (interactive process viewer)
  "pstree"          # Show ps output as a tree
  "tmux"            # Terminal multiplexer
  "tree"            # Display directories as trees (with optional color/HTML output)

  "mtr"             # 'traceroute' and 'ping' in a single tool
  "nmap"            # Port scanning utility for large networks
  "socat"           # SOcket CAT: netcat on steroids

  "neovim"          # Ambitious Vim-fork focused on extensibility and agility
  "binwalk"         # Searches a binary image for embedded files and executable code
  "git"             # Distributed revision control system
  "git-lfs"         # Git extension for versioning large files
  "go"              # Open source programming language to build simple/reliable/efficient software
  "grpcurl"         # Like cURL, but for gRPC
  "mdcat"           # Show markdown documents on text terminals
  "jq"              # Lightweight and flexible command-line JSON processor
  "yq"              # Process YAML, JSON, XML, CSV and properties documents from the CLI
)

install_os_packages() {
  B="$(which brew)"
  if [[ ! -x "$B" ]]; then
    log2 "No homebrew binary detected"
    return
  fi

  log2 "Installing ${HOMEBREW_PACKAGES[@]}"
  "${B}" update --quiet
  "${B}" install --quiet ${HOMEBREW_PACKAGES[@]}
}
