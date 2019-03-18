_keybindings_init() {
   # vi-mode
   bindkey -v
   bindkey -M viins 'jj' vi-cmd-mode
   # ...but keep ^R for searching command history
   bindkey '^R' history-incremental-search-backward

   bindkey -M vicmd 'k' up-line-or-local-history
   bindkey -M vicmd 'j' down-line-or-local-history

   # Fix some stuff that Debian distros like to mess with. Basically, it likes
   # to set vi-up-line-or-history, which places the cursor at the beginning of
   # the line. I prefer having the cursor at the end of the line.
   #
   # Ref: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=383737
   #
   (( ${+terminfo[cuu1]}  )) && bindkey -M viins "$terminfo[cuu1]" up-line-or-local-history
   (( ${+terminfo[kcuu1]} )) && bindkey -M viins "$terminfo[kcuu1]" up-line-or-local-history
   [[ "${terminfo[kcuu1]:-}" == "O"* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-local-history
   (( ${+terminfo[kcud1]} )) && bindkey -M viins "$terminfo[kcud1]" down-line-or-local-history
   [[ "${terminfo[kcud1]:-}" == "O"* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-local-history

   # VIM-style backspace (delete back beyond the start of insert mode)
   zle -A .backward-delete-char vi-backward-delete-char

   # Open command line in $EDITOR when pressing v
   zle -N edit-command-line
   bindkey -M vicmd v edit-command-line
}

module_add "keybindings" _keybindings_init
