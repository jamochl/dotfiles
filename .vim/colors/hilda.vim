" Vim Hilda theme
" Author: James Lim
" Email: james.lim.ori@gmail.com

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

" your pick:
set background=dark	" or light
hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name="hilda"

let s:gui00  = "#282a2e"
let s:gui01  = "#da5b6f"
let s:gui02  = "#ba6e5b"
let s:gui03  = "#de935f"
let s:gui04  = "#6f8e61"
let s:gui05  = "#f8d3a4"
let s:gui06  = "#5a9d82"
let s:gui07  = "#f2f2f2"
let s:gui08  = "#6c6c6c"
let s:gui09  = "#f1747c"
let s:gui10  = "#e08872"
let s:gui11  = "#f0c674"
let s:gui12  = "#9bbb6e"
let s:gui13  = "#ffdeb4"
let s:gui14  = "#2ea89b"
let s:gui15  = "#f0f0f0"
             
function! Color(group,guibg,guifg,gui,ctermbg,ctermfg)
  let highlightstr = 'highlight ' . a:group . ' '
  let highlightstr .= 'guibg=' . a:guibg . ' '
  let highlightstr .= 'guifg=' . a:guifg . ' '
  let highlightstr .= 'gui=' . a:gui . ' '
  let highlightstr .= 'ctermbg=' . a:ctermbg . ' '
  let highlightstr .= 'ctermfg=' . a:ctermfg . ' '
  let highlightstr .= 'cterm=' . a:gui . ' '

  execute highlightstr
endfunction

" {{ Uncomment for green comments }}
call Color("Comment", "NONE", s:gui04, "NONE", "NONE", "4")
call Color("Normal", "NONE", s:gui07, "NONE", "NONE", "7")
call Color("Constant", "NONE", s:gui05, "NONE", "NONE", "5")
call Color("Character", "NONE", s:gui05, "NONE", "NONE", "5")
call Color("Number", "NONE", s:gui03, "NONE", "NONE", "3")
call Color("Boolean", "NONE", s:gui06, "NONE", "NONE", "6")
call Color("Identifier", "NONE", s:gui06, "NONE", "NONE", "6")
call Color("Function", "NONE", s:gui06, "bold", "NONE", "6")
call Color("Statement", "NONE", s:gui12, "italic", "NONE", "12")
" {{ Unsure as whether to bold }}
call Color("PreProc", "NONE", s:gui01, "NONE", "NONE", "1")
call Color("Type", "NONE", s:gui02, "bold", "NONE", "2")
call Color("StorageClass", "NONE", s:gui02, "italic", "NONE", "2")
hi! link Typedef StorageClass
call Color("Special", "NONE", s:gui10, "italic", "NONE", "10")
call Color("Underlined", "NONE", s:gui14, "underline", "NONE", "14")
call Color("Error", s:gui01, s:gui07, "standout", "1", "7")
call Color("Todo", s:gui11, s:gui00, "NONE", "11", "0")
call Color("ColorColumn", s:gui08, "NONE", "NONE", "245", "NONE")
call Color("CursorLine", s:gui00, "NONE", "NONE", "0", "NONE")
call Color("CursorColumn", s:gui08, "NONE", "NONE", "8", "NONE")
call Color("Directory", "NONE", s:gui04, "NONE", "NONE", "4")
call Color("DiffAdd", s:gui04, s:gui07, "NONE", "4", "7")
call Color("DiffChange", s:gui03, s:gui07, "NONE", "3", "7")
call Color("DiffDelete", s:gui01, s:gui07, "NONE", "1", "7")
call Color("DiffText", s:gui09, s:gui07, "NONE", "9", "7")
hi! link ErrorMsg Error
call Color("Folded", s:gui02, s:gui00, "italic", "2", "0")
hi! link FoldColumn Folded
call Color("VertSplit", s:gui00, s:gui07, "NONE", "0", "7")
call Color("LineNr", "NONE", s:gui11, "NONE", "NONE", "11")
call Color("LineNrAbove", "NONE", s:gui03, "NONE", "NONE", "3")
hi! link LineNrBelow LineNrAbove
hi! link CursorLineNr LineNrAbove
call Color("ModeMsg", "NONE", s:gui03, "NONE", "NONE", "3")
call Color("NonText", "NONE", s:gui12, "NONE", "NONE", "12")
call Color("Pmenu", s:gui02, s:gui00, "NONE", "2", "0")
call Color("PmenuSel", s:gui03, s:gui00, "NONE", "3", "0")
call Color("PmenuSbar", s:gui00, s:gui07, "NONE", "0", "7")
call Color("PmenuThumb", s:gui00, s:gui07, "NONE", "0", "7")
call Color("Search", s:gui02, s:gui07, "NONE", "2", "7")
call Color("SpecialKey", "NONE",s:gui07, "NONE", "NONE", "7")
call Color("StatusLine", s:gui00, s:gui07, "bold", "0", "7")
hi! link StatusLineTerm StatusLine
call Color("StatusLineNC", '#3a3a3a', s:gui15, "italic", "237", "15")
hi! link StatusLineTermNC StatusLineNC
call Color("TabLineSel", s:gui02, s:gui07, "NONE", "2", "7")
hi! link TabLineFill StatusLine
call Color("TabLine", s:gui00, s:gui07, "NONE", "0", "7")
call Color("Title", "NONE",s:gui04, "bold", "NONE", "4")
call Color("wildMenu", s:gui02, s:gui07, "NONE", "2", "7")
call Color("Menu", s:gui02, s:gui07, "NONE", "2", "7")
call Color("Visual", s:gui02, "NONE", "NONE", "2", "NONE")
