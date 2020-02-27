call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
"Plug 'liuchengxu/vista.vim'

Plug 'majutsushi/tagbar'
Plug 'ronakg/quickr-cscope.vim'

Plug 'fatih/vim-go'

call plug#end()

"--------------------------------------------------------------------------------
" Airline and Airline-theme
set statusline+=%#warningmsg#
set statusline+=%*
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"--------------------------------------------------------------------------------

" -------------------------------------------------------------------------------
" NerdTree
let NERDTreeIgnore = ['\.pyc$', '^__pycache__$']
let g:NERDTreeFirst = 1
" -------------------------------------------------------------------------------

"--------------------------------------------------------------------------------
" Custom Key Mapping
noremap <silent> <expr> <C-n> g:NERDTreeFirst ? "\:let g:NERDTreeFirst = 0<CR> \:NERDTree<CR>" : g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" :
  \ bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
noremap <C-h> :set hlsearch!<CR>
noremap <F8> :TagbarToggle<CR>

noremap <C-j> :bprevious<Enter>
noremap <C-k> :bnext<Enter>
noremap <C-\> :call CloseBuffer()<CR>

nnoremap ; :FZF ~<CR>
"--------------------------------------------------------------------------------

"--------------------------------------------------------------------------------
" Seperated Python Host
let g:python_host_prog=expand('~/.pyenv/versions/neovim2/bin/python2')
let g:python3_host_prog=expand('~/.pyenv/versions/neovim3/bin/python3')
"--------------------------------------------------------------------------------

"--------------------------------------------------------------------------------
" Cscope Database Load
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  " else add the database pointed to by environment variable
  elseif $CSCOPE_DB != ""
    cs add &CSCOPE_DB
  endif
endfunction

let g:quickr_cscope_autoload_db = 0
au BufEnter * set nocscopeverbose
au BufEnter * exe "cs kill -1"
au BufEnter * call LoadCscope()
au BufEnter * set cscopeverbose
"--------------------------------------------------------------------------------

"--------------------------------------------------------------------------------
" custom function
function! CloseBuffer()
  let curBuf = bufnr('%')
  let curTab = tabpagenr()
  exe 'bnext'

  " If in last buffer, create empty buffer
  if curBuf == bufnr('%')
    exe 'enew'
  endif

  " Loop through tabs
  for i in range(tabpagenr('$'))
    " Go to tab (is there a way with inactiave tabs?)
    exe 'tabnext ' . (i + 1)
    " Store active window nr to restore later
    let curWin = winnr()
    " Loop through windows pointing to buffer
    let winnr = bufwinnr(curBuf)
    while (winnr >= 0)
      " Go to window and switch to next buffer
      exe winnr . 'wincmd w | bnext'
      " Restore active window
      exe curWin . 'wincmd w'
      let winnr = bufwinnr(curBuf)
    endwhile
  endfor

  " Close buffer, restore active tab
  exe 'bd' . curBuf
  exe 'tabnext ' . curTab
endfunction
"--------------------------------------------------------------------------------
"
"let g:asyncomplete_auto_popup = 0
"let g:lsp_signature_help_enabled = 0
"
"function! s:check_back_space() abort
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~ '\s'
"endfunction
"
"inoremap <silent><expr> <TAB> 
"  \ pumvisible() ? "\<C-n>" :
"  \ <SID>check_back_space() ? "\<TAB>" :
"  \ asyncomplete#force_refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"inoremap  <C-s> <Esc>:LspSignatureHelp<CR>a
"nnoremap  <C-s> :LspSignatureHelp<CR>
"
"if executable('gopls')
"  au User lsp_setup call lsp#register_server({
"        \ 'name': 'gopls',
"        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
"        \ 'whitelist': ['go'],
"        \ })
"  autocmd BufWritePre *.go LspDocumentFormatSync
"endif
"if executable('go-langserver')
"  au User lsp_setup call lsp#register_server({
"        \ 'name': 'go-langserver',
"        \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
"        \ 'whitelist': ['go'],
"        \ })
"  autocmd BufWritePre *.go LspDocumentFormatSync
"endif
"
"--------------------------------------------------------------------------------
" Other Setting
set nu
set autoindent
set cindent
set ts=2
set sw=2
set expandtab
set bs=2

set laststatus=2
set ruler
set hlsearch

set completeopt-=preview

if has("termguicolors")
  set termguicolors
endif
colorscheme base16-google-dark
