" TODO:
" Make this vimrc cross platform.
" Make Cd command which is equivelant to cd but relative to current file directory
" Make :e with no arguemnts equivelant to :E but with working dir, and :E with filepath equivelant to :e but relative to current file directory.
" Execute "set modified" when folding (count folds as changes, matching the behavior of saving folds on writing)

let s:vimfilesPath = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec "set runtimepath+=".s:vimfilesPath

" Color Scheme
syntax enable

if (&t_Co==256)
    colorscheme monokai
endif

" Functions PushPos and PopPos for remembering and going to cursor position: 
au BufEnter * if !exists('b:posStack') | let b:posStack = [] | endif

function! PushPos()
    call add(b:posStack,[line('.'),col('.')])
endfunction

function! PopPos()
    let l:pos = remove(b:posStack,-1)
    "call cursor(l:pos[0],l:pos[1])
    return l:pos
endfunction

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

" Fix for the persistant netrw buffers:
autocmd FileType netrw setl bufhidden=delete

" Save folds
let &viewdir = s:vimfilesPath."/view"

augroup AutoSaveFolds
  autocmd!
  autocmd BufWrite,VimLeave * mkview
  autocmd BufRead           * silent! loadview
augroup END

" Refresh plugin docs:
exec "helptags" s:vimfilesPath."/doc"

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

" Change Ctrl-P path to cwd:
let g:ctrlp_working_path_mode = 'rwa'

" **OPTIONS MARK**

" Build Systems:

" TODO: use autocmd on FileType for automatic building based on the file language

" Java
function! FJavaRun(...)
    if a:0 == 0
        let l:file = '%'
    else
        let l:file = a:1
    endif
    if a:0 == 2
        let l:class = a:2
    else
        let l:class = fnamemodify(l:file,':t:r')
    endif
    silent execute "!javac" '"'.l:file.'"'
    execute "!java" '-cp "'.fnamemodify(l:file,':h').'" "'.l:class.'"'
endfunction

command! -nargs=* -complete=file JavaRun call FJavaRun(<f-args>)
" TODO: Make JavaMain work
command! -nargs=? -complete=file JavaMain call FJavaRun(<f-args>,"Main")
autocmd FileType java cnoreabbrev <expr> Build ((getcmdtype() is# ':' && getcmdline() is# 'Build')?('JavaRun'):('Build'))

" Python
"TODO





" MAPS:

" Bind Delete to :bd (delete buffer)
nnoremap <Del> :bd<CR>
nnoremap <S-Del> :exec "bd!" bufnr('%')<CR>
" For persistant/buggy buffers 

" make Y behave like C,D and not yy
nnoremap Y y$

" Bind <Space> to :
noremap <Space> :

" Appending/Inserting single character (with s/S)
function! RepeatChar(char, count)
  return repeat(a:char, a:count)
endfunction

"nnoremap <silent>s :i<C-R>=RepeatChar(nr2char(getchar())),v:count1)
"nnoremap <silent>S :i<C-R>=RepeatChar(nr2char(getchar())),v:count1)
nnoremap <silent>s :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR>
nnoremap <silent>S :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR>
"xnoremap <silent>s I<C-O>:<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR><Esc>
"xnoremap <silent>S A<C-O>:<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR><Esc>
" tried making s/S work for visual block mode, failed for now (the command "visual" has nothing to do with what is actually needed)

" Bind Ctrl+Space to toggle insert mode (alternative to i,esc)
noremap <C-Space> <Esc>
inoremap <C-Space> <Esc>
cnoremap <C-Space> <C-C>
tnoremap <C-Space> <C-\><C-N>
nnoremap <C-Space> i

cnoremap <S-Space> <CR>

" map Nul into C-Space for vim to interpet actual ctrl+space on terminal as C-Space:
map <Nul> <C-Space>
map! <Nul> <C-Space>
tmap <Nul> <C-Space>


" Bind ctrl+enter in insert mode to create new line and move to next line *SCRAPPED*

" Swap lines with ctrl+J and ctrl+K:
" TODO: make these into functions which can be used with count.
nnoremap <silent><C-J> :<C-U>call PushPos()<CR>:let tmp=@a<CR>"add"ap:let @a=tmp<CR>:<C-U>let [posy,posx]=PopPos()<CR>:<C-U>call cursor(posy+1,posx)<CR>
nnoremap <silent><C-K> :<C-U>call PushPos()<CR>:let tmp=@a<CR><Up>"add"ap<Up>:let @a=tmp<CR>:<C-U>let [posy,posx]=PopPos()<CR>:<C-U>call cursor(posy-1,posx)<CR>

" Enter, (Ctrl+Enter and Shift+Enter in _gvimrc):
nnoremap <silent><Enter> :<C-U>call PushPos()<CR>O<Esc>:<C-U>let [posy,posx]=PopPos()<CR>:<C-U>call cursor(posy+1,posx)<CR>

" yd for 'yanking' last deletion into 0 register:
nnoremap <silent>yd :<C-U>let @0=@"<CR>

" Tab and Shift-Tab for switching between buffers:
nnoremap <silent><Tab> :<C-U>execute (v:count==0 ? 'bn' : 'b') v:count1<CR>
nnoremap <silent><S-Tab> :<C-U>execute 'bp' v:count1<CR>
" Ctrl+Tab and Ctrl+Shift+Tab for switching between tabs:
nnoremap <silent><C-Tab> :<C-U>execute 'tabn' (v:count==0 ? '' : v:count) <CR>
nnoremap <silent><C-S-Tab> :<C-U>execute 'tabp' v:count1<CR>

" Replace with yanked text without cutting replaced text (in visual mode):
xnoremap p "_dP

" Use normal navigation keys in insert mode pop-up menus:
inoremap <expr>j pumvisible() ? "\<C-N>" : "j"
inoremap <expr>k pumvisible() ? "\<C-P>" : "k"
inoremap <expr><C-Space> pumvisible() ? "\<C-E>" : "<Esc>"
inoremap <expr><S-Space> pumvisible() ? "\<C-Y>" : "<Esc>"
