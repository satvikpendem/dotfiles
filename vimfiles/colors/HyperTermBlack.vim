" Vim color file
"
" Author: Satvik Pendem <satvik.pendem@gmail.com>
" https://github.com/satvikpendem/HyperTermTheme-Vim
"
" Note: Based on the Monokai theme for TextMate
" by Wimer Hazenberg and its darker variant
" by Hamish Stuart Macpherson
"

hi clear

if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="hyper_term_black"

hi Boolean         guifg=#D8985F
hi Character       guifg=#D8985F
hi Number          guifg=#D8985F
hi String          guifg=#89CA78
hi Conditional     guifg=#D55FDE               gui=bold
hi Constant        guifg=#D8985F               gui=bold
hi Cursor          guifg=#000000 guibg=#F8F8F0
hi iCursor         guifg=#000000 guibg=#F8F8F0
hi Debug           guifg=#BCA3A3               gui=bold
hi Define          guifg=#FFFFFF
hi Delimiter       guifg=#495162

hi DiffAdd                       guibg=#13354A
hi DiffChange      guifg=#89807D guibg=#4C4745
hi DiffDelete      guifg=#960050 guibg=#1E0010
hi DiffText                      guibg=#4C4745 gui=italic,bold

hi Directory       guifg=#52ADF2               gui=bold
hi Error           guifg=#E6DB74 guibg=#1E0010
hi ErrorMsg        guifg=#D55FDE guibg=#000000 gui=bold
hi Exception       guifg=#52ADF2               gui=bold
hi Float           guifg=#D8985F
hi FoldColumn      guifg=#495162 guibg=#000000
hi Folded          guifg=#495162 guibg=#000000
hi Function        guifg=#52ADF2
hi Identifier      guifg=#FFFFFF
hi Ignore          guifg=#808080 guibg=bg
hi IncSearch       guifg=#D7FFAF guibg=#000000

hi Keyword         guifg=#D55FDE               gui=bold
hi Label           guifg=#E6DB74               gui=none
hi Macro           guifg=#D7FFAF               gui=italic
hi SpecialKey      guifg=#66D9EF               gui=italic

hi MatchParen      guifg=#000000 guibg=#52ADF2 gui=bold
hi ModeMsg         guifg=#E6DB74
hi MoreMsg         guifg=#E6DB74
hi Operator        guifg=#D55FDE

" complete menu
hi Pmenu           guifg=#66D9EF guibg=#000000
hi PmenuSel                      guibg=#000000
hi PmenuSbar                     guibg=#080808
hi PmenuThumb      guifg=#66D9EF

hi PreCondit       guifg=#52ADF2               gui=bold
hi PreProc         guifg=#52ADF2
hi Question        guifg=#66D9EF
hi Repeat          guifg=#D55FDE               gui=bold
hi Search          guifg=#000000 guibg=#FFE792
" marks
hi SignColumn      guifg=#52ADF2 guibg=#000000
hi SpecialChar     guifg=#D55FDE               gui=bold
hi SpecialComment  guifg=#495162               gui=bold
hi Special         guifg=#66D9EF guibg=bg      gui=italic
if has("spell")
    hi SpellBad    guisp=#FF0000 gui=undercurl
    hi SpellCap    guisp=#7070F0 gui=undercurl
    hi SpellLocal  guisp=#70F0F0 gui=undercurl
    hi SpellRare   guisp=#FFFFFF gui=undercurl
endif
hi Statement       guifg=#D55FDE               gui=bold
hi StatusLine      guifg=#000000 guibg=fg
hi StatusLineNC    guifg=#000000 guibg=#080808
hi StorageClass    guifg=#FFFFFF               gui=italic
hi Structure       guifg=#66D9EF
hi Tag             guifg=#D55FDE               gui=italic
hi Title           guifg=#FFFFFF
hi Todo            guifg=#FFFFFF guibg=bg      gui=bold

hi Typedef         guifg=#66D9EF
hi Type            guifg=#66D9EF               gui=none
hi Underlined      guifg=#000000               gui=underline

hi VertSplit       guifg=#000000 guibg=#080808 gui=bold
hi VisualNOS                     guibg=#403D3D
hi Visual                        guibg=#403D3D
hi WarningMsg      guifg=#FFFFFF guibg=#333333 gui=bold
hi WildMenu        guifg=#66D9EF guibg=#000000

hi TabLineFill     guifg=#000000 guibg=#000000
hi TabLine         guibg=#000000 guifg=#000000 gui=none

