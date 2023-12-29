" Save position in file
au BufWinLeave * mkview
au BufWinEnter * silent loadview
" Tabs to spaces, with two spaces per 'tab'
set expandtab
set shiftwidth=2
set tabstop=2
" So you can autocomplete with dashes
set iskeyword+=\-
" Remapping window split resizing so we don't press shift
nmap , <
nmap . >
" Make netrw <enter> open the file in the most recent window
let g:netrw_browse_split = 4
let g:netrw_banner=0
" for vim wiki
set nocompatible
filetype plugin on
syntax on
execute pathogen#infect() 
