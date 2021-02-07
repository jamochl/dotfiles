" {{ VIM VARIABLES }}
syntax on
filetype plugin on
set background=dark
set nocompatible
set clipboard=unnamedplus
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
set updatetime=300
set wildmenu
set laststatus=2
set termguicolors
set cursorline

" Setup custom Colourscheme
colo hilda

" {{ PLUGINS }}
call plug#begin('~/.vim/plugged')
" === START ===
" General usability
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
" Git and file management
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Fuzzy file search (Investigate)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" language server and autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Auto Pairing
" Plug 'jiangmiao/auto-pairs'
" Writing plugins
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" Note taking
" Plug 'vimwiki/vimwiki'
" HEX rgb view 
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
" Polyglot for syntax highlighting
Plug 'sheerun/vim-polyglot'
" Multiple cursors
" Plug 'mg979/vim-visual-multi'
" === END ===
call plug#end()

" {{ EXTENSION SETTINGS }}

" === Hex colors settings ===
let g:Hexokinase_highlighters = [ 'backgroundfull' ]

" === Limelight settings ===
let g:limelight_conceal_ctermfg = 'gray'

" === Nerdtree settings ===
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}

" === COC Settings ===
" Trigger completion with tab
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=1000

" === Goyo settings ===
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
  Limelight!
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" {{ PERSONAL BINDINGS }}
let mapleader = " "
let maplocalleader = " "
nnoremap <leader>p "0VP
nnoremap <expr> <leader>o 'm`' . v:count1 . 'o<Esc>``'
nnoremap <expr> <leader>O 'm`' . v:count1 . 'O<Esc>``'
nnoremap <leader>h :set hls!<CR>
nnoremap <leader>a $
nnoremap <leader>i ^
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ss :w<cr>:so %<cr>

" {{ EXTENSION BINDINGS }}
" Toggle Nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>
" Access Fuzzy finder
nnoremap <C-p> :GFiles<CR>
nnoremap <C-f> :Files<CR>
" Toggle Goyo GOYO (The best writing plugin)
nnoremap <leader>g :Goyo<CR>
" Setup Limelight and compatibility
nnoremap <leader>l :Limelight!!<CR>
" Quick comment (Doesn't work)
noremap <c-_> :Commentary<CR>
" Color toggling
noremap <leader>c :set termguicolors!<CR>

" Testing commands
vnoremap <leader>' <esc>`<i'<esc>`>la'<esc>

" AUTOCMDS

augroup filtype_vimrc
    autocmd!
    "map 'au' to create augroup
    autocmd BufRead,BufNewFile *.vimrc :iabbrev <buffer> au augroup <CR><CR>augroup END<esc>2k$i
augroup END

augroup filetype_md
    let g:polyglot_disabled = ['markdown']
    let g:markdown_fenced_languages = ['bash=sh', 'css', 'html', 'javascript', 'js=javascript', 'json=javascript', 'python']
    
    "
    autocmd!
    autocmd BufRead,BufNewFile *.rmd setlocal filetype=rmarkdown
    "test commands
    autocmd BufRead,BufNewFile *.md onoremap <buffer> ih :<c-u>execute "normal! ?^[=-]\\+$\rkvg_"<cr>
    autocmd BufRead,BufNewFile *.md onoremap <buffer> ah :<c-u>execute "normal! ?^[=-]\\+$\rVk"<cr>
    autocmd BufRead,BufNewFile *.md nnoremap <F5> :!mdtopdf.sh -d %<CR>
    autocmd BufRead,BufNewFile *.md setlocal tw=75
augroup END

augroup filetype_js
    autocmd!
    autocmd BufRead,BufNewFile *.js,*.html setlocal shiftwidth=2 tabstop=2
augroup END

augroup filetype_html
    autocmd!
    " autocmd BufWritePre,BufRead *.html :normal gg=G
    autocmd BufRead,BufNewFile *.twig setlocal filetype=html
    autocmd BufRead,BufNewFile *.html nnoremap <F5> :!firefox %<CR>
augroup END

augroup filetype_py
    autocmd!
    autocmd BufRead,BufNewFile *.py setlocal shiftwidth=4 tabstop=4 expandtab
augroup END

augroup filetype_sh
    autocmd!
    autocmd BufRead,BufNewFile *.sh :iabbrev <buffer> iff if [ ]; then<CR><CR>fi<esc>2-f[a
    autocmd BufRead,BufNewFile *.sh :iabbrev <buffer> iff if [ ]; then<CR><CR>fi<esc>2-f[a
    autocmd BufRead,BufNewFile *.sh nnoremap <F5> :!sh % <CR>
augroup END
