syntax on
set background=dark
set nocompatible
set clipboard=unnamedplus
set hlsearch
set incsearch
set number
set relativenumber
set showcmd
set linebreak
set wrap
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set backspace=indent,eol,start
set path=./**,**,
" To view hidden characters, do :set list
set listchars=tab:→\ ,space:• ",trail:·,eol:¶
set nolist
" To speed up command execution after keypress
set ttimeoutlen=10
set wildmenu

" Personal Bindings
let mapleader = " "
nmap <leader>p "0VP
nmap <expr> <leader>o 'm`' . v:count1 . 'o<Esc>``'
nmap <expr> <leader>O 'm`' . v:count1 . 'O<Esc>``'
nmap <leader>h :noh<CR>

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
" GENERAL USABILITY
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
" GIT AND FILE MANAGEMENT
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" FANCY POWERLINE
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" THEMES
Plug 'morhetz/gruvbox'
" FUZZY FILE SEARCH
Plug 'junegunn/fzf'
" TMUX INTEGRATE - rebind window movement
"                  (ctrl-[hjkl])
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
" AUTOCOMPLETION
Plug 'ajh17/VimCompletesMe'
" WRITING PLUGINS
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" NOTE TAKING
Plug 'vimwiki/vimwiki'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Shortcut for accessing NERDTree
nmap <C-n> :NERDTreeToggle<CR> " Toggle NERD tree

" Shortcut for accessing FZF
nmap <C-f> :FZF<CR>

" Setup Limelight and compatibility
nmap <leader>l :Limelight!!<CR> " Toggle Limelight
let g:limelight_conceal_ctermfg = 'gray'

" Setup GOYO (The best writing plugin)
nmap <leader>g :Goyo<CR> " Toggle Goyo
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
  endif
endfunction
function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
  endif
  highlight Normal ctermfg=lightgrey
  Limelight!
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Setup Airline Theme
let g:airline_theme='ayu_mirage'
let g:airline_section_warning=''
let g:airline#extensions#wordcount#enabled = 0
 let g:airline#extensions#tmuxline#enabled = 0
" let g:airline#extensions#tabline#enabled = 1
" let g:tmuxline_powerline_separators = 0

" Setup Colourscheme
colo gruvbox

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=1000

" Specific colour modifications
highlight Normal ctermfg=lightgrey

" Set to have green comments
"highlight Comment ctermfg='Green'

autocmd BufRead,BufNewFile *.rmd setlocal filetype=rmarkdown
autocmd BufRead,BufNewFile *.js,*.html setlocal shiftwidth=2 tabstop=2
autocmd BufRead,BufNewFile *.py setlocal shiftwidth=4 tabstop=4 expandtab
