syn case match

syn keyword pbTodo       contained TODO FIXME XXX
syn cluster pbCommentGrp contains=pbTodo

syn keyword pbSyntax     syntax import option
syn keyword pbStructure  message group enum type
syn keyword pbRepeat     opt req rep
syn keyword pbDefault    default
syn keyword pbExtend     extend extensions to max
syn keyword pbRPC        service rpc returns

syn keyword pbType      int32 int64 uint32 uint64 sint32 sint64
syn keyword pbType      fixed32 fixed64 sfixed32 sfixed64
syn keyword pbType      float double boolean string bytes map
syn keyword pbBool      True False

syn match   pbInt     /-\?\<\d\+\>/
syn match   pbInt     /\<0[xX]\x+\>/
syn match   pbFloat   /\<-\?\d*\(\.\d*\)\?/
" TODO: .proto also supports C-style block comments;
" see /usr/share/vim/vim70/syntax/c.vim for how it's done.
syn region  pbComment start="//" skip="\\$" end="$" keepend contains=@pbCommentGrp
syn region  pbString  start=/"/ skip=/\\"/ end=/"/
syn region  pbString  start=/'/ skip=/\\'/ end=/'/
syn region  pbRpcParam matchgroup=pbBool start=/(/ skip=/\w\+/ end=/)/

if version >= 508 || !exists("did_proto_syn_inits")
  if version < 508
    let did_proto_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink pbTodo         Todo

  HiLink pbSyntax       Include
  HiLink pbStructure    Keyword
  HiLink pbRepeat       Repeat
  HiLink pbDefault      Keyword
  HiLink pbExtend       Keyword
  HiLink pbRPC          Keyword
  HiLink pbType         Type
  HiLink pbBool         Boolean

  HiLink pbInt          Number
  HiLink pbFloat        Float
  HiLink pbComment      Comment
  HiLink pbString       String
  HiLink pbRpcParam     Structure

  delcommand HiLink
endif

let b:current_syntax = "proto"
