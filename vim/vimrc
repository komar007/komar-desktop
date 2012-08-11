set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set autoindent smartindent
set smarttab

set grepprg=grep\ -nH\ $*

function Html()
	set tabstop=2
	set shiftwidth=2
endfunction

runtime! ftplugin/man.vim
autocmd FileType html,xhtml,eruby call Html()
colorscheme desert
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
autocmd FileType pascal compiler fpc
autocmd FileType haskell set expandtab
autocmd FileType java set tabstop=4 shiftwidth=4 expandtab

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
