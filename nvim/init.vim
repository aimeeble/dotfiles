" vim:foldmethod=marker

call plug#begin(stdpath('data') . '/plugged')

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'preservim/nerdtree'
Plug 'neovim/nvim-lspconfig'
Plug 'jbyuki/venn.nvim'
Plug 'uarun/vim-protobuf'
Plug 'airblade/vim-gitgutter'
Plug 'gagoar/StripWhiteSpaces'

" Language plugins
Plug 'fatih/vim-go'

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

set termguicolors                " enable many colours in terminal.
colorscheme darkblue

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

" Generic keybindings {{{
" Toggle spellcheck
map <silent> <F8> :set nospell!<CR>:set nospell?<CR>

if !has('nvim-0.9')
  set pastetoggle=<F5>            " Paste mode
endif

" Move around by screen lines instead of file lines
nnoremap j gj
nnoremap k gk

" Bind jj to escape (pause after j if a second j is needed).
inoremap jj <ESC>

let mapleader=","
" }}}

" NERDtree {{{
nnoremap <leader>n :NERDTreeToggle<CR>
" }}}

" lsp-config {{{
lua << EOF
local custom_lsp_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = {noremap=true, silent=true}

  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  buf_set_keymap('n', '<leader>i', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<cr>', opts)

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

require('lspconfig').ccls.setup {
  init_options = {
    compilationDatabaseDirectory = "bazel-bin",
  },
  on_attach = custom_lsp_attach,
}

require'lspconfig'.rust_analyzer.setup({
  on_attach = custom_lsp_attach,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = 'module',
        },
        prefix = 'self',
      },
      cargo= {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = false,
      }
    }
  }
})

EOF
" }}}

" diagnostic {{{

lua << EOF

vim.diagnostic.config(
  {
    virtual_text = true,
  }
)

EOF

" }}}

" lualine {{{
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

" venn.nvim {{{
lua << EOF
function _G.toggle_venn()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if (venn_enabled == "nil") then
    vim.b.venn_enabled = true
    vim.cmd[[setlocal ve=all]]
    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap=true})
    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap=true})
    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap=true})
    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap=true})
    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap=true})
  else
    vim.cmd[[setlocal ve=]]
    vim.cmd[[mapclear <buffer>]]
    vim.b.venn_enabled = nil
  end
end


EOF
nnoremap <leader>v :lua toggle_venn()<CR>

" }}}

" gitgutter {{{
let g:gitgutter_override_sign_column_highlight = 1
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = 'v'

hi SignColumn ctermbg=black guibg=black
" }}}

" neovide graphical goodness {{{
let g:neovide_cursor_vfx_mode                 = "torpedo"
let g:neovide_cursor_vfx_opacity              = 200.0
let g:neovide_cursor_vfx_particle_curl        = 0.1
let g:neovide_cursor_vfx_particle_phase       = 1.5
let g:neovide_cursor_vfx_particle_speed       = 10.0
let g:neovide_cursor_animate_command_line     = v:true
let g:neovide_cursor_animate_in_insert_mode   = v:true

let g:neovide_hide_mouse_while_typing         = v:true
" }}}


if exists("~/.vimrc-local")
   source ~/.vimrc-local
endif
