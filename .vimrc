" Detect OS
if !exists("g:os")
  if has("win64") || has("win32") || has("win16")
    let g:os = "Windows"
  else
    let g:os = substitute(system('uname'), '\n', '', '')
  endif
endif

if g:os == "Linux"
  set runtimepath^=/mnt/c/users/satvik/vimfiles runtimepath+=/mnt/c/users/satvik/vimfiles/after
  let &packpath=&runtimepath
elseif g:os == "Windows"
  set runtimepath^=~\vimfiles runtimepath+=~\vimfiles\after
  let &packpath=&runtimepath
endif

syntax on
set guifont=SF\ Mono\ Powerline:h10
set termguicolors
" colorscheme HyperTermBlack

set cursorline
set number
set expandtab
set tabstop=2 shiftwidth=2
set ignorecase
set smartcase
set mouse=a
set incsearch
set showmatch
set nowrap
set autochdir
set signcolumn=number
set updatetime=100

inoremap jk <esc>
nnoremap <CR> :let @/ = ""

" system clipboard
nmap <c-c> "+y
vmap <c-c> "+y
nmap <c-v> "+p
inoremap <c-v> <c-r>+
cnoremap <c-v> <c-r>+
" use <c-r> to insert original character without triggering things like auto-pairs
inoremap <c-r> <c-v>

""" CoC.nvim
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

