" TODO: make a Command command which is equivelant to command with saner
" defaults (command! -bar anything, takes -nobar as an option)
"command! Command  -bar -nargs=* -complete=command command! <args>

command! -bar Vimrc execute 'edit' vimfilesDir.'/vimrc'
command! -bar Commands execute 'edit' vimfilesDir.'/Commands.vim'
command! -bar Settings execute 'edit' vimfilesDir.'/Settings.vim'
command! -bar Maps Vimrc|normal 'm
command! -bar WriteUnix set ff=unix | write
command! -bar WriteDos set ff=dos | write
command! -bar Dos2Unix write | edit ++ff=dos | WriteUnix
command! -bar Unix2Dos write | edit ++ff=dos | write
