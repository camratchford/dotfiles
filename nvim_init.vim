set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" use visual bell instead of beeping
set vb
set mouse=vn
" incremental search
set incsearch

" Allow hidden buffers

packadd! everforest
colorscheme everforest
set hidden

set background=dark
" autoindent
set autoindent|set cindent

" 2 space tabs
set tabstop=2|set shiftwidth=2|set expandtab|set softtabstop=2

" show matching brackets
set showmatch

" show line numbers
set nonumber
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
imap <F2> <esc>:set nonumber!<CR>:set foldcolumn=0<CR>i
vmap <F2> <esc>:set nonumber!<CR>:set foldcolumn=0<CR>v

" make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv

" make tab in normal mode ident code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>
" https://vimawesome.com/plugin/commentary-vim
" Map '/' to running 'gc' in visual mode, then going back into insert mode
imap <c-_> <esc>vgci
vmap <c-_> gc

vmap <A-Down> <Down><C-n>
vmap <A-Up> <Up><C-n>

" paste mode - this will avoid unexpected effects when you
" cut or copy some text from one window and paste it in Vim.
set pastetoggle=<F6>

" Turn plugin on
filetype plugin indent on

if executable("vi")
  set foldenable
  set foldmarker={,}
  set foldmethod=marker
  set foldlevel=100
endif
set listchars=tab:>-,trail:-
set statusline=%F%m%r%h%w\ %y\ %=[%l/%L,%04v](%p%%)
set laststatus=2

" Buffer navigation
map <C-k> :bp<CR>
map <C-j> :bn<CR>
map <C-h> :tabp<CR>
map <C-l> :tabn<CR>

" File edit shortcuts
let mapleader=','
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Set wrapping
set wrap
set linebreak
if executable("par")
    set formatprg=par\ -w80rq
endif

" vim bundles
nnoremap <F5> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Syntax
au BufRead,BufNewFile *.pp              set filetype=puppet

set clipboard=unnamed


" Shared 'buffer'
vmap <C-c> :w! ~/.vimbuffer<CR>
nmap <C-c> :.w! ~/vimbuffer<CR>
" paste from buffer
nmap <C-p> :r ~/.vimbuffer<CR>

" Trailing Whitespace
highlight default link EndOfLineSpace ErrorMsg
match EndOfLineSpace / \+$/
autocmd InsertEnter * hi link EndOfLineSpace Normal
autocmd InsertLeave * hi link EndOfLineSpace ErrorMsg
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
autocmd FileWritePre    * :call TrimWhiteSpace()
autocmd FileAppendPre   * :call TrimWhiteSpace()
autocmd FilterWritePre  * :call TrimWhiteSpace()
autocmd BufWritePre     * :call TrimWhiteSpace()


let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_post_args='--ignore=W504,E501'
set number
call plug#begin('~/.vim/plugs')
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
call plug#end()

