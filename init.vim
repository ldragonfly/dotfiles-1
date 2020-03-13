call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'liuchengxu/vista.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'fatih/vim-go'
Plug 'Vimjas/vim-python-pep8-indent'

"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'

"Plug 'majutsushi/tagbar'
"Plug 'ronakg/quickr-cscope.vim'


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
"noremap <silent> <expr> <C-n> g:NERDTreeFirst ? "\:let g:NERDTreeFirst = 0<CR> \:NERDTree<CR>" : g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" :
"  \ bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
noremap <silent> <C-n> : :CocCommand explorer<CR>
noremap <C-h> :set hlsearch!<CR>
noremap <silent> <F8> :Vista!!<CR>
noremap <silent> . :Vista finder<CR>

noremap <C-j> :bprevious<Enter>
noremap <C-k> :bnext<Enter>
noremap <C-\> :call CloseBuffer()<CR>

tnoremap <C-w> <C-\><C-n><C-w>
tnoremap <C-\> <C-d>

autocmd FileType python noremap <buffer><silent><C-x> :CocCommand python.execSelectionInTerminal<CR>

"nnoremap ; :FZF ~<CR>
"--------------------------------------------------------------------------------

"--------------------------------------------------------------------------------
" Seperated Python Host
let g:python_host_prog=expand('~/.pyenv/versions/neovim2/bin/python2')
let g:python3_host_prog=expand('~/.pyenv/versions/neovim3/bin/python3')
"--------------------------------------------------------------------------------

"--------------------------------------------------------------------------------
" Cscope Database Load
"function! LoadCscope()
"  let db = findfile("cscope.out", ".;")
"  if (!empty(db))
"    let path = strpart(db, 0, match(db, "/cscope.out$"))
"    set nocscopeverbose " suppress 'duplicate connection' error
"    exe "cs add " . db . " " . path
"    set cscopeverbose
"  " else add the database pointed to by environment variable
"  elseif $CSCOPE_DB != ""
"    cs add &CSCOPE_DB
"  endif
"endfunction
"
"let g:quickr_cscope_autoload_db = 0
"au BufEnter * set nocscopeverbose
"au BufEnter * exe "cs kill -1"
"au BufEnter * call LoadCscope()
"au BufEnter * set cscopeverbose
"--------------------------------------------------------------------------------

" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works the LSP executives, doesn't work for `:Vista ctags`.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'coc'

" To enable fzf's preview window set g:vista_fzf_preview.
" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
" For example:
let g:vista_fzf_preview = ['right:50%']

" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1

let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

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
" coc.nvim setting

let g:LanguageClient_serverCommands = {
    \ 'sh': ['bash-language-server', 'start']
    \ }

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
"--------------------------------------------------------------------------------



set nu
set expandtab
set autoindent
set cindent
set ts=2
set sw=2
set bs=2

set laststatus=2
set ruler
set hlsearch

set completeopt-=preview

if has("termguicolors")
  set termguicolors
endif
colorscheme base16-google-dark
