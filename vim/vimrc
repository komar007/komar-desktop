set nocompatible

filetype off

" -- plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'luochen1990/rainbow'
Plugin 'morhetz/gruvbox'
Plugin 'elzr/vim-json'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'airblade/vim-gitgutter'
Plugin 'rhysd/conflict-marker.vim'
Plugin 'vim-scripts/cscope_macros.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'PeterRincker/vim-argumentative'
Plugin 'wellle/targets.vim'
Plugin 'cloudhead/neovim-fuzzy'
Plugin 'tpope/vim-sleuth'
Plugin 'vim-scripts/a.vim'
Plugin 'bogado/file-line'
Plugin 'vim-scripts/camelcasemotion'
call vundle#end()

set updatetime=250

filetype plugin indent on

" -- basic behaviour
set hidden
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set sessionoptions=buffers
set ignorecase smartcase
set autoindent smartindent
set hlsearch incsearch
set grepprg=grep\ -nH\ $*
set cinoptions=:0,l1,t0,g0,N-s

autocmd BufEnter * let &titlestring = "vim - " . expand("%:t")
set title

" -- look and feel
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_italicize_comments=0
let g:gruvbox_underline=1
colorscheme gruvbox
set background=dark
set cursorline
set number
set wildmenu
set wildmode=longest,list,list,full
set mouse=a
set timeoutlen=500

setlocal spelllang=pl

map <F2> :set cursorcolumn!<CR>

" -- filetype customs
autocmd FileType latex                setlocal spell
autocmd FileType c,cpp                compiler gcc
autocmd FileType c,cpp                set formatoptions=tcqlronj textwidth=78
autocmd FileType c,cpp                set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType c,cpp                set errorformat=%f:%l:%c:\ error:\ %m,%f:%l:%c:\ warning:\ %m

nmap <Leader> :A<CR>

autocmd FileType pascal               compiler fpc
autocmd FileType haskell              set expandtab
autocmd FileType java,cs,python,json  set tabstop=4 shiftwidth=4 expandtab
autocmd FileType make                 set tabstop=8 shiftwidth=8 noexpandtab
autocmd FileType html,xhtml,eruby,xml set tabstop=2 shiftwidth=2 expandtab

autocmd BufNewFile,BufRead *.h,*.c set filetype=c

nnoremap <Leader>y mY"*yiw`Y

nmap <F7> :wall<cr>:make %< <cr>
nmap <F8> :wall<cr>:make <cr>
nmap <F4> :cprev <cr>
nmap <F5> :cnext <cr>

" -- highlighting stray whitespace
highlight ExtraWhitespace ctermbg=red guibg=#902020
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=#902020
autocmd BufWinEnter * match ExtraWhitespace /\s\+$\|^\ [^*]?/
match ExtraWhitespace /\s\+$\|^\ [^*]?/

let g:Tex_DefaultTargetFormat = 'pdf'

" -- snippet config [DEPRECATED]
function! ReloadSnippets( snippets_dir, ft )
    if strlen( a:ft ) == 0
        let filetype = "_"
    else
        let filetype = a:ft
    endif

    call ResetSnippets()
    call GetSnippets( a:snippets_dir, filetype )
endfunction

nmap ,rr :call ReloadSnippets(snippets_dir, &filetype)<CR>

:command SanitizeXML :%s/>/>\r/g | :%s/</\r</g | :%g/^\s*$/d | :normal gg=G
:command FixStrays :%s/\(^\| \)\([auiwzoAUIWZO]\) /\1\2\~/g

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:rainbow_active = 1
let g:rainbow_conf = {
\   'parentheses': [
\       'start=/(/ end=/)/ fold',
\       'start=/\[/ end=/\]/ fold',
\       'start=/{/ end=/}/ fold'
\   ],
\   'ctermfgs': [
\       'brown',
\       'Darkblue',
\       'darkgray',
\       'darkgreen',
\       'darkcyan',
\       'darkred',
\       'darkmagenta',
\       'brown',
\       'gray',
\       'black',
\       'darkmagenta',
\       'Darkblue',
\       'darkgreen',
\       'darkcyan',
\       'darkred',
\       'red',
\       'blue',
\       'green',
\       'yellow',
\       'cyan',
\       'magenta',
\       'lightblue',
\       'lightgreen',
\       'lightyellow',
\       'lightcyan',
\       'lightmagenta'
\    ],
\   'operators': '_,\|;\|==\|!=\|!\||\|&\|\^\|\~\|+\|-\|:\|?\|=\|*\|->\|\.\|<\|>_'
\}

set laststatus=2

let g:netrw_browsex_viewer = "chromium-browser"

set tags=./tags;/

nnoremap <C-p> :FuzzyOpen<CR>

set sessionoptions=blank,buffers,curdir,folds,tabpages,localoptions

if has("nvim")
    set inccommand=split
endif

set fillchars=vert:┆

let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_added = "▕▐"
let g:gitgutter_sign_removed = "▁▁"
let g:gitgutter_sign_modified = "▕▐"
let g:gitgutter_sign_modified_removed = "▕▁"
let g:gitgutter_sign_removed_first_line = "▔"
let g:gitgutter_eager = 1
let g:gitgutter_realtime = 1
highlight GitGutterAdd ctermfg=71 ctermbg=237
highlight GitGutterChange ctermfg=214 ctermbg=237
highlight GitGutterChangeDelete ctermfg=208 ctermbg=237
