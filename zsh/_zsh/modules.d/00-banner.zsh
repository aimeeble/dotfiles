
# When set to 1 banner skips indentation and cursor back-shifting.
_DEBUG_BANNER=0

##############################################################################
ruler() {
IFS="" read -r -d '' TEXT << '__EOF'
%F{magenta}0---------1---------2---------3---------4---------5---------6---------7--------7%f
%F{magenta}01234567890123456789012345678901234567890123456789012345678901234567890123456789%f
__EOF
print -n -P "${TEXT}"
}

##############################################################################
# Shifts a banner provided in $1 by an indentation amount provided in $2, then
# moves the cursor back up to the top of the printed text (cursor remains on
# same row as before printing the banner text).
shifted_banner() {
  TEXT="${1:-}"
  INDENT="${2:-30}"
  LN="$(echo ${TEXT} | awk 'END{print NR}')"
  if [[ "$_DEBUG_BANNER" -eq 1 ]]; then
    print -P "${TEXT}"
    print "${LN} lines"
  else
    print -Pn "${TEXT}" | pr -to "$INDENT"
    print "\033[$((LN))A"
  fi
}

##############################################################################
# Shows a repeated single line of text ($1) in multiple colours (each
# subsequent parameter).
rainbow_banner() {
  REPEATED_TEXT="${1}"
  shift

  TEXT="$(
    echo # blank line for padding at top
    while [[ $# -gt 0 ]]; do
      COLOUR="$1"
      shift

      BOLD="$(echo "$COLOUR" | grep -- -b)"
      COLOUR="$(echo "$COLOUR" | cut -d'-' -f'1')"

      if [[ -n "$BOLD" ]]; then
        print -P "%B%F{${COLOUR}}${REPEATED_TEXT}%f%b"
      else
        print -P "%F{${COLOUR}}${REPEATED_TEXT}%f"
      fi
    done
  )"

  # blank line at bottom for so cursor shift matches banners that are defined
  # with a heredoc and have a trailing blank line.
  TEXT="${TEXT}\n"

  shifted_banner "$TEXT" 42
}

##############################################################################
banner0() {
  IFS="" read -r -d '' TEXT << '__EOF'
%B%F{blue}
                     _..-----,._
                 .-|Q======-----!.
               .+|||P : : : : ~+||l
              .| |'|' '   ' : ;|| |)
             ||  | '        ' : | |'.
%F{magenta}-----------%F{blue} ;S :||'%F{magenta}  ·  ·    · · %F{blue}' ?l %F{magenta}-----------%F{blue}
            :|  |                  )|
            ||| '(                 "
            'H : |
             's+
               '|-
                 '-+
%f%b
__EOF
  shifted_banner "$TEXT" 29
}

##############################################################################
banner1() {
  REPEATED_TEXT="AIMEEBLE ZSH SHELL STARTUP"
  RAINBOW=(
    magenta
    red
    red-b
    yellow
    cyan
    yellow
    red-b
    red
    magenta
  )

  rainbow_banner "$REPEATED_TEXT" ${RAINBOW}
}

##############################################################################
banner2() {
  IFS="" read -r -d '' TEXT << '__EOF'
/ /                                     / /
|o|-------------------------------------|o|
| |                                     | |
|o| SHELL STARTUP REPORT:               |o|
| |                                     | |
|o| * zsh process launched              |o|
| |                                     | |
|o| * dotfiles loaded                   |o|
| |                                     | |
|o| * commencing execution . . .        |o|
| |                                     | |
|o|                                     |o|
| |                                     | |
|o|                                     |o|
| |-------------------------------------| |
/ /                                     / /
__EOF
  shifted_banner "$TEXT" 35
}

##############################################################################
banner3() {
  # Colours here work with my iTerm2 settings. Flag colours probably look
  # incorrect in other terminals ¯\_(ツ)_/¯
  RAINBOW=(
    117
    117
    219
    219
    015
    015
    219
    219
    117
    117
  )
  REPEATED_TEXT="█████████████████████████████████████"

  rainbow_banner "$REPEATED_TEXT" $RAINBOW
}

##############################################################################
banner4() {
  # Colours here work with my iTerm2 settings. Flag colours probably look
  # incorrect in other terminals ¯\_(ツ)_/¯
  RAINBOW=(
    001
    001
    215
    215
    011
    011
    034
    034
    027
    027
    128
    128
  )
  REPEATED_TEXT="█████████████████████████████████████"

  rainbow_banner "$REPEATED_TEXT" $RAINBOW
}


##############################################################################
banner5() {
  IFS="" read -r -d '' TEXT << '__EOF'
              %B%F{green}AIMEEBLE%f%b
          %F{green}AIME%BA%F{yellow}AAIMEEBLE%b%f
            %B%F{green}AAA%bAIMEEBLEE%f
         %B%F{green}AIAAAIMEEBLEELE%bE%f
          %F{green}AIM%BAIMEEBLEEE%b%F{yellow}LE%F{green}EEBLE%f
         %F{green}%BA%bAIME%BAI%bAIAIMEEBLEEEE%f
    %F{green}%BAAIMEEBLEEE%bE%F{yellow}/%F{green}A%BAIMEEBLELEEEBLE%b%f
   %F{green}%BA%bAIM%BAIMEEBLEE%F{yellow}/~%F{green}AIMAIMEEBLELE%bELE%BE%b%f
  %F{yellow}AIMEEBLE%F{green}E%F{yellow}%BE%F{green}L%bELE%F{yellow}\\/~| /%F{green}%BAIMEEBLE%F{yellow}E%F{green}EE%f%b
%F{yellow}AIMEEBLE%F{green}AIMEEBLELE%F{yellow}/~/%F{green}AI%F{yellow}%BAIMEEBLE%bE%F{green}BLE%f
     %F{green}%BAIMEAIMEEBLE  %b%F{yellow}/%B/~ %F{green}AIMEEBLEE%f%b
             %F{yellow}\\__%B\\_\\_%b/%B/~_%b\%f
                    %F{yellow}\\ %B/~%b%f
                     %F{yellow}/~~%f
       %B%F{black}:%F{green}___________%F{yellow}./~~~\.%F{green}___________%F{black}:%f%b
        %B%F{black}\\                           /%f%b
         %B%F{black}\\_________________________/%f%b
         %B%F{black}(_)                     (_)%f%b
__EOF
  shifted_banner "$TEXT" 41
}

##############################################################################
##############################################################################
##############################################################################
# Choose a random banner to display at startup.
BANNERS=(
  banner0
  banner1
  banner2
  banner3
  banner4
  banner5
)
RANDOM=$(date +%s)
BANNER_IDX=$(( $RANDOM % ${#BANNERS[@]} + 1 ))
BANNER=${BANNERS[$BANNER_IDX]}

ruler
$BANNER
