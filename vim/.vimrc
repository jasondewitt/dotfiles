set mouse-=a
set number
execute pathogen#infect()
syntax on
filetype plugin indent on

" vim-airline config
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
  let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline_theme = 'molokai'

set laststatus=2

set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
