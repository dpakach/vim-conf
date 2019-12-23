set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" -------------------------------
" PLUGINS
" -------------------------------
Plugin 'vim-syntastic/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'nvie/vim-flake8'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'morhetz/gruvbox'
Plugin 'prettier/vim-prettier'
Plugin 'sjl/gundo.vim'
Plugin 'rking/ag.vim'
Plugin 'jiangmiao/auto-pairs'
Bundle 'Valloric/YouCompleteMe'
Plugin 'mattn/emmet-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Basic

let mapleader=","       		" leader is comma
syntax on				" syntax highlight
let python_highlight_all=1		" python hightlight
set nu					" line numbers
set clipboard=unnamed			" for using system clipboard
set noswapfile
set incsearch
set hlsearch
set wildmenu
set showcmd
set number relativenumber
set backspace=indent,eol,start

" Enable Folding
set foldmethod=indent
set foldlevel=99

" Encoding
set encoding=utf-8

" -------------------------------
" MAPPINGS
" -------------------------------
"
" Move between splits with ctrl+movement-keys
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding with the spacebar
nnoremap <space> za

" Show whitespaces as characters
set listchars=eol:!,tab:>-,trail:~,space:.,extends:>,precedes:<
set list
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

" save session
nnoremap <leader>s :mksession<CR>

" open ag.vim
nnoremap <leader>a :Ag 

" -------------------------------
" LANGUAGE SPECIFIC SETTINGS
" -------------------------------
"
" PEP8
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

" Flag white spaces
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h
    \ match SpellBad /\s\+$/

" -------------------------------
" PLUGINS/BUNDLES settings
" -------------------------------
"
" you complete me settings
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>


" nerdetree settings
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
let NERDTreeQuitOnOpen=1            " auto close nerdtree when new tab is opened
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

map <leader>t :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" synstatic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = '/usr/bin/python'
let g:pymode_python = 'python3'


" ctrlp settings
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_switch_buffer = 0

" gruvbox settings
colo gruvbox
set background=dark
let g:gruvbox_invert_selection=0

" gundo settings
nnoremap <leader>u :GundoToggle<CR>			" toggle gundo

" emmet settings
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_mode='a'    "enable all function in all mode.

" -------------------------------
" CUSTOM FUNCTIONS
" -------------------------------
" toggle between number and relativenumber
nnoremap <leader>n :call ToggleNumber()<CR>
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
nnoremap <leader>w :call <SID>StripTrailingWhitespaces()<CR>
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

