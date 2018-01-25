call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'w0rp/ale'
Plug 'fatih/vim-go'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-go', {'do': 'make'}

call plug#end()


" --------------------------------------------------------------------------------------------------
"
" Airline and Airline-theme
"
set statusline+=%#warningmsg#
set statusline+=%*

let g:airline_powerline_fonts = 1
"
" --------------------------------------------------------------------------------------------------


" --------------------------------------------------------------------------------------------------
"
" Deoplete
"
let g:deoplete#enable_at_startup = 1
"
" --------------------------------------------------------------------------------------------------


" --------------------------------------------------------------------------------------------------
"
" ALE
"
let g:ale_sign_column_always = 1

highlight ALEError ctermbg=none cterm=underline
highlight ALEWarning ctermbg=none cterm=underline
highlight clear SignColumn
"
" --------------------------------------------------------------------------------------------------


" --------------------------------------------------------------------------------------------------
"
" NerdTree
"
let NERDTreeIgnore = ['\.pyc$', '^__pycache__$']
"
" --------------------------------------------------------------------------------------------------


" --------------------------------------------------------------------------------------------------
"
" Custom key mappings
"
map <C-n> :NERDTreeToggle<CR>
map <C-h> :set hlsearch!<CR>
imap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
"
" --------------------------------------------------------------------------------------------------


" --------------------------------------------------------------------------------------------------
"
" Separated python host
"
let g:python_host_prog='~/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog='~/.pyenv/versions/neovim3/bin/python3'
"
" --------------------------------------------------------------------------------------------------


" --------------------------------------------------------------------------------------------------
"
" Other settings
"
set nu
set autoindent
set cindent
set ts=4
set sw=4
set expandtab
set bs=2

set laststatus=2
set ruler
set hlsearch

if has("termguicolors")
    set termguicolors
endif

set completeopt-=preview
colorscheme base16-tomorrow-night
"
" --------------------------------------------------------------------------------------------------