hi Normal          guifg=#FF5F5F guibg=#000000
hi Comment         guifg=#495162
hi CursorLine                    guibg=#030303
hi CursorLineNr    guifg=#FFFFFF               gui=none
hi CursorColumn                  guibg=#030303
hi ColorColumn                   guibg=#000000
hi LineNr          guifg=#495162 guibg=#000000
hi NonText         guifg=#495162
hi SpecialKey      guifg=#495162

"
" Support for 256-color terminal
"
if &t_Co > 255
   hi Normal          ctermfg=203 ctermbg=16
   hi CursorLine                  ctermbg=232   cterm=none
   hi CursorLineNr    ctermfg=231               cterm=none
   hi Boolean         ctermfg=179
   hi Character       ctermfg=114
   hi Number          ctermfg=179
   hi String          ctermfg=114
   hi Conditional     ctermfg=170               cterm=bold
   hi Constant        ctermfg=179               cterm=bold
   hi Cursor          ctermfg=16  ctermbg=231
   hi Debug           ctermfg=145               cterm=bold
   hi Define          ctermfg=81
   hi Delimiter       ctermfg=241

   hi DiffAdd                     ctermbg=236
   hi DiffChange      ctermfg=181 ctermbg=239
   hi DiffDelete      ctermfg=162 ctermbg=53
   hi DiffText                    ctermbg=102 cterm=bold

   hi Directory       ctermfg=75               cterm=bold
   hi Error           ctermfg=186 ctermbg=89
   hi ErrorMsg        ctermfg=170 ctermbg=16    cterm=bold
   hi Exception       ctermfg=75               cterm=bold
   hi Float           ctermfg=179
   hi FoldColumn      ctermfg=67  ctermbg=16
   hi Folded          ctermfg=67  ctermbg=16
   hi Function        ctermfg=75
   hi Identifier      ctermfg=231               cterm=none
   hi Ignore          ctermfg=244 ctermbg=232
   hi IncSearch       ctermfg=193 ctermbg=16

   hi keyword         ctermfg=170               cterm=bold
   hi Label           ctermfg=186               cterm=none
   hi Macro           ctermfg=193
   hi SpecialKey      ctermfg=81

   hi MatchParen      ctermfg=16  ctermbg=38 cterm=bold
   hi ModeMsg         ctermfg=186
   hi MoreMsg         ctermfg=186
   hi Operator        ctermfg=170

   " complete menu
   hi Pmenu           ctermfg=81  ctermbg=16
   hi PmenuSel        ctermfg=255 ctermbg=242
   hi PmenuSbar                   ctermbg=232
   hi PmenuThumb      ctermfg=81

   hi PreCondit       ctermfg=75               cterm=bold
   hi PreProc         ctermfg=75
   hi Question        ctermfg=81
   hi Repeat          ctermfg=170               cterm=bold
   hi Search          ctermfg=0   ctermbg=222   cterm=NONE

   " marks column
   hi SignColumn      ctermfg=75  ctermbg=235
   hi SpecialChar     ctermfg=170               cterm=bold
   hi SpecialComment  ctermfg=245               cterm=bold
   hi Special         ctermfg=81
   if has("spell")
       hi SpellBad                ctermbg=52
       hi SpellCap                ctermbg=17
       hi SpellLocal              ctermbg=17
       hi SpellRare  ctermfg=none ctermbg=none  cterm=reverse
   endif
   hi Statement       ctermfg=170               cterm=bold
   hi StatusLine      ctermfg=16  ctermbg=16
   hi StatusLineNC    ctermfg=16  ctermbg=232
   hi StorageClass    ctermfg=231
   hi Structure       ctermfg=81
   hi Tag             ctermfg=170
   hi Title           ctermfg=166
   hi Todo            ctermfg=231 ctermbg=232   cterm=bold

   hi Typedef         ctermfg=81
   hi Type            ctermfg=81                cterm=none
   hi Underlined      ctermfg=244               cterm=underline

   hi VertSplit       ctermfg=244 ctermbg=232   cterm=bold
   hi VisualNOS                   ctermbg=238
   hi Visual                      ctermbg=235
   hi WarningMsg      ctermfg=231 ctermbg=238   cterm=bold
   hi WildMenu        ctermfg=81  ctermbg=16

   hi Comment         ctermfg=59
   hi CursorColumn                ctermbg=236
   hi ColorColumn                 ctermbg=236
   hi LineNr          ctermfg=240 ctermbg=16
   hi NonText         ctermfg=239

   hi SpecialKey      ctermfg=59
end

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark
