" Vim color scheme
" Name:         vividchalk.vim
" Author:       Tim Pope <vimNOSPAM@tpope.info>
" GetLatestVimScripts: 1891 1 :AutoInstall: vividchalk.vim
" $Id: vividchalk.vim,v 1.7 2007/05/30 23:30:50 tpope Exp $

" Based on the Vibrank Ink theme for TextMate

if has("gui_running")
    set background=dark
endif
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name = "vividchalk-m"

" First two functions adapted from inkpot.vim

" map a urxvt cube number to an xterm-256 cube number
fun! s:M(a)
    return strpart("0245", a:a, 1) + 0
endfun

" map a urxvt colour to an xterm-256 colour
fun! s:X(a)
    if &t_Co == 88
        return a:a
    else
        if a:a == 8
            return 237
        elseif a:a < 16
            return a:a
        elseif a:a > 79
            return 232 + (3 * (a:a - 80))
        else
            let l:b = a:a - 16
            let l:x = l:b % 4
            let l:y = (l:b / 4) % 4
            let l:z = (l:b / 16)
            return 16 + s:M(l:x) + (6 * s:M(l:y)) + (36 * s:M(l:z))
        endif
    endif
endfun

function! E2T(a)
    return s:X(a:a)
endfunction

function! s:choose(mediocre,good)
    if &t_Co != 88 && &t_Co != 256
        return a:mediocre
    else
        return s:X(a:good)
    endif
endfunction

function! s:hifg(group,guifg,first,second,...)
    if a:0 && &t_Co == 256
        let ctermfg = a:1
    else
        let ctermfg = s:choose(a:first,a:second)
    endif
    exe "highlight ".a:group." guifg=".a:guifg." ctermfg=".ctermfg
endfunction

function! s:hibg(group,guibg,first,second)
    let ctermbg = s:choose(a:first,a:second)
    exe "highlight ".a:group." guibg=".a:guibg." ctermbg=".ctermbg
endfunction

hi link railsMethod         PreProc
hi link rubyDefine          Keyword
hi link rubySymbol          Constant
hi link rubyAccess          rubyMethod
hi link rubyAttribute       rubyMethod
hi link rubyEval            rubyMethod
hi link rubyException       rubyMethod
hi link rubyInclude         rubyMethod
hi link rubyStringDelimiter rubyString
hi link rubyRegexp          Regexp
hi link rubyRegexpDelimiter rubyRegexp
"hi link rubyConstant        Variable
"hi link rubyGlobalVariable  Variable
"hi link rubyClassVariable   Variable
"hi link rubyInstanceVariable Variable
hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

call s:hifg("Normal","#FFFFFF","White",87)
if &background == "light" || has("gui_running")
    hi Normal guibg=Black ctermbg=Black
else
    hi Normal guibg=Black ctermbg=NONE
endif
highlight StatusLine    guifg=Black   guibg=#aabbee gui=bold ctermfg=Black ctermbg=White  cterm=bold
highlight StatusLineNC  guifg=#444444 guibg=#aaaaaa gui=none ctermfg=Black ctermbg=Grey   cterm=none
"if &t_Co == 256
    "highlight StatusLine ctermbg=117
"else
    "highlight StatusLine ctermbg=43
