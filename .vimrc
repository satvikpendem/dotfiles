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
endif

syntax on
colorscheme HyperTermBlack
set guifont=SF\ Mono\ Powerline:h10
set termguicolors

set cursorline
set number
set expandtab
set tabstop=2 shiftwidth=2

set mouse=a
