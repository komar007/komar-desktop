set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'bling/vim-airline'
Plugin 'oblitum/rainbow'
Plugin 'komar007/gruvbox'
Plugin 'elzr/vim-json'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'airblade/vim-gitgutter'
Plugin 'rhysd/conflict-marker.vim'
call vundle#end()
filetype plugin indent on

syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set autoindent smartindent

set hlsearch

set grepprg=grep\ -nH\ $*

runtime! ftplugin/man.vim
colorscheme jellybeans-m
let g:gruvbox_italicize_comments=0
let g:gruvbox_underline=1
colorscheme gruvbox
set cursorline
set nu
set is
set wildmenu
set mouse=a

setlocal spelllang=pl
autocmd FileType latex setlocal spell

map <M-1> <Esc>1gt
map <M-2> <Esc>2gt
map <M-3> <Esc>3gt
map <M-4> <Esc>4gt
map <M-5> <Esc>5gt
map <M-6> <Esc>6gt
map <M-7> <Esc>7gt
map <M-8> <Esc>8gt
map <M-9> <Esc>9gt

autocmd FileType c,cpp compiler gcc
autocmd FileType c,cpp set formatoptions=tcqlron textwidth=78
autocmd FileType c,cpp set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType pascal compiler fpc
autocmd FileType haskell set expandtab
autocmd FileType java,cs,python,json set tabstop=4 shiftwidth=4 expandtab
autocmd FileType html,xhtml,eruby,xml set tabstop=2 shiftwidth=2 expandtab

nmap <F7> :wall<cr>:make %< <cr>
nmap <F8> :wall<cr>:make <cr>
nmap <F4> :cprev <cr>
nmap <F5> :cnext <cr>

highlight ExtraWhitespace ctermbg=red guibg=#902020
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=#902020
autocmd BufWinEnter * match ExtraWhitespace /\s\+$\|^\ [^*]?/
match ExtraWhitespace /\s\+$\|^\ [^*]?/

set cinoptions=:0,l1,t0,g0
set wildmode=longest,list,list,full

let g:Tex_DefaultTargetFormat = 'pdf'

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

:command FixStrays :%s/\(^\| \)\([auiwzoAUIWZO]\) /\1\2\~/g
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:rainbow_active = 1
set laststatus=2

let g:netrw_browsex_viewer = "chromium-browser"

autocmd BufNewFile,BufRead *.h,*.c set filetype=c
set tags=./tags;/
