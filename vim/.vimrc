set nocompatible
set encoding=utf-8
" Show relative line numbers, but also the current line number.
set number relativenumber

" Disable mouse input
set mouse=

" Disable case sensivity
set ignorecase
set smartcase

" Tabs
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Autocompletion
set wildmode=longest,list,full

" Enable the sign column
set signcolumn=yes

" Display vertical line at 80 char.
set colorcolumn=80
" Indicate the line the cursor is currently on.
set cursorline

" Update title of the term emulator
set title
autocmd bufenter * let &titlestring = expand('%:p').' - NVIM'

set hidden
set incsearch
set hlsearch

" Continue to show statusline with multiple buffers
set laststatus=2
set noshowmode

" Give more space for displaying messages.
set cmdheight=2

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=100

" Set the leader key to be space.
let mapleader = " "

" Sources the stuff in the directory
set rtp^=/usr/share/vim/vimfiles/

" Toggle spell checking.
map <leader>s :setlocal spell! spelllang=en_gb<CR>

" https://github.com/junegunn/vim-plug/wiki/faq#fatal-dumb-http-transport-does-not-support---depth
let g:plug_shallow = 0

" Installs plug.vim automatically.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Define the plugins
call plug#begin('~/.vim/plugged')

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Colorscheme
"Plug 'https://git.compti.me/vim-colors-synthetic'
" FZF integration
Plug 'junegunn/fzf.vim'
" Alternates the colors for braces
Plug 'luochen1990/rainbow'
" Easier commenting using <leader>cc or <leader>cu
Plug 'scrooloose/nerdcommenter'
" Shows diff indicators within the signcolumn
Plug 'airblade/vim-gitgutter'
" No nonsense statusbar
Plug 'itchyny/lightline.vim'
" Visually display color of text
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
" Easily add license headers to source files, my fork contains some extra
" license types 
Plug 'mattmurr/vim-header'
" Nunjucks and such syntax
Plug 'Glench/Vim-Jinja2-Syntax'
" Zig language
Plug 'ziglang/zig.vim'
" Typescript 
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

call plug#end()

" Colors
set t_Co=256
set termguicolors " Required for rainbow parenthesis and hexokinase.
set background=dark
"colorscheme synthetic
" Transparent background
hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi Pmenu guibg=black
hi Pmenusel guifg=black

" fzf
let g:fzf_layout = { 'down': '~30%' }
map <leader>t :Files<cr>
map <leader>b :Buffers<cr>
map <leader>g :GitFiles<cr>
let g:fzf_buffers_jump = 1
let g:fzf_action = {
      \ 'ctrl-h': 'split',
      \ 'ctrl-v': 'vsplit' }

" License headers.
let g:header_auto_add_header = 0
let g:header_field_author = 'Matthew Murray'
let g:header_field_author_email = 'matt@compti.me'

" Enable rainbow by default.
let g:rainbow_active = 1

" Display colors in background behind the text.
let g:Hexokinase_highlighters = ['backgroundfull']

" Use <tab> to trigger completion
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Navigate with tab and s-tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use enter to confirm complete
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> g[ <Plug>(coc-diagnostic-prev)
nmap <silent> g] <Plug>(coc-diagnostic-next)

nn <silent> K :call CocActionAsync('doHover')<cr>

au CursorHold * sil call CocActionAsync('highlight')
au CursorHoldI * sil call CocActionAsync('showSignatureHelp')

" Symbol renaming.
nmap <F2> <Plug>(coc-rename)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }

