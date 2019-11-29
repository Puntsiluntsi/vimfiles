" TODO:
" Make Cd command which is equivelant to cd but relative to current file directory
" Make :e with no arguemnts equivelant to :E but with working dir, and :E with filepath equivelant to :e but relative to current file directory.
" Execute "set modified" when folding (count folds as changes, matching the behavior of saving folds on writing)

"" FUCK NETRW.
"let g:loaded_netrwPlugin = 1

let vimfilesDir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" (determined by the path of this vimrc file's directory)
let $MYVIMRC = resolve(expand('<sfile>:p'))
exec "set runtimepath+=".vimfilesDir

runtime settings.vim
runtime basicMaps.vim

" Color Scheme
let colorScheme256 = 'monokai'
let colorSchemeBasic = 'default'

syntax enable

if (&t_Co==256)
    exec 'colorscheme' colorScheme256
else
    exec 'colorscheme' colorSchemeBasic
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


" Fix for the persistant netrw buffers:
autocmd FileType netrw setl bufhidden=delete

" Save folds
let &viewdir = vimfilesDir."/view"

augroup AutoSaveFolds
  autocmd!
  autocmd BufWrite,VimLeave * mkview
  autocmd BufRead           * silent! loadview
augroup END

" Refresh plugin docs:
exec "helptags" vimfilesDir."/doc"

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
" Stronger buffer deletion against mofified/persistant buffers
nnoremap <S-Del> :exec "bd!" bufnr('%')<CR>
" Delete all buffers
nnoremap <C-S-Del> :%bd<CR>
" Close a window (the buffer remains)
nnoremap <C-Del> :close<CR>


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

" Swap lines with ctrl+J and ctrl+K:
nnoremap <silent><C-J> :<C-U>call PushPos()<CR>:let tmp=@a<CR>"add"ap:let @a=tmp<CR>:<C-U>let [posy,posx]=PopPos()<CR>:<C-U>call cursor(posy+1,posx)<CR>
nnoremap <silent><C-K> :<C-U>call PushPos()<CR>:let tmp=@a<CR><Up>"add"ap<Up>:let @a=tmp<CR>:<C-U>let [posy,posx]=PopPos()<CR>:<C-U>call cursor(posy-1,posx)<CR>
" TODO: make these into functions which can be used with count.

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

" Use normal navigation keys in insert mode pop-up menus:
inoremap <expr>j pumvisible() ? "\<C-N>" : "j"
inoremap <expr>k pumvisible() ? "\<C-P>" : "k"
inoremap <expr><C-Space> pumvisible() ? "\<C-E>" : "<Esc>"
inoremap <expr><S-Space> pumvisible() ? "\<C-Y>" : "<Esc>"

function! DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

runtime pluggins.vim
runtime commands.vim
