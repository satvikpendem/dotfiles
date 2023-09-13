
" If you are distributing this theme, please replace this comment
" with the appropriate license attributing the original VS Code
" theme author.


" Hyper Term Black - A nice dark theme

" ==========> Reset
set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'hyper-term-black'

" ==========> Highlight function
function! s:h(face, guibg, guifg, ctermbg, ctermfg, gui)
  let l:cmd="highlight " . a:face
  
  if a:guibg != ""
    let l:cmd = l:cmd . " guibg=" . a:guibg
  endif

  if a:guifg != ""
    let l:cmd = l:cmd . " guifg=" . a:guifg
  endif

  if a:ctermbg != ""
    let l:cmd = l:cmd . " ctermbg=" . a:ctermbg
  endif

  if a:ctermfg != ""
    let l:cmd = l:cmd . " ctermfg=" . a:ctermfg
  endif

  if a:gui != ""
    let l:cmd = l:cmd . " gui=" . a:gui
  endif

  exec l:cmd
endfun


" ==========> Colors dictionary

" GUI colors dictionary (hex)
let s:hex = {}
" Terminal colors dictionary (256)
let s:bit = {}

let s:hex.color0="#000000"
let s:hex.color1="#C8C8C8"
let s:hex.color2="#14FA50"
let s:hex.color3="#484e5b"
let s:hex.color4="#0a0a0a"
let s:hex.color5="#323232"
let s:hex.color6="#141414"
let s:hex.color7="#464646"
let s:hex.color8="#b1b9c8"
let s:hex.color9="#2d2d2d"
let s:hex.color10="#cad2e1"
let s:hex.color11="#4b4b4b"
let s:hex.color12="#1e1e1e"
let s:hex.color13="#e6e6e6"
let s:hex.color14="#d2d2d2"
let s:hex.color15="#232323"
let s:hex.color16="#D8985F"
let s:hex.color17="#EF596F"
let s:hex.color18="#D55FDE"
let s:hex.color19="#AAB1C0"

let s:bit.color0="16"
let s:bit.color2="47"
let s:bit.color16="170"
let s:bit.color14="173"
let s:bit.color9="188"
let s:bit.color15="203"
let s:bit.color4="232"
let s:bit.color6="233"
let s:bit.color10="234"
let s:bit.color13="235"
let s:bit.color5="236"
let s:bit.color7="238"
let s:bit.color3="239"
let s:bit.color17="249"
let s:bit.color8="250"
let s:bit.color1="251"
let s:bit.color12="252"
let s:bit.color11="254"


" ==========> General highlights 
call s:h("Normal", s:hex.color0, s:hex.color1, s:bit.color0, s:bit.color1, "none")
call s:h("Cursor", s:hex.color2, "", s:bit.color2, "", "none")
call s:h("Visual", s:hex.color3, "", s:bit.color3, "", "none")
call s:h("ColorColumn", s:hex.color4, "", s:bit.color4, "", "none")
call s:h("LineNr", "", s:hex.color5, "", s:bit.color5, "none")
call s:h("CursorLine", s:hex.color6, "", s:bit.color6, "", "none")
call s:h("CursorLineNr", "", s:hex.color7, "", s:bit.color7, "none")
call s:h("CursorColumn", s:hex.color6, "", s:bit.color6, "", "none")
call s:h("StatusLineNC", s:hex.color6, s:hex.color8, s:bit.color6, s:bit.color8, "none")
call s:h("StatusLine", s:hex.color9, s:hex.color10, s:bit.color5, s:bit.color9, "none")
call s:h("VertSplit", "", s:hex.color11, "", s:bit.color3, "none")
call s:h("Folded", s:hex.color6, "", s:bit.color6, "", "none")
call s:h("Pmenu", s:hex.color12, s:hex.color13, s:bit.color10, s:bit.color11, "none")
call s:h("PmenuSel", s:hex.color4, s:hex.color14, s:bit.color4, s:bit.color12, "none")
call s:h("EndOfBuffer", s:hex.color0, s:hex.color15, s:bit.color0, s:bit.color13, "none")
call s:h("NonText", s:hex.color0, s:hex.color15, s:bit.color0, s:bit.color13, "none")


" ==========> Syntax highlights
call s:h("Constant", "", s:hex.color16, "", s:bit.color14, "none")
call s:h("Special", "", s:hex.color16, "", s:bit.color14, "none")
call s:h("Identifier", "", s:hex.color17, "", s:bit.color15, "none")
call s:h("Statement", "", s:hex.color18, "", s:bit.color16, "none")
call s:h("Operator", "", s:hex.color19, "", s:bit.color17, "none")
call s:h("PreProc", "", s:hex.color18, "", s:bit.color16, "none")
call s:h("Type", "", s:hex.color18, "", s:bit.color16, "none")
call s:h("Number", "", s:hex.color16, "", s:bit.color14, "none")

highlight link cStatement Statement
highlight link cSpecial Special


" Generated using https://github.com/nice/themeforge
" Feel free to remove the above URL and this line.
