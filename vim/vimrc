set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set grepprg=grep\ -nH\ $*

function RubyEndToken ()
    let current_line = getline( '.' )
    let braces_at_end = '{\s*\(|\(,\|\s\|\w\)*|\s*\)\?$'
    let stuff_without_do = '^\s*\(class\|if\|unless\|begin\|case\|for\|module\|while\|until\|def\)'
    let with_do = 'do\s*\(|\(,\|\s\|\w\)*|\s*\)\?$'

    if match(current_line, braces_at_end) >= 0
        return "\<CR>}\<C-O>O" 
    elseif match(current_line, stuff_without_do) >= 0
        return "\<CR>end\<C-O>O" 
    elseif match(current_line, with_do) >= 0
        return "\<CR>end\<C-O>O" 
    else
        return "\<CR>" 
    endif
endfunction

function UseRubyIndent ()
	"setlocal tabstop=8
"    setlocal softtabstop=2
"    setlocal shiftwidth=2
"  setlocal expandtab

"    imap <buffer> <CR> <C-R>=RubyEndToken()<CR>
endfunction

function Html()
	set tabstop=2
	set shiftwidth=2
endfunction

runtime! ftplugin/man.vim
autocmd FileType ruby,eruby call UseRubyIndent()
autocmd FileType html,xhtml,eruby call Html()
colorscheme desert
set nu
set gfn=Monospace\ 8
set is
set wildmenu
set mouse=a
unmenu ToolBar
unmenu! ToolBar

"Temoporary
set tabstop=4
set shiftwidth=4
setlocal spelllang=pl 
" setlocal spell
"
map <M-1> <Esc>1gt<CR>
map <M-2> <Esc>2gt<CR>
map <M-3> <Esc>3gt<CR>
map <M-4> <Esc>4gt<CR>
map <M-5> <Esc>5gt<CR>
map <M-6> <Esc>6gt<CR>
map <M-7> <Esc>7gt<CR>
map <M-8> <Esc>8gt<CR>
map <M-9> <Esc>9gt<CR>

" Find file in current directory and edit it.
function! Find(name)
  let l:list=system("find . -name '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":e ".l:line
endfunction
command! -nargs=1 Find :call Find("")

python << EOL
import vim

def Finder(*args):
    start_dir = vim.eval('getcwd()')
    find_cmd = (r'find %s -iname "*%s*" ! -name "*.svn*" -type f -printf %%p:1:-\\n' % (start_dir, args[0]))
    vim.command("cgete system('%s')" % find_cmd)
    vim.command('botright copen')
EOL
command! -nargs=1 Find :py Finder("")

map! <C-f> <Esc>:Find 
map  <C-f> :Find  

autocmd FileType pascal compiler fpc

nmap <F7> :wall<cr>:make %< <cr>
nmap <F8> :wall<cr>:make <cr>
nmap <F5> :cprev <cr>
nmap <F4> :cnext <cr>

