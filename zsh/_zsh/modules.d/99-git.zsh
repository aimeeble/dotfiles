_aimee_git_branch() {
   local BRANCH
   BRANCH=`git symbolic-ref HEAD 2>&1 | sed "s/refs\/heads\///"`

   echo "$BRANCH" | grep -qs fatal
   if [ $? -eq 0 ]; then
      return
   else
      if [ -n "$1" ]; then
         echo "git:${BRANCH} "
         return
      fi
      print "git:%B%F{yellow}%{${BRANCH}%}%${#BRANCH}G%f%b "
   fi
}

_aimee_git_init() {
  module_add_prompt_fragment _aimee_git_branch
}

module_add "git" _aimee_git_init
