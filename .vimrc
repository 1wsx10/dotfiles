"Space as a Leader
let mapleader = "\<Space>"
" Use Vim features, not Vi
set nocompatible

set encoding=utf-8

"current favorite colorscheme
colorscheme javipolo

"let g:clang_library_path='/usr/lib/llvm-3.5/lib/'

" make vitality fix the focus, but don't make it break my font
"let g:vitality_fix_cursor = 0
"let g:vitality_fix_focus = 1
"let g:vitality_always_assume_iterm = 0

"Focus - i want it to write and read the clipboard when focus is lost and
"gained
autocmd FocusLost * :wv
autocmd FocusGained * :rv

"gitgutter
let g:gitgutter_enabled = 0
nmap <leader>gg :GitGutterToggle<CR>

"rainbow parentheses
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'vim': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'php': {
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'txt': {
\			'parentheses': [],
\		},
\		'css': 0,
\		'cpp': {
\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold', 'start=/</ end=/>/ fold'],
\		},
\	}
\}
"some reason, setting parenteses for 'txt' doesn't affec the help files

" viminfo is set by nocompatible, so should be after nocompatible
"set viminfo='100,<50,s10,h
set viminfo=\"100,%,<800,'10,/50,:100,h,f0
"set viminfo=%,<800,'10,/50,:100,h,f0,n~/.vim/cache/.viminfo
 "           | |    |   |   |    | |  + viminfo file path
 "           | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
 "           | |    |   |   |    + disable 'hlsearch' loading viminfo
 "           | |    |   |   + command-line history saved
 "           | |    |   + search history saved
 "           | |    + files marks saved
 "           | + lines saved each register (old name for <, vi6.2)
 "           + save/restore buffer list

" use a motion to change caps
set tildeop

"omni complete pls
set omnifunc=syntaxcomplete#Complete
"add spelling to completions, only when spelling is enabled
set complete+=kspell

"spelling
autocmd FileType markdown setlocal spell
autocmd FileType text setlocal spell

"no spelling
autocmd FileType cs setlocal nospell
autocmd FileType python setlocal nospell

"to add a filetype for unrecognised file
autocmd BufRead,BufNewFile *.asdf :set filetype=asdf
autocmd BufRead,BufNewFile .bashal :set filetype=sh
autocmd BufRead,BufNewFile .bashfunc :set filetype=sh
autocmd BufRead,BufNewFile .vimrc :set filetype=vim


" syntax folding
"set foldmethod=syntax

" Syntax highlighting

" Detect filetype
filetype plugin on
" Enable syntax highighting
"syntax enable
syntax on
" Show matching parens, brackets, etc.
set showmatch
" 256 colours please
set t_Co=256


" Italicised comments and attributes
highlight Comment cterm=italic
highlight htmlArg cterm=italic



" Set the dimmed colour for Limelight
"let g:limelight_conceal_ctermfg = 'LightGrey'



" Disable indentLine by default
"let g:indentLine_enabled = 0


" NERDTree

" Run NERDTree as soon as we launch Vim...
"autocmd vimenter * NERDTree
"" ...but focus on the file itself, rather than NERDTree
"autocmd VimEnter * wincmd p
" Close Vim if only NERDTree is left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif



" Set relevant filetypes
"au BufRead,BufNewFile *.scss set filetype=css
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.hbs set filetype=html


"if you are reading this and you are not me, then you have probably gotten my vimrc from me and are starting to learn stuff about vim. the best thing i learned was insert-mode completion. type ':help ins-completion' now.


" Buffer management

" Open splits to the right or below; more natural than the default
set splitright
set splitbelow
" Set the working directory to wherever the open file lives (can be problematic)
"set autochdir
" Tell Vim to look at all parent dirs for tags
set tags=tags;

" make vim path recurse into all subdirs
set path+=**
" Show file options above the command line
set wildmenu
" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*



" Text management

filetype plugin indent on
" 2 spaces please
"set expandtab "cancer - replaces tabs with spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2
" Round indent to nearest multiple of 2
set shiftround
" No line-wrapping
set nowrap
" Spell-check always on
"set spell
" Underscores denote words
"set iskeyword-=_
" No extra spaces when joining lines
set nojoinspaces
" Interpret numbers with leading zeroes as decimal, not octal
set nrformats=
" Auto-format comments
set formatoptions+=roq



" Interactions

" Start scrolling slightly before the cursor reaches an edge
set scrolloff=3
set sidescrolloff=2
" Scroll sideways a character at a time, rather than a screen at a time
set sidescroll=1
" Allow motions and back-spacing over line-endings etc.
set backspace=indent,eol,start
set whichwrap=h,l,b,<,>,~,[,]
" Don't redraw the screen unless we need to
set lazyredraw
" Write swapfiles to disk a little sooner
set updatetime=250