"endif
highlight WildMenu      guifg=Black   guibg=#ffff00 gui=bold ctermfg=Black ctermbg=Yellow cterm=bold
highlight Cursor        guifg=Black guibg=#d3d7cf ctermfg=Black ctermbg=White
highlight CursorLine    guibg=#333333 guifg=NONE
highlight CursorColumn  guibg=#333333 guifg=NONE
highlight NonText       guifg=#555753 ctermfg=8
highlight SpecialKey    guifg=#555753 ctermfg=8
highlight Directory     none
high link Directory     Identifier
highlight ErrorMsg      guibg=#a40000 ctermbg=DarkRed guifg=NONE ctermfg=NONE
highlight Search        guifg=NONE ctermfg=NONE gui=none cterm=none
call s:hibg("Search"    ,"#555555","Black",81)
highlight IncSearch     guifg=#d3d7cf guibg=Black ctermfg=White ctermbg=Black
highlight MoreMsg       guifg=#73d216 ctermfg=Green
highlight LineNr        guifg=#d3d7cf ctermfg=White
call s:hibg("LineNr"    ,"#204a87","DarkBlue",80)
highlight Question      none
high link Question      MoreMsg
highlight Title         guifg=#f57900 ctermfg=Magenta
highlight VisualNOS     gui=none cterm=none
call s:hibg("Visual"    ,"#3465a4","LightBlue",83)
call s:hibg("VisualNOS" ,"#204a87","DarkBlue",81)
highlight WarningMsg    guifg=#cc0000 ctermfg=Red
highlight Folded        guibg=#204a87 ctermbg=DarkBlue
call s:hibg("Folded"    ,"#204a87","DarkBlue",17)
call s:hifg("Folded"    ,"#05d2c1","LightCyan",63)
highlight FoldColumn    none
high link FoldColumn    Folded
highlight Pmenu         guifg=#d3d7cf ctermfg=White gui=bold cterm=bold
highlight PmenuSel      guifg=#d3d7cf ctermfg=White gui=bold cterm=bold
call s:hibg("Pmenu"     ,"#3465a4","Blue",18)
call s:hibg("PmenuSel"  ,"#038e82","DarkCyan",39)
highlight PmenuSbar     guibg=#666862 ctermbg=Grey
"AAAAAasda^
highlight PmenuThumb    guibg=#d3d7cf ctermbg=White
highlight TabLine       gui=underline cterm=underline
call s:hifg("TabLine"   ,"#babdb6","LightGrey",85)
call s:hibg("TabLine"   ,"#555753","DarkGrey",80)
highlight TabLineSel    guifg=#d3d7cf guibg=Black ctermfg=White ctermbg=Black
highlight TabLineFill   gui=underline cterm=underline
call s:hifg("TabLineFill","#babdb6","LightGrey",85)
call s:hibg("TabLineFill","#666862","Grey",83)



hi Type gui=none
hi railsUserClass  gui=italic,underline cterm=underline
hi railsUserMethod gui=italic cterm=underline
hi Statement gui=bold
hi Comment gui=italic
hi Identifier cterm=none
" Commented numbers at the end are *old* 256 color values
"highlight PreProc       guifg=#EDF8F9
call s:hifg("Comment"        ,"#ce5c00","DarkMagenta",34) " 92
" 26 instead?
call s:hifg("Constant"       ,"#038e82","DarkCyan",21) " 30
call s:hifg("rubyNumber"     ,"#edd400","Yellow",60) " 190
call s:hifg("String"         ,"#83e226","LightGreen",44,82) " 82
call s:hifg("Identifier"     ,"#edd400","Yellow",72) " 220
call s:hifg("Statement"      ,"#FF6600","Brown",68) " 202
call s:hifg("PreProc"        ,"#05d2c1","LightCyan",47) " 213
call s:hifg("railsUserMethod","#05d2c1","LightCyan",27)
call s:hifg("Type"           ,"#666862","Grey",57) " 101
call s:hifg("railsUserClass" ,"#666862","Grey",57) " 101
call s:hifg("Special"        ,"#4e9a06","DarkGreen",24) " 7
call s:hifg("Regexp"         ,"#038e82","DarkCyan",21) " 74
call s:hifg("rubyMethod"     ,"#edd400","Yellow",77) " 191
"highlight railsMethod   guifg=#EE1122 ctermfg=1


highlight rubyRailsARAssociationMethod guifg=#ff0000
highlight rubyRailsARCallbackMethod guifg=#ff0000
highlight rubyRailsARClassMethod guifg=#ff0000
highlight rubyRailsARValidationMethod guifg=#ff0000
