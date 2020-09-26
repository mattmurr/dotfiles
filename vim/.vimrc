set encoding=utf-8
set nocompatible
filetype plugin indent on
syntax on
set hidden
set noswapfile
set mouse=

set title
autocmd bufenter * let &titlestring = expand('%:p').' - NVIM'

set timeoutlen=1000 
set ttimeoutlen=0

set tabstop=2
set softtabstop=2
set shiftwidth=2 
set expandtab    
set autoindent

let mapleader = " "

set hls
set is
set cursorline
set wildmode=longest,list,full
set ignorecase
set smartcase

set cmdheight=1
set shortmess+=c
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=100
" Automatically reload files that have changed externally
set autoread

let $RTP=split(&runtimepath, ',')[0] " Expected to return ~/.vim
let $RC="~/.vimrc"

if exists('g:started_by_firenvim')
  set laststatus=0
else
  set laststatus=2
endif

" Set the leader key to be space.
let mapleader = " "

" Toggle spell checking.
map <leader>s :setlocal spell! spelllang=en_gb<CR>

" Sign with gpg
nnoremap <leader>ps :%!gpg --clear-sign<CR>
vnoremap <leader>ps :!gpg --clear-sign<CR>
" Encrypt with gpg using a public key
nnoremap <leader>pe :%!gpg -sea -r 
vnoremap <leader>pe :!gpg -sea -r 
" Encrypt with gpg using a symmetric cipher
nnoremap <leader>pp :%!gpg -ca<CR>
vnoremap <leader>pp :!gpg -ca<CR>
" Decrypt with gpg
nnoremap <leader>pd :%!gpg -d<CR> 
vnoremap <leader>pd :!gpg -d<CR> 

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

Plug 'mattmurr/vim-colors-synthetic'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'

Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'jparise/vim-graphql'
Plug 'dart-lang/dart-vim-plugin'
Plug 'elixir-editors/vim-elixir'

call plug#end()

set t_Co=256
set termguicolors
set background=dark
colorscheme synthetic
highlight! link SignColumn LineNr
"hi CursorLine cterm=NONE ctermbg=234 ctermfg=NONE
"hi SignColumn ctermbg=NONE
hi Pmenu guibg=black guifg=white

" fzf
let g:fzf_layout = { 'down': '~30%' }
map <leader>t :Files<cr>
map <leader>b :Buffers<cr>
map <leader>g :GitFiles<cr>
let g:fzf_buffers_jump = 1
let g:fzf_action = {
      \ 'ctrl-h': 'split',
      \ 'ctrl-v': 'vsplit' }

" firenvim (vim in the browser)
let g:firenvim_config = {'localSettings': { '.*': { 'priority': 1, 'takeover': 'never' }}}

" coc
let g:coc_global_extensions = ['coc-eslint', 'coc-tailwindcss', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-xml', 'coc-python', 'coc-go', 'coc-java', 'coc-snippets', 'coc-flutter', 'coc-elixir', 'coc-r-lsp']

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
nmap <silent> gD :sp <CR><Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gI :sp <CR><Plug>(coc-implementation)

nmap <silent> g[ <Plug>(coc-diagnostic-prev)
nmap <silent> g] <Plug>(coc-diagnostic-next)

nn <silent> K :call CocActionAsync('doHover')<CR>

au CursorHold * sil call CocActionAsync('highlight')
au CursorHoldI * sil call CocActionAsync('showSignatureHelp')

" Symbol renaming.
nmap <F2> <Plug>(coc-rename)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" CocAction
nmap <Leader>a :<C-u>CocAction<cr>

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
      \ }
