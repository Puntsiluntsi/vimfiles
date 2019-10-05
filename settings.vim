" Tab/Indent settings:
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Always show status line
set laststatus=2

" Fuzzy searching
"set path=./**/,.,,/**
"let &path = getcwd() . "/**/,.,,"
let &path = ",.,,/**/"
"noremap <C-P> :<C-U>find *

" Wildcard menu
set wildmenu
set wildignorecase

" Autoindent
set autoindent

" GitDiff command (TODO: solve the problem with carriage returns in windows, and allow for optional filename arguemnts.)
command! -nargs=* -complete=file GitDiff write !git diff % -

" Relative line numbers
set number
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Allow hidden buffers
set hidden

" Don't wrap lines at the middle of WORDS:
set linebreak
let &breakat=' '

" Search/Replace preferences:
set gdefault " Replacing is global by default (replace all)

set ignorecase
set smartcase
" Case insensitive search unless capital letters are present in the search or \C is given.

set incsearch
" Go to search results and highlight while typing the search

" File Format settings
set fileformats=unix,dos " Windows default is dos,unix which creates new file with CRLF.

" Format options:
setglobal formatoptions+=j

setglobal textwidth=100
