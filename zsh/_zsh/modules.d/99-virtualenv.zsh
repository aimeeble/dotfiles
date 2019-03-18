_virtual_env_prompt() {
   if [ -z "$VIRTUAL_ENV" ]; then
      return
   fi
   if [ -z "$1" ]; then
      print "%F{red}`basename ${VIRTUAL_ENV}`%f "
   else
      echo "`basename ${VIRTUAL_ENV}` "
   fi
}

_virtenv_init() {
   # Python virtualenv
   local VENV="/usr/local/share/python/virtualenvwrapper.sh"
   [ -f $VENV ] && . $VENV
   local VENV="/usr/local/bin/virtualenvwrapper.sh"
   [ -f $VENV ] && . $VENV

   module_add_prompt_fragment _virtual_env_prompt
}

module_add "virtualenv" _virtenv_init
