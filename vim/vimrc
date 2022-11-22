set nocompatible
filetype off

call plug#begin()
Plug 'nvim-lualine/lualine.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'elzr/vim-json'
Plug 'hynek/vim-python-pep8-indent'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/conflict-marker.vim'
Plug 'vim-scripts/cscope_macros.vim'
Plug 'tpope/vim-fugitive'
Plug 'PeterRincker/vim-argumentative'
Plug 'wellle/targets.vim'
Plug 'cloudhead/neovim-fuzzy'
Plug 'tpope/vim-sleuth'
Plug 'vim-scripts/a.vim'
Plug 'bogado/file-line'
Plug 'vim-scripts/camelcasemotion'
Plug 'mzlogin/vim-markdown-toc'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-lua/plenary.nvim' " for telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'inkarkat/vim-ingo-library' " required by inkarkat/vim-EnhancedJumps
Plug 'inkarkat/vim-EnhancedJumps'
call plug#end()

" -- neovide
set gfn=Jetbrains\ Mono:h8.5
let g:neovide_cursor_animation_length=0.07
let g:neovide_cursor_trail_size=0.05

filetype plugin indent on

" -- basic behaviour
set hidden
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set sessionoptions=buffers,curdir,folds,tabpages
set ignorecase smartcase
set autoindent smartindent
set hlsearch incsearch
set grepprg=grep\ -nH\ $*
set cinoptions=:0,l1,t0,g0,N-s

autocmd BufEnter * let &titlestring = "vim - " . expand("%:t")
set title

" -- look and feel
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_italicize_comments=1
let g:gruvbox_underline=1
let g:gruvbox_italic=1
colorscheme gruvbox
set background=dark
highlight Comment ctermfg=243 guifg=#7f7f7f
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
autocmd FileType c,cpp,rust           set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
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

:command SanitizeXML :%s/>/>\r/g | :%s/</\r</g | :%g/^\s*$/d | :normal gg=G
:command FixStrays :%s/\(^\| \)\([auiwzoAUIWZO]\) /\1\2\~/g

set laststatus=2

let g:netrw_browsex_viewer = "chromium-browser"

set tags=./tags;/

" easier combo than ctrl+shift+6
nnoremap <silent> <C-6> <C-^>

if has("nvim")
    set inccommand=split
endif

set fillchars=vert:┆

" signs/gutter
set signcolumn=yes
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_added = "▍"
let g:gitgutter_sign_removed = "◢"
let g:gitgutter_sign_modified = "▍"
let g:gitgutter_sign_modified_removed = "▍"
let g:gitgutter_sign_removed_first_line = "◥"
let g:gitgutter_eager = 1
let g:gitgutter_realtime = 1
highlight GitGutterAdd ctermfg=71 guifg=#5FAF5F ctermbg=237 guibg=#3C3836
highlight GitGutterChange ctermfg=214 guifg=#FABD2F ctermbg=237 guibg=#3C3836
highlight GitGutterChangeDelete ctermfg=202 guifg=#ff5f00 ctermbg=237 guibg=#3C3836

" diagnostics
lua <<END
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

local types = {"Error", "Warn", "Hint", "Info"}
for i,type in pairs(types) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { numhl = hl })
end
END

highlight DiagnosticSignError ctermfg=202 guifg=#ff5f00 ctermbg=237 guibg=#3C3836
highlight DiagnosticSignWarn ctermfg=214 guifg=#FABD2F ctermbg=237 guibg=#3C3836
highlight DiagnosticSignHint ctermbg=237 guibg=#3C3836
highlight DiagnosticSignInfo ctermfg=71 guifg=#5FAF5F ctermbg=237 guibg=#3C3836
highlight! link Pmenu Normal

set updatetime=100
set nocscopeverbose

" telescope
runtime telescope.lua
nnoremap <C-p> :lua telescope_buffers()<CR>
nnoremap <Leader><C-p> :lua telescope_findfiles()<CR>

runtime treesitter.lua
runtime lsp.lua

" nvim-cmp
set completeopt=menu,menuone,noselect
runtime completion.lua

" lualine.nvim configuration
runtime lualine.lua

" vsnip keys
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'


" next/prev problem
nnoremap <silent> ]l :lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> [l :lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> gl :lua vim.diagnostic.open_float()<CR>

" EnhancedJumps
let g:EnhancedJumps_no_mappings = 1
nmap <Leader><C-o> <Plug>EnhancedJumpsRemoteOlder
nmap <Leader><C-i> <Plug>EnhancedJumpsRemoteNewer
