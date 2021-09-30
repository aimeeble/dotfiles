" vim:foldmethod=marker


call plug#begin(stdpath('data') . '/plugged')

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'preservim/nerdtree'

Plug 'fatih/vim-go'
Plug 'hhvm/vim-hack'

call plug#end()


" General {{{
set nobackup
set ttyfast                      " faster redraw on new computers
set lazyredraw                   " don't redraw mid-macro
set showcmd                      " show typed commands
set showmode                     " show editing mode

set enc=utf-8
" }}}

" Searching {{{
set wildmode=longest,list        " make tab work like bash tab completion
set wildignore+=*.o,*~,*.pyc
set nohls                        " don't highlight search results
set is                           " search as you type
set ignorecase                   " ignore case during search...
set smartcase                    " ...unless you change case, then respect it
set gdefault                     " apply substitution to all occurrences
" }}}

" Decoration {{{
set cmdheight=1                  " command editor only 1 row
set laststatus=2                 " always show the status bar
set cursorline                   " highlight current line
set number                       " line numbering
set list                         " enable whitespace display
set listchars=tab:\|…,trail:·,extends:>,precedes:<,eol:¬,nbsp:%
set title                        " update terminal title bar

set stal=2                       " always show the tab bar
set sidescroll=1                 " scroll horizontally 1 cols at a time
set sidescrolloff=15             " 15 cols between cursor and screen edge causes scroll
set scrolloff=2                  " 2 rows between cursor and screen edge

hi CursorLine term=underline cterm=underline
hi CursorLineNr guifg=#ffffff ctermfg=white
hi LineNr guifg=#008000 ctermfg=darkgreen
hi SpecialKey guifg=#0030b0
hi NonText guifg=#0030b0

" }}}

" Editing {{{
set showmatch                    " highlight matching brace
set tabstop=8                    " tab stops set to 8 columns
set shiftwidth=2                 " auto-indent width
set softtabstop=2                " treat as a single tab wrt backspace                 testing long line colouring.... asdjfaskjf djla jdf
set expandtab                    " use spaces instead of tab character
set shiftround                   " auto-indent to multiples of shiftwidth
set hidden                       " allow unsaved bufs in the background
set nowrap                       " do not wrap long lines
set textwidth=0                  " no auto line wrap

set fo+=n                        " format numbered lists properly
set flp=^\\s*#\\=\\d\\+[\\]:.)}\\t\ ]\\s*   " standard + allow preceding number sign.

" spell checking
set spellfile=~/.vim/words.add
set spelllang=en_us

" }}}

" GUI Options {{{
" }}}

" Keybindings {{{
" Toggle spellcheck
map <silent> <F8> :set nospell!<CR>:set nospell?<CR>


set pastetoggle=<F5>            " Paste mode

" Move around by screen lines instead of file lines
nnoremap j gj
nnoremap k gk

" Bind jj to escape (pause after j if a second j is needed).
inoremap jj <ESC>

let mapleader=","

nnoremap <leader>n :NERDTreeToggle<CR>

" }}}

" Lua {{{
lua << EOF
require('lualine').setup{
  options = {
    icons_enabled = true,
    theme = 'material',
  },

  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      {'diff', color_added = '#83e88d', color_modified = '#ffcb6b', color_removed = '#ff5370'},
    },
    lualine_c = {
      {'filename', file_status = true, path = 1},
    },

    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {'filename', file_status = true, path = 1},
    },

    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {},
  },

  tabline = {
  },

  extensions = {
  },
}
require('nvim-web-devicons').setup()
EOF
" }}}

" vim-go settings {{{
let g:go_gopls_enabled = 1
let g:go_gopls_options = ['-remote=auto', '-debug=:7123']
let g:go_fmt_options = {'gofmt': '-s'}
let g:go_doc_popup_window = 1
let g:go_bin_path = getenv('HOME') . '/go/mono3/bin'
" let g:go_debug = ['lsp']

" }}}

if exists("~/.vimrc-local")
   source ~/.vimrc-local
endif
