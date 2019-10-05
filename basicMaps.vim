" --------- This file is for basic maps which can be used on different, vim
"  environment which lack more complex vimscript features (like functions)
"  e.g. ideavim plugin on intellij --------------

" make Y behave like C,D and not yy
nnoremap Y y$

" Bind <Space> to :
noremap <Space> :

" Bind Ctrl+Space to toggle insert mode (alternative to i,esc)
noremap <C-Space> <Esc>
inoremap <C-Space> <Esc>
cnoremap <C-Space> <C-C>
tnoremap <C-Space> <C-\><C-N>
nnoremap <C-Space> i
"cnoremap <S-Space> <CR> " Removed because in terminal <Space> and <S-Space> are indistinguishable.

" Replace with yanked text without cutting replaced text (in visual mode):
xnoremap p "_dP

" map <Nul> to <C-Space> for vim to interpet actual ctrl+space on terminal as <C-Space>:
map <Nul> <C-Space>
map! <Nul> <C-Space>
tmap <Nul> <C-Space>
" Note: this sacrifices the ctrl+@ combination which is also interpeted as <Nul>

