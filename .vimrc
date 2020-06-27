" VIM VARIABLES
syntax on
filetype plugin on
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
set scrolloff=3
" To view hidden characters, do :set list
set listchars=tab:→\ ,space:• ",trail:·,eol:¶
set nolist
" To speed up command execution after keypress
set ttimeoutlen=10
set wildmenu

" PLUGINS
call plug#begin('~/.vim/plugged')
" General usability
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
" Git and file management
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Fancy powerline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Themes
Plug 'morhetz/gruvbox'
" Fuzzy file search
Plug 'junegunn/fzf'
" Tmux integrate - rebind window movement
"                  (ctrl-[hjkl])
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
" Autocompletion
Plug 'ajh17/VimCompletesMe'
" Writing plugins
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" Note taking
Plug 'vimwiki/vimwiki'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" EXTENSION VARIABLES
" set limelight highlighting
let g:limelight_conceal_ctermfg = 'gray'

" Set goyo enter exit for TMUX compatibility
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

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=1000


" Setup Colourscheme
colo gruvbox
" Specific colour modifications
highlight Normal ctermfg=lightgrey
" Set to have green comments
highlight Comment ctermfg=green

" PERSONAL BINDINGS
let mapleader = " "
let maplocalleader = " "
nnoremap <leader>p "0VP
nnoremap <expr> <leader>o 'm`' . v:count1 . 'o<Esc>``'
nnoremap <expr> <leader>O 'm`' . v:count1 . 'O<Esc>``'
nnoremap <leader>h :noh<CR>
nnoremap <leader>a $
nnoremap <leader>i ^
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap H 0
nnoremap L $
nnoremap M :call cursor(0, len(getline('.'))/2)<cr>

" EXTENSION BINDINGS
" Toggle Nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>
" Access Fuzzy finder
nnoremap <C-p> :FZF<CR>
" Toggle Goyo GOYO (The best writing plugin)
nnoremap <leader>g :Goyo<CR>
" Setup Limelight and compatibility
nnoremap <leader>l :Limelight!!<CR>
" Quick comment (Doesn't work)
noremap <c-_> :Commentary<CR>

" Testing commands
vnoremap <leader>' <esc>`<i'<esc>`>la'<esc>

" AUTOCMDS
"
augroup filtype_vimrc
    autocmd!
    "map 'au' to create augroup
    autocmd BufRead,BufNewFile *.vimrc :iabbrev <buffer> au augroup <CR><CR>augroup END<esc>2k$i
augroup END

augroup filetype_md
    autocmd!
    autocmd BufRead,BufNewFile *.rmd setlocal filetype=rmarkdown
    "test commands
    autocmd BufRead,BufNewFile *.md onoremap <buffer> ih :<c-u>execute "normal! ?^[=-]\\+$\rkvg_"<cr>
    autocmd BufRead,BufNewFile *.md onoremap <buffer> ah :<c-u>execute "normal! ?^[=-]\\+$\rVk"<cr>
augroup END

augroup filetype_js
    autocmd!
    autocmd BufRead,BufNewFile *.js,*.html setlocal shiftwidth=2 tabstop=2
augroup END

augroup filetype_html
    autocmd!
    autocmd BufWritePre,BufRead *.html :normal gg=G
augroup END

augroup filetype_py
    autocmd!
    autocmd BufRead,BufNewFile *.py setlocal shiftwidth=4 tabstop=4 expandtab
augroup END

augroup filetype_sh
    autocmd!
    autocmd BufRead,BufNewFile *.sh :iabbrev <buffer> iff if [ ]; then<CR><CR>fi<esc>2-f[a
augroup END

