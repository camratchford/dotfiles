" Leader:
let mapleader = "\\"

" Visual Bell: (No beeping)
set vb

" Default Settings:
set incsearch
set hidden
set syntax=on

" Mouse: (Scrolling works, terminal copy and paste work in i mode)
set mouse=nva
set selectmode=mouse
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" Plugin Manager:
call pathogen#infect()

" Theme:
packadd! everforest
colorscheme everforest
set background=dark

" Show Matching Brackets:
set showmatch

" Show Line Numbers:
set nonumber
nnoremap <F3> :set nonumber!<CR>:set foldcolumn=0<CR>
imap <F3> <esc>:set nonumber!<CR>:set foldcolumn=0<CR>i
vmap <F3> <esc>:set nonumber!<CR>:set foldcolumn=0<CR>v

" Autoindent:
set autoindent|set cindent
" Use VSCode Hotkeys: (Tab/Shift-Tab for Indent/Unindent:)
vmap <tab> >gv
vmap <s-tab> <gv
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>
imap <S-Tab> <Esc>^i<BS>

" Tabstops: (Set to 2 spaces unless otherwise stated)
set tabstop=2|set shiftwidth=2 softtabstop=2 expandtab
autocmd FileType python setlocal shiftwidth=4 softtabstop=4
autocmd FileType javascript setlocal shiftwidth=4 softtabstop=4

" Allow Plugins Incompatible With VI:
set nocompatible
filetype plugin on
set listchars=tab:>-,trail:-
set statusline=%F%m%r%h%w\ %y\ %=[%l/%L,%04v](%p%%)
set laststatus=2

" Set Wrapping:
set wrap
set linebreak

" NerdTree: (File explorer)
nnoremap <F5> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Trailing Whitespace: (Trimmed when saved and closed)
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

" Multi Cursor: (https://github.com/mg979/vim-visual-multi/wiki/Quick-start)
let g:VM_leader = '<C-A->'
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"] = '<C-A-Down>'      " start selecting down
let g:VM_maps["Add Cursor Up"]   = '<C-A-Up>'        " start selecting up
let g:VM_mouse_mappings = 1
let g:VM_maps["Mouse Cursor"] = '<A-LeftMouse>'
let g:VM_maps["Mouse Column"] = '<A-RightMouse>'
let g:VM_maps["Mouse Column"] = '<C-A-LeftMouse>'
let g:VM_maps['Find Under'] = '<C-F2>'

" Use The Clipboard: (If vim is capable of using it)
if exepath(v:progname) =~# '/usr/bin/vim.gtk3'
  inoremap <C-v> <ESC>"+pa
  vnoremap <C-c> "+y
" Windows Terminal Behaviour:
  snoremap <RightMouse> <Esc>
  vnoremap <RightMouse> "+y`]>i
  inoremap <RightMouse> <ESC>"+pa
endif

" Commenting Out:  ('_' is actually '/')
vnoremap <C-_> :Commentary<CR>
inoremap <C-_> :Commentary<CR>
nnoremap <C-_> :Commentary<CR>

