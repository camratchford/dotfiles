


" Visual bell rather than audio
set vb
" Mouse mode in visual and normal mode only, system mouse settings for insert mode
set mouse=vn
" real-time search results
set incsearch

" Theme
set hidden
set background=dark

set backup
set history=50
set backupdir=~/.vimbackup
set backupext=.backup

" autoindent, highlight matching brackets
set autoindent|set cindent
set showmatch

" show line numbers
nmap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
imap <F2> <esc>:set nonumber!<CR>:set foldcolumn=0<CR>i
vmap <F2> <esc>:set nonumber!<CR>:set foldcolumn=0<CR>v

" make tab indent, shift-tab unindent
vmap <tab> >gv
vmap <s-tab> <gv
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>

if executable("vi")
  set foldenable
  set foldmarker={,}
  set foldmethod=marker
  set foldlevel=100
endif

" Buffer navigation
" map <C-k> :bp<CR>
" map <C-j> :bn<CR>
" map <C-h> :tabp<CR>
" map <C-l> :tabn<CR>


" https://github.com/mg979/vim-visual-multi/wiki/Mappings
let map_leader='<C-A>'
let g:VM_mouse_mappings = 1
let g:VM_maps = {}
let g:VM_maps["Select Cursor Down"] = '<C-A-Down>'
let g:VM_maps["Select Cursor Up"] = '<C-A-Up>'
let g:VM_maps["Mouse Cursor"] = '<A-LeftMouse>'
let g:VM_maps["Visual Find"] = ''
let g:VM_maps["Seek Next"] = ''
let g:VM_maps["Seek Prev"] = ''

" Find and Replace
function! GetSelected()
  normal gv"xy
  let result = getreg("x")
  normal gv
  return result
endfunc


" Set wrapping
set wrap
set linebreak
if executable("par")
    set formatprg=par\ -w80rq
endif

nnoremap <F5> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Remove tailing whitespace when saved
highlight default link EndOfLineSpace ErrorMsg
match EndOfLineSpace / \+$/
autocmd InsertEnter * hi link EndOfLineSpace Normal
autocmd InsertLeave * hi link EndOfLineSpace ErrorMsg
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

function! WhenSave()
    call TrimWhiteSpace()
endfunction

autocmd FileWritePre    * :call WhenSave()
autocmd FileAppendPre   * :call WhenSave()
autocmd FilterWritePre  * :call WhenSave()
autocmd BufWritePre     * :call WhenSave()

call plug#begin('~/.config/nvim/plugs')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nfrid/treesitter-utils'
Plug 'neanias/everforest-nvim', { 'branch': 'main' }
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 's1n7ax/nvim-search-and-replace'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'cuducos/yaml.nvim'
Plug 'ellisonleao/glow.nvim'
Plug 'richardbizik/nvim-toc'
Plug 'nfrid/markdown-togglecheck'
Plug 'nvimdev/indentmini.nvim'
Plug 'windwp/nvim-ts-autotag'
Plug 'windwp/nvim-autopairs'
Plug 'okuuva/auto-save.nvim', { 'tag': 'v1*' }
Plug 'filipdutescu/renamer.nvim', { 'branch': 'master' }
Plug 'jakewvincent/mkdnflow.nvim'
Plug 'ziglang/zig.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()

colorscheme everforest
set virtualedit=all

lua require("init")


set tabstop=4 shiftwidth=0 expandtab
inoremap <S-Tab> <C-d>