" Visual decorations

" Show status line
set laststatus=2
" Show what mode you're currently in
set showmode
" Show what commands you're typing
set showcmd
" Allow modelines
set modeline
" Show current line and column position in file
set ruler
" Customise our current location information
set statusline=%f\ %=Line\ %l/%L\ Col\ %c\ (%p%%)
" Show file title in terminal tab
set title
" Show invisibles
set list
set listchars=tab:\|\ ,trail:-
" Set relative line numbers...
set relativenumber
" ...but absolute numbers on the current line (hybrid numbering)
set number
" Force the cursor onto a new line after 80 characters
"set textwidth=80
" However, in Git commit messages, let's make it 72 characters
autocmd FileType gitcommit set textwidth=72
" Colour the column just after our line limit so that we don't type over it
set colorcolumn=+81
" In Git commit messages, also colour the 51st column (for titles)
autocmd FileType gitcommit set colorcolumn+=51
" Highlight current line
"set cursorline



" Search

" Don't keep results highlighted after searching...
set nohlsearch
" ...just highlight as we type
set incsearch
" Ignore case when searching...
set ignorecase
" ...except if we input a capital letter
set smartcase


" Key mappings


" open/close NERDTree
nmap <leader>n :NERDTreeToggle<CR>
" just use ^[ instead of esc
" jj to throw you into normal mode from insert mode
"inoremap jj <esc>
" jk to throw you into normal mode from insert mode
"inoremap jk <esc>
" Disable arrow keys (hardcore)
map  <up>    <nop>
imap <up>    <nop>
map  <down>  <nop>
imap <down>  <nop>
map  <left>  <nop>
imap <left>  <nop>
map  <right> <nop>
imap <right> <nop>
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
" Make `Y` behave like `C` and `D`
nnoremap Y y$
" Make `n`/`N` bring next search result to middle line
nnoremap n nzz
nnoremap N Nzz
" `vv` to highlight just the text (i.e. no indents) in a line
"nnoremap vv ^vg_
" `<Cr` in normal mode inserts a break at the cursor and enters insert mode
"nnoremap <Cr> i<CR><ESC>I
" `G` skips to bottom of file and places line in middle of screen
nnoremap G :norm! Gzz<CR>
" Switch to previous window
nnoremap <leader>` <C-w><C-p>
" Vim-like window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" `gb` switches to next buffer, like `gt` does with tabs
nnoremap gb :bn<Cr>
" `gB` switches to previous buffer, like `gT` does with tabs
nnoremap gB :bp<Cr>
" `gf` opens file under cursor in a new vertical split
nnoremap gf :vertical wincmd f<CR>
" `gF` opens file under cursor in a new split
nnoremap gF <C-w>f
" Toggle `hlsearch` with <Space>/
nnoremap <leader>/ :set hlsearch!<CR>
" Make tabbing persistent in visual mode
vnoremap <tab> >gv
" Toggle indentLine plugin on/off
"nnoremap <leader>i :IndentLinesToggle<CR>
"make visual mode < and > re-select after indenting
vnoremap < <gv
vnoremap > >gv

" Make keypad function correctly
"map <Esc>Oq 1
"map <Esc>Or 2
"map <Esc>Os 3
"map <Esc>Ot 4
"map <Esc>Ou 5
"map <Esc>Ov 6
"map <Esc>Ow 7
"map <Esc>Ox 8
"map <Esc>Oy 9
"map <Esc>Op 0
"map <Esc>On .
"map <Esc>OQ /
"map <Esc>OR *
"map <kPlus> +
"map <Esc>OS -
"map <Esc>OM <CR>
"map! <Esc>Oq 1
"map! <Esc>Or 2
"map! <Esc>Os 3
"map! <Esc>Ot 4
"map! <Esc>Ou 5
"map! <Esc>Ov 6
"map! <Esc>Ow 7
"map! <Esc>Ox 8
"map! <Esc>Oy 9
"map! <Esc>Op 0
"map! <Esc>On .
"map! <Esc>OQ /
"map! <Esc>OR *
"map! <kPlus> +
"map! <Esc>OS -
"map! <Esc>OM <CR>;

"snippets
nnoremap ,html :read $HOME/.vim/snippets/html.html<CR>3jf>a
nnoremap ,lipsum :read $HOME/.vim/snippets/lipsum.txt<CR>

" Abbreviations and auto-completions

" lipsum<Tab> drops some Lorem ipsum text into the document
"iab lipsum Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
