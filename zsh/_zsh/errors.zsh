typeset -ga prompt_error_check_functions
typeset -ga PROMPT_ERRORS

# Just a nice wrapper to add a new error to the list of errors.
# Arguments:
#   1 (string): the error text/code e.g. "krb ticket"
add_prompt_error() {
   PROMPT_ERRORS+=("$1")
}

# Add this to the preexec_functions array to keep the prompt up-to-date.
precmd_error_check() {
   if [[ -z $prompt_error_check_functions ]]; then
      # No tests.
      return
   fi

   typeset OLD_PROMPT_ERRORS
   OLD_PROMPT_ERRORS=$PROMPT_ERRORS
   PROMPT_ERRORS=""

   for fun in $prompt_error_check_functions; do
      eval $fun > /dev/null
   done

   if [[ "$OLD_PROMPT_ERRORS" != "$PROMPT_ERRORS" ]]; then
      # Recreate prompt if something changed
      create_prompt
   fi
}

# A silly test for a flag file. Useful for testing.
errtest_flagfile() {
  if [[ -e /tmp/err ]]; then
    add_prompt_error "flag file exists"
  fi
}

# Less silly--checks that symlinks are up-to-date with dotfile repo commit.
errtest_dotfile_version() {
    if [[ ! -e "$HOME/.dotfile_version" ]]; then
        add_prompt_error "dotfiles out-of-date (no version)"
        return
    fi

    INFO=("${(ps.:.)$(cat $HOME/.dotfile_version)}")
    SHA=${INFO[1]}
    REPO=${INFO[2]}

    echo "INFO='$INFO'"
    echo "SHA='$SHA'"
    echo "REPO='$REPO'"

    if [[ ! -d "$REPO" ]]; then
        add_prompt_error "dotfiles out-of-date (repo moved)"
        return
    fi

    CURRENT_SHA=$(git --git-dir=$REPO/.git rev-parse HEAD)
    echo "CURRENT='$CURRENT_SHA'"

    if [[ "$SHA" != "$CURRENT_SHA" ]]; then
        add_prompt_error "dotfiles out-of-date (bad SHA)"
        return
    fi
}

# Returns the list of all errors that have been set.
# Arguments:
#   1 (string): if set, does not colorize the response with print -P
# Returns:
#   a concatenation of all errors and a handy-dandy prefix.
get_prompt_errors() {
   if [[ -z "$PROMPT_ERRORS" ]]; then
      return
   fi

   if [[ -n "$1" ]]; then
      echo "Errors:($PROMPT_ERRORS ) "
      return
   fi

   print -P "%B%F{red}Errors:($PROMPT_ERRORS )%f%b "
}


# Initializes this module.
errors_init() {
   prompt_error_check_functions+=(errtest_flagfile errtest_dotfile_version)
   precmd_functions+=(precmd_error_check)
}
