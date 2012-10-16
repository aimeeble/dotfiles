#
# Sends text to ame.io
#
# vim:ft=zsh
#

local LANG=""
local TITLE=""

local args="`getopt t:l: $*`"
if [ ! $? ]; then
   return
fi

for i; do
   case "$i" in
      -l)
         LANG="-F 'lang=$2'"
         echo "lang set to $2"
         shift
         shift
         ;;
      -t)
         TITLE="-F 'title=$2'"
         echo "title set to $2"
         shift
         shift
         ;;
      --)
         shift
         break
   esac
done

#echo "curl -F 'p=<-' $LANG $TITLE http://ame.io/new_paste"
eval "curl -F 'p=<-' $LANG $TITLE http://ame.io/new_paste"
