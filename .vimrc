" TODO: use this
" for now im using 'keymap', whith sets iminsert and uses lmap.
" this is an alternative to lmap where it sets your system insert mode
" instead. " this function is callet to know which system insert mode should be set.
" basically i want all normal charater modes (insert, cmd, search etc..) to be
" dvorak and all the "normal mode"(s) shoulde be qwerty.
function MyImStatusFunc()
	let l:mode = mode()
	let is_active = 
				\    l:mode != "n"
				\ && l:mode != "no"
				\ && l:mode != "nov"
				\ && l:mode != "noV"
				\ && l:mode != "noCTRL-V"
				\ && l:mode != "niI"
				\ && l:mode != "niR"
				\ && l:mode != "niV"
				\ && l:mode != "nt"
				\ && l:mode != "v"
				\ && l:mode != "vs"
				\ && l:mode != "V"
				\ && l:mode != "Vs"
				\ && l:mode != "CTRL-V"
				\ && l:mode != "CTRL-Vs"
				\ && l:mode != "s"
				\ && l:mode != "S"
				\ && l:mode != "CTRL-S"
				\ && l:mode != "r"
				\ && l:mode != "rm"
				\ && l:mode != "r?"
	return is_active ? 1 : 0
endfunction
set imstatusfunc=MyImStatusFunc

" TODO:
" put these on the status line to replace vim-airline
" filename (full)
" filetype maybe?
" if the file has been edited without saving
"	https://github.com/inkarkat/vim-StatusLineHighlight/blob/master/plugin/StatusLineHighlight.vim
" also change active window to different background colour.. maybe make 
" non-active a lower contrast
"
" make a hotkey for y"% that would do :let "@ = @% 
" (but instead of just % you can type any buffer you want)
"
" Plugin to open the header file. (maybe save location of header file in
" .viminfo

filetype plugin indent on
" Detect filetype
filetype plugin on

" include help for plugins please
" we have a benign error: (tags after this still load)
" E152: cannot open /usr/share/vim/vim81/doc/tags for writing
silent! helptags ALL

augroup vimrc
	" clear vimrc autocmds so it can be sourced multiple times
	autocmd!
augroup END

set nofixendofline
" short ttimeoutlen: this is the timeout (milliseconds) for terminal escape codes, these
" aren't supposed to be human typable, only sent by the terminal.
" for some reason, default has become about 1 second for me
set ttimeoutlen=10

let g:mac=0
if has("unix")
	let s:uname = system("uname")
	if s:uname == "Darwin\n"
		let g:mac=1
	endif
endif

" dvorak in insert/replace/search mode
set keymap=dvorak

"Space as a Leader
let mapleader = "\<Space>"
" Use Vim features, not Vi
set nocompatible

set encoding=utf-8

" delete a buffer (like ":bdelete") when it becomes hidden (when no windows show it)
" TODO: debug me; this works if i load vim with no plugins / vimrc, but it doesn't work in my setup :(
set bufhidden=delete

" make vitality fix the focus, but don't make it break my font
"let g:vitality_fix_cursor = 0
"let g:vitality_fix_focus = 1
"let g:vitality_always_assume_iterm = 0

augroup vimrc
	" write and read viminfo when we switch
	autocmd FocusGained * sleep 50m | :rviminfo
	autocmd FocusLost * :wviminfo

	" save a session if we are dying...
	autocmd VimLeave * if v:dying | mksession! | endif
augroup END

" save a session if we are dying...
au VimLeave * if v:dying | mksession! | endif


augroup vimrc
	" Don't need wrapmargin
	autocmd BufRead,BufNewFile /**/blui*/* setlocal colorcolumn=101 textwidth=100 formatoptions+=tj
	" wilwifi numberline
	autocmd BufRead,BufNewFile **/iwlwifi-stack-dev/** setlocal colorcolumn=81,112 textwidth=80 formatoptions+=tj makeprg=make\ -C\ /home/angele/intel_final/
	" colorcolumn 81: red line after we should wrap
	"			 112: red line after the screen starts scrolling when monitor
	"			 is split vertically
augroup END

" C(++) indent options.
" default:
set cinoptions=>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l0,b0,gs,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,k0,m0,j0,J0,)20,*70,#0,P0
" l1: switch case surrounding braces
" g0: public/private:
" N-s: namespace indentation = 0
" j1: indent "java anonymous classes" correctly (fixes C++ lambdas)
" Ls: indent labels
" (s: indent in unclosed parentheses
set cinoptions+=l1,g0,N-s,j1,Ls,(s

" default:
set cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
" also indent when we type "break" at the start of a line
set cinkeys+=0=break

" Surround
let g:surround_{char2nr("#if")} = "#if \1if token: \1\r#endif // \1\1"
let g:surround_{char2nr("*")} = "/*\r*/"

" VEBUGGER - lldb integration within vim
let g:vebugger_leader='<Leader>d'
"TODO: set lldb path
let g:vebugger_path_python_lldb='/usr/bin/python'
let g:vebugger_path_python_2='/usr/bin/python'





nnoremap \n :cn<CR>
nnoremap \p :cp<CR>


" Toggle wrapping with this keymap
"  - smoothscroll: scroll partial lines when one is wrapped
"  - linebreak: don't break a word when wrapping
nnoremap <leader>w :set wrap! smoothscroll linebreak<CR>

nnoremap <leader>w :setlocal wrap! smoothscroll linebreak<CR>
nnoremap <leader>de :setlocal diff scb<CR>
nnoremap <leader>dd :set nodiff noscb<CR>






nnoremap <leader>sj :SplitjoinSplit<cr>
nnoremap <leader>sk :SplitjoinJoin<cr>
let g:splitjoin_trailing_comma = 1
let g:splitjoin_java_argument_split_first_newline = 1
let g:splitjoin_java_argument_split_last_newline  = 1

function! LoadSplitJoinCFile()
	if !exists('b:splitjoin_split_callbacks')
	let b:splitjoin_split_callbacks = [
			\ 'sj#c#SplitIfClause',
			\ 'sj#c#SplitFuncall',
			\ ]
	endif

	if !exists('b:splitjoin_join_callbacks')
	let b:splitjoin_join_callbacks = [
			\ 'sj#c#JoinFuncall',
			\ 'sj#c#JoinIfClause',
			\ ]
	endif
endfunction

augroup vimrc
	autocmd FileType cpp :call LoadSplitJoinCFile()
augroup END







" fugitive git bindings
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>gt :Gcommit -v -q %:p<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gvs :Gvsplit<CR>
" This is extraordinarily slow... disabling it
" nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gp :Ggrep<Space>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gB :Git branch<Space>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gps :Dispatch! git push<CR>
nnoremap <leader>gpl :Dispatch! git pull<CR>

augroup vimrc
	autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END





"let g:wordmotion_prefix = "g"
let g:wordmotion_mappings = {
\ 'w': 'gw',
\ 'e': 'ge',
\ 'b': 'gb',
\ 'ge': '',
\ 'W': 'gW',
\ 'E': 'gE',
\ 'B': 'gB',
\ 'gE': '',
\ 'iw': 'igw',
\ 'aw': 'agw',
\ 'iW': 'igW',
\ 'aW': 'agW',
\ }
" disabling these bindings, i don't think i want it always active
"" vim-wordmotion:
""  change gw, ge, gb, giw, etc... to do the default VIM version of those.
"nnoremap gw w
"nnoremap ge e
"nnoremap gb b
"nnoremap gb b
"vnoremap gw w
"vnoremap ge e
"vnoremap gb b
"vnoremap gb b
"vnoremap giw iw
"vnoremap gaw aw
"vnoremap igw iw
"vnoremap agw aw
"
"" This is not technically correct, i think gW actually goes backwards or
"" something?
"" in any case, i now do gW sometimes when i mean W and i don't use the g
"" version
"nnoremap gW W
"nnoremap gE E
"nnoremap gB B
"nnoremap gB B
"vnoremap gW W
"vnoremap gE E
"vnoremap gB B
"vnoremap gB B
"vnoremap giW iW
"vnoremap gaW aW
"vnoremap igW iW
"vnoremap agW aW
"
"" operator-pending mode mappings... like visual mode but works with diw
"onoremap gw w
"onoremap ge e
"onoremap gb b
"onoremap gb b
"onoremap giw iw
"onoremap gaw aw
"onoremap igw iw
"onoremap agw aw







" suckless - better window-manager keybinds
let g:suckless_tmap = 1 " allow keybinds within :term windows
let g:suckless_tabline = 0
let g:suckless_guitablabel = 1
let g:suckless_wrap_around_jk = 0  " wrap in current column (wmii-like)
let g:suckless_wrap_around_hl = 0  " wrap in current tab    (wmii-like)
"let g:MetaSendsEscape = 0  " use this if Alt-j outputs an 'ê' on your terminal Vim
"let g:MetaSendsEscape = 1  " use this if Alt shortcuts don't work on gVim / MacVim

" SaneOS - use meta (alt) key
"let g:suckless_mappings = {
"\        '<M-[sdf]>'      :   'SetTilingMode("[sdf]")'    ,
"\        '<M-[hjkl]>'     :    'SelectWindow("[hjkl]")'   , " using custom binding because i don't want to leave terminal in ^w-N mode when moving away
"\        '<M-[HJKL]>'     :      'MoveWindow("[hjkl]")'   , " using custom binding because it breaks with terminal windows
"\      '<C-M-[hjkl]>'     :    'ResizeWindow("[hjkl]")'   ,
"\        '<M-[oO]>'       :    'CreateWindow("[sv]")'     ,
"\        '<M-w>'          :     'CloseWindow()'           , " using custom binding because it breaks with terminal windows
"\   '<Space>[123456789]'  :       'SelectTab([123456789])',
"\  '<Space>t[123456789]'  : 'MoveWindowToTab([123456789])',
"\  '<Space>T[123456789]'  : 'CopyWindowToTab([123456789])',
"\}
let g:suckless_mappings = {
\        '<M-[sdf]>'      :   'SetTilingMode("[sdf]")'    ,
\      '<C-M-[hjkl]>'     :    'ResizeWindow("[hjkl]")'   ,
\        '<M-[oO]>'       :    'CreateWindow("[sv]")'     ,
\   '<Space>[123456789]'  :       'SelectTab([123456789])',
\  '<Space>t[123456789]'  : 'MoveWindowToTab([123456789])',
\  '<Space>T[123456789]'  : 'CopyWindowToTab([123456789])',
\}

let g:MetaSendsEscape = 0 " default meta escape is bad, it uses map instead of set... set uses a very short timeout for non-human typable keybindings
                          " This allows you to type escape without causing the window manager to do things... ie, `set -o vi` in :term windows
" <M-[sdf]>
"set <M-s>=s
"nmap <Esc><s> <silent> :call setTilingMode("s") <CR>
"tmap <Esc><s> <silent> <C-\><C-n>:call setTilingMode("s", 1) <CR>
set <M-d>=d
set <M-f>=f

" <M-[hjkl]>
set <M-h>=h
set <M-j>=j
set <M-k>=k
set <M-l>=l

nmap <Esc>H <C-w>gh
nmap <Esc>J <C-w>gj
nmap <Esc>K <C-w>gk
nmap <Esc>L <C-w>gl

map <M-h> <C-w>h
map <M-j> <C-w>j
map <M-k> <C-w>k
map <M-l> <C-w>l
tmap <M-h> <C-w>h
tmap <M-j> <C-w>j
tmap <M-k> <C-w>k
tmap <M-l> <C-w>l

" <M-[nN]>
set <M-n>=n
set <M-N>=N
tmap <M-n> <C-w>N
tmap <M-N> <C-w>N

" <M-[HJKL]>
set <M-H>=H
set <M-J>=J
set <M-K>=K
set <M-L>=L

nmap <Esc>H <C-w>gh
nmap <Esc>J <C-w>gj
nmap <Esc>K <C-w>gk
nmap <Esc>L <C-w>gl

" can't get these to work :(
"map <Esc>è <C-w>gh
"map <Esc>ê <C-w>gj
"map <Esc>ë <C-w>gk
"map <Esc>ì <C-w>gl
"
"set <M-H>=è
"set <M-J>=ê
"set <M-K>=ë
"set <M-L>=ì

"map <M-J> <C-w>J
"map <M-K> <C-w>K
"map <M-L> <C-w>L
"tmap <M-H> <C-w>H
"tmap <M-J> <C-w>J
"tmap <M-K> <C-w>K
"tmap <M-L> <C-w>L
map <M-H> <C-w>gh
map <M-J> <C-w>gj
map <M-K> <C-w>gk
map <M-L> <C-w>gl
tmap <M-H> <C-w>gh
tmap <M-J> <C-w>gj
tmap <M-K> <C-w>gk
tmap <M-L> <C-w>gl

" <C-M-[hjkl]>
set <C-M-h>=
"set <C-M-j>= 
"nmap <Esc><C-j> <silent> :call ResizeWindow("j") <CR>
"tmap <Esc><C-j> <silent> <C-\><C-n>:call ResizeWindow("j", 1) <CR>
set <C-M-k>=
set <C-M-l>=

" <M-[oO]>
set <M-o>=o
"set <M-O>=O
"nmap <Esc><O> <silent> :call CreateWindow("v") <CR>
"tmap <Esc><O> <silent> <C-\><C-n>:call CreateWindow("v", 1) <CR>

" <M-w>
set <M-w>=w
set <M-q>=q

map <M-w> <C-w>q
tmap <M-w> <C-w>:q!<CR>
map <M-q> <C-w>q
tmap <M-q> <C-w>:q!<CR>

nmap <C-W>q     <C-W><C-Q>
nmap <C-W><C-Q> <Plug>(yanked-buffer-q)
nmap <C-W>t     <Plug>(yanked-buffer-p)
nmap <M-t>      <C-W>t
nmap <M-T>      <C-W>t

nmap <M-CR>     :term<CR>
tmap <M-CR>     <C-w>:term<CR>

" TODO: make it only work if current buffer is vimscript
set <M-r>=r
nmap <M-r> :%yank "<CR>:@"<CR>

nmap <M-,> :execute 'vertical resize -' . ((winwidth(winnr())  / 4) + 1)<CR>
nmap <M-.> :execute 'vertical resize +' . ((winwidth(winnr())  / 4) + 1)<CR>
nmap <M-=> :execute 'resize +'          . ((winheight(winnr()) / 4) + 1)<CR>
nmap <M-_> :execute 'resize -'          . ((winheight(winnr()) / 4) + 1)<CR>
nmap <M--> :execute 'resize -'          . ((winheight(winnr()) / 4) + 1)<CR>
tmap <M-,> <C-w>:execute 'vertical resize -' . ((winwidth(winnr())  / 4) + 1)<CR>
tmap <M-.> <C-w>:execute 'vertical resize +' . ((winwidth(winnr())  / 4) + 1)<CR>
tmap <M-=> <C-w>:execute 'resize +'          . ((winheight(winnr()) / 4) + 1)<CR>
tmap <M-_> <C-w>:execute 'resize -'          . ((winheight(winnr()) / 4) + 1)<CR>
tmap <M--> <C-w>:execute 'resize -'          . ((winheight(winnr()) / 4) + 1)<CR>
set <M-,>=,
set <M-.>=.
set <M-=>==
set <M-_>=-

" Not using this; using '\' as the leader for plugins.
" nnoremap <leader>1 :tabnext 1<CR>
" nnoremap <leader>2 :tabnext 2<CR>
" nnoremap <leader>3 :tabnext 3<CR>
" nnoremap <leader>4 :tabnext 4<CR>
" nnoremap <leader>5 :tabnext 5<CR>
" nnoremap <leader>6 :tabnext 6<CR>
" nnoremap <leader>7 :tabnext 7<CR>
" nnoremap <leader>8 :tabnext 8<CR>
" nnoremap <leader>9 :tabnext 9<CR>

" nnoremap <leader>t1 :call MoveWindowToTab(1)<CR>
" nnoremap <leader>t2 :call MoveWindowToTab(2)<CR>
" nnoremap <leader>t3 :call MoveWindowToTab(3)<CR>
" nnoremap <leader>t4 :call MoveWindowToTab(4)<CR>
" nnoremap <leader>t5 :call MoveWindowToTab(5)<CR>
" nnoremap <leader>t6 :call MoveWindowToTab(6)<CR>
" nnoremap <leader>t7 :call MoveWindowToTab(7)<CR>
" nnoremap <leader>t8 :call MoveWindowToTab(8)<CR>
" nnoremap <leader>t9 :call MoveWindowToTab(9)<CR>

" Don't automatically reset window size when closing a window
set noequalalways



















function! DeleteFileSwaps()
	write
	let l:output = ''
	redir => l:output 
	silent exec ':sw' 
	redir END 
	let l:current_swap_file = substitute(l:output, '\n', '', '')
	let l:base = substitute(l:current_swap_file, '\v\.\w+$', '', '')
	let l:swap_files = split(glob(l:base.'\.s*'))
	" delete all except the current swap file
	for l:swap_file in l:swap_files
		if !empty(glob(l:swap_file)) && l:swap_file != l:current_swap_file 
			call delete(l:swap_file)
			echo "swap file removed: ".l:swap_file
		endif
	endfor
	" Reset swap file extension to `.swp`.
	set swf! | set swf!
	echo "Reset swap file extension for file: ".expand('%')
endfunction
command! DeleteFileSwaps :call DeleteFileSwaps()














" SplitMove - Better moving a window around?
function! SplitMove2(dir) abort
  let l:pos = win_screenpos(0)
  let l:target = winnr(a:dir)

  if l:target == 0 || l:target == winnr()
    execute 'wincmd' toupper(a:dir)
    return
  endif

  let l:targetid = win_getid(l:target)
  let l:targetpos = win_screenpos(l:target)

  " try to place the new window in the natural position
  " - if the current window is at least as big as the target then
  "   compare the cursor position and the midpoint of the target window
  " - if the current window is smaller than the target
  "   then compare the midpoints of the current and target windows
  if a:dir ==# 'h' || a:dir ==# 'l'
    if l:pos[0] +
          \ (winheight(0) >= winheight(target)
          \   ? winline()-1 : winheight(0) / 2)
          \ <= l:targetpos[0] + winheight(target) / 2
      let l:flags = { 'rightbelow': 0 }
    else
      let l:flags = { 'rightbelow': 1 }
    endif
  else
    if l:pos[1] +
          \ (winwidth(0) >= winwidth(target)
          \   ? wincol()-1 : winwidth(0) / 2)
          \ <= l:targetpos[1] + winwidth(target) / 2
      let l:flags = { 'rightbelow': 0, 'vertical': 1 }
    else
      let l:flags = { 'rightbelow': 1, 'vertical': 1 }
    endif
  endif

  call win_splitmove(winnr(), l:target, l:flags)
endfunction


function! FindSplitTypeAndSiblings(...)
	" Return values:
	" -1: error
	"  0: found nothing of importance
	"  1: only found a leaf
	"  [sibling_rightbelow, sibling_leftabove, row/column]

	if a:0 == 0
		return FindSplitTypeAndSiblings(winlayout())
	endif

	let l:descriptor = a:1

	if l:descriptor[0] ==# 'row' || l:descriptor[0] ==# 'col'
		let l:i = 0
		while l:i < len(l:descriptor[1])
			let l:newdescriptor = l:descriptor[1][l:i]

			let l:retval = FindSplitTypeAndSiblings(l:newdescriptor)
			if type(l:retval) == v:t_list
				return l:retval
			endif

			if l:retval == 1
				"only found a leaf, we need to turn that into the return value
				let l:rowcol = l:descriptor[0]
				let l:rightbelow = l:i != len(l:descriptor[1]) - 1
				let l:leftabove = l:i != 0
				return [l:rightbelow, l:leftabove, l:rowcol]
			elseif l:retval != 0
				" found current window! (or error), pass it up
				return l:retval
			endif

			let l:i = l:i + 1
		endwhile

	elseif l:descriptor[0] ==# 'leaf'
		return l:descriptor[1] == win_getid()
	else
		echoerr "FindSplitTypeAndSiblings(): Unsupported type from winlayout."
		return -1
	endif
endfunction


" SplitMove2 - Better moving a window around?
function! SplitMove(dir) abort
	let l:pos = win_screenpos(0)
	let l:target = winnr(a:dir)

	if l:target == 0 || l:target == winnr()
		execute 'wincmd' toupper(a:dir)
		return
	endif

	let l:targetid = win_getid(l:target)
	let l:targetpos = win_screenpos(l:target)

	let l:myid = win_getid()

	"enum for leaf, row, col
	let l:leaf = 0
	let l:row = 1
	let l:col = 2

	" Tree noting down position of each window
	" Tree is a list of lists.
	"	Each list is either a descriptor or a container.
	"	Descriptor:
	"		['row', container_list] (corresponds to vertical splits)
	"		['col', container_list] (corresponds to horizontal splits)
	"		['leaf', 1000] <- the number here is a window id.
	"	Container:
	"		[descriptor, descriptor, ...]
	"	The root list is always a descriptor.
	let l:layout = winlayout()
	" stack: position in layout, descriptors only contain a label then a list, 
	" so we don't need to keep an idx for each descriptor
	" (or leaf which has no container)
	let l:i_layout = []


	" -1: error
	"  0: found nothing of importance
	"  1: only found a leaf
	"  [sibling_rightbelow, sibling_leftabove, row/column]
	let l:splitTypeAndSiblings = FindSplitTypeAndSiblings()
	if type(l:splitTypeAndSiblings) == v:t_list
		let l:sibling_rightbelow = l:splitTypeAndSiblings[0]
		let l:sibling_leftabove = l:splitTypeAndSiblings[1]
		let l:rowcol = l:splitTypeAndSiblings[2]

	elseif l:splitTypeAndSiblings == -1
		echoerr "SplitMove2(): Error with FindSplitTypeAndSiblings()"
		return
	elseif l:splitTypeAndSiblings == 0
		echoerr "SplitMove2(): FindSplitTypeAndSiblings() Didn't find the current window."
		return
	elseif l:splitTypeAndSiblings == 1
		" This is the only window.
		echom "No windows to move."
		return
	else
		echoerr "SplitMove2(): Unknown return from FindSplitTypeAndSiblings()"
		return
	endif


	" l:sibling_rightbelow
	" l:sibling_leftabove
	" l:rowcol
	let l:flags = {}
	" try to place the new window in the natural position
	if a:dir ==# 'h'
		"Left
		let l:flags.vertical = 1

		if l:rowcol ==# 'col'
			"Column: splitmove with window on outside of column
			" In this scenario, there must be a row outside the column, 
			" otherwise it would have been handled above.
			let l:flags.rightbelow = 1

		elseif l:rowcol ==# 'row'
			"Row: splitmove with sibling window on the left, swapping 
			"positions. If there is no sibling on the left, we are going to 
			"the right of the grandparent

			let l:flags.rightbelow = ! l:sibling_leftabove
			let l:flags.vertical = ! l:sibling_leftabove
		else
			echoerr "SplitMove2(): Unknown return from FindSplitTypeAndSiblings() (rowcol)"
		endif

	elseif a:dir ==# 'l'
		"Right
		let l:flags.vertical = 1

		if l:rowcol ==# 'col'
			"Column: splitmove with window on outside of column
			" In this scenario, there must be a row outside the column, 
			" otherwise it would have been handled above.
			let l:flags.rightbelow = 0

		elseif l:rowcol ==# 'row'
			"Row: splitmove with sibling window on the right, swapping 
			"positions. If there is no sibling on the right, we are going to 
			"the left of the grandparent

			let l:flags.rightbelow = l:sibling_rightbelow
			let l:flags.vertical = ! l:sibling_rightbelow
		else
			echoerr "SplitMove2(): Unknown return from FindSplitTypeAndSiblings() (rowcol)"
		endif

	elseif a:dir ==# 'k'
		"Up
		let l:flags.vertical = 0

		if l:rowcol ==# 'row'
			"Row: splitmove with window on outside of row
			" In this scenario, there must be a column outside the row, 
			" otherwise it would have been handled above.
			let l:flags.rightbelow = 1

		elseif l:rowcol ==# 'col'
			"Column: splitmove with sibling window above, swapping positions. 
			"If there is no sibling above, we are going to the bottom of the 
			"grandparent

			let l:flags.rightbelow = ! l:sibling_leftabove
			"let l:flags.vertical = l:sibling_leftabove
		else
			echoerr "SplitMove2(): Unknown return from FindSplitTypeAndSiblings() (rowcol)"
		endif

	elseif a:dir ==# 'j'
		"Down
		let l:flags.vertical = 0

		if l:rowcol ==# 'row'
			"Row: splitmove with window on outside of row
			" In this scenario, there must be a column outside the row, 
			" otherwise it would have been handled above.
			let l:flags.rightbelow = 0

		elseif l:rowcol ==# 'col'
			"Column: splitmove with sibling window below, swapping positions. 
			"If there is no sibling below, we are going to the top of the 
			"grandparent

			let l:flags.rightbelow = l:sibling_rightbelow
			"let l:flags.vertical = l:sibling_rightbelow
		else
			echoerr "SplitMove2(): Unknown return from FindSplitTypeAndSiblings() (rowcol)"
		endif

	else
		return
	endif

	call win_splitmove(winnr(), l:target, l:flags)
endfunction

nnoremap <silent> <c-w>gh :<c-u>call SplitMove('h')<cr>
nnoremap <silent> <c-w>gj :<c-u>call SplitMove('j')<cr>
nnoremap <silent> <c-w>gk :<c-u>call SplitMove('k')<cr>
nnoremap <silent> <c-w>gl :<c-u>call SplitMove('l')<cr>
tnoremap <silent> <c-w>gh <c-w>:<c-u>call SplitMove('h')<cr>
tnoremap <silent> <c-w>gj <c-w>:<c-u>call SplitMove('j')<cr>
tnoremap <silent> <c-w>gk <c-w>:<c-u>call SplitMove('k')<cr>
tnoremap <silent> <c-w>gl <c-w>:<c-u>call SplitMove('l')<cr>

" -------------------------------------------












" -------------------------------------------
" --------------- Better Tabs ---------------

" get some label for a single tab
function! MyTabLabel(tabarg)
	" try t:TabLabel
	let l:result = gettabvar(a:tabarg, "TabLabel", "")
	" or active buffer name
	if empty(l:result)
		let l:result = bufname(winbufnr(win_getid(tabpagewinnr(a:tabarg), a:tabarg)))
	endif
	" or some fixed string
	if empty(l:result)
		let l:result = '[Noname]'
	endif
	" truncate the path, so (hopefully) it will not get too long
	return l:result[strridx(l:result, '/') + 1 : ]
endfunction

" build the whole tabline
function! MyTabLine()
	let l:result = ''
	" all our tabs
	for l:num in range(1, tabpagenr("$"))
		" tab color
		let l:result .= (l:num != tabpagenr()) ? '%#TabLine#' : '%#TabLineSel#'
		" tab text
		let l:result .= '%' . l:num . 'T %{MyTabLabel(' . l:num . ')} '
	endfor
	" space filler
	let l:result .= '%#TabLineFill#%T%='
	" [X] button on the right if there are several tabs
	let l:result .= repeat('%#TabLine#%999X[X]', l:num > 1)
	return l:result
endfunction
" -------------------------------------------









" SucklessTabLabelModified: GUI tabs
function! SucklessTabLabelModified(...) "{{{
	let space = a:0 ? '' : ' '
	let tabnr = a:0 ? a:1 : v:lnum
	let buflist = tabpagebuflist(tabnr)
	let l:hasModifiedBuffer = 0

	" [num] + modified since the last save?
	let label = space . '[' . tabnr
	for bufnr in buflist
		if getbufvar(bufnr, '&modified') && getbufvar(bufnr, '&buftype') != "terminal"
			let label .= '*'
			let l:hasModifiedBuffer = 1
			break
		endif
	endfor
	let label .= ']' . space

	" buffer name
	let buf = buflist[tabpagewinnr(tabnr) - 1]
	let name = MyTabLabel(tabnr)
	"let name = bufname(buf) REPLACING THIS WITH MY OWN
	if name =~ '^term://.*:'
		" display the process name (XXX fails if there's a space in the path)
		let label .= fnamemodify(name, ':s/^term:.*://:s/\s.*//:t:r')
	else
		" display the file name
		let label .= fnamemodify(name, ':t')
	endif

	if l:hasModifiedBuffer
		return label
	endif
	return label . ' '
endfunction "}}}

function! SucklessTabLineModified() "{{{
	let line = ''

	for i in range(tabpagenr('$'))
		" a space before each non-selected label as long as its not directly
		" before the selected label
		let prevspace = (i+1 != tabpagenr() && i != tabpagenr()) ? ' ' : ''
		" a space before and after the selected label, highlighted as
		" selected.
		let prevspacesel = (i+1 == tabpagenr()) ? ' ' : ''
		let postspacesel = (i+1 == tabpagenr()) ? ' ' : ''

		let line .= '%#TabLineFill#' . prevspace

		" highlighting
		let line .= (i+1 == tabpagenr()) ? '%#TabLineSel#' : '%#TabLine#'
		" set the tab page number (for mouse clicks)
		let line .= '%' . (i+1) . 'T'
		" tab number + active buffer name
		let line .= prevspacesel . trim(SucklessTabLabelModified(i+1)) . postspacesel
	endfor

	" after the last tab fill with TabLineFill and reset tab page nr
	let line .= '%#TabLineFill#%T'

	if tabpagenr('$') > 1
		" right-align the rest
		let line .= '%=%#TabLine#'
		" put the current PID in the corner
		let line .= getpid()
		" X to close current tab page
		let line .= ' %999X[X]'
	endif

	return line
endfunction "}}}
set tabline=%!SucklessTabLineModified()














augroup vimrc
	" ctrl-u / ctrl-d to scroll half a window minus a few lines
	autocmd WinEnter    ?* let &scroll=max([1, (winheight(winnr())/2)-3])
augroup END









" Quickscope - highlight jump targets
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END











" This needs to be called before colour scheme
function! KittyTerm()

	" Mouse support
	set mouse=a
	set ttymouse=sgr
	set balloonevalterm
	" Styled and colored underline support
	let &t_AU = "\e[58:5:%dm"
	let &t_8u = "\e[58:2:%lu:%lu:%lum"
	let &t_Us = "\e[4:2m"
	let &t_Cs = "\e[4:3m"
	let &t_ds = "\e[4:4m"
	let &t_Ds = "\e[4:5m"
	let &t_Ce = "\e[4:0m"
	" Strikethrough
	let &t_Ts = "\e[9m"
	let &t_Te = "\e[29m"
	" Truecolor support
	let &t_8f = "\e[38:2:%lu:%lu:%lum"
	let &t_8b = "\e[48:2:%lu:%lu:%lum"
	let &t_RF = "\e]10;?\e\\"
	let &t_RB = "\e]11;?\e\\"
	" Bracketed paste
	let &t_BE = "\e[?2004h"
	let &t_BD = "\e[?2004l"
	let &t_PS = "\e[200~"
	let &t_PE = "\e[201~"
	" Cursor control
	let &t_RC = "\e[?12$p"
	let &t_SH = "\e[%d q"
	let &t_RS = "\eP$q q\e\\"
	let &t_SI = "\e[5 q"
	let &t_SR = "\e[3 q"
	let &t_EI = "\e[1 q"
	let &t_VS = "\e[?12l"
	" Focus tracking
	let &t_fe = "\e[?1004h"
	let &t_fd = "\e[?1004l"
	execute "set <FocusGained>=\<Esc>[I"
	execute "set <FocusLost>=\<Esc>[O"
	" Window title
	let &t_ST = "\e[22;2t"
	let &t_RT = "\e[23;2t"

	" vim hardcodes background color erase even if the terminfo file does
	" not contain bce. This causes incorrect background rendering when
	" using a color theme with a background color in terminals such as
	" kitty that do not support background color erase.
	let &t_ut=''
endfunction

if $TERM == 'xterm-kitty'
	augroup vimrc
		" This needs to be called before colour scheme
		autocmd ColorSchemePre * call KittyTerm()
	augroup END
else
	packadd terminus
endif








" Gundo - undo tree
" display the undo tree with <leader>u.
nnoremap <leader>u :GundoToggle<CR>
let g:gundo_prefer_python3 = 1
let g:gundo_width = 70
"let g:gundo_preview_height = 40
"let g:gundo_right = 1


" FSwitch - switch between *.c and *.h files
nnoremap <leader>C :FSHere<CR>
nnoremap <leader>cc :FSHere<CR>
nnoremap <leader>cL :FSRight<CR>
nnoremap <leader>cH :FSLeft<CR>
nnoremap <leader>cK :FSAbove<CR>
nnoremap <leader>cJ :FSBelow<CR>
nnoremap <leader>cl :FSSplitRight<CR>
nnoremap <leader>ch :FSSplitLeft<CR>
nnoremap <leader>ck :FSSplitAbove<CR>
nnoremap <leader>cj :FSSplitBelow<CR>


let mapleader = "\\"
" fzf.vim
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>A :Ag<CR>
nnoremap <leader>a :Agg<CR>
nnoremap <leader>R :Rg<CR>
nnoremap <leader>r :Rgg<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>T :Tags<CR>

let mapleader = "\<Space>"

command! -bang -nargs=* Agg call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
" Rg definition:
" !   Rg                *                        call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, <bang>0)
command! -bang -nargs=* Rgg call
\ fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>)
\ , 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

function! RipgrepFzf(query, fullscreen)
	let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
	let initial_command = printf(command_fmt, shellescape(a:query))
	let reload_command = printf(command_fmt, '{q}')
	let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
	let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
	call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

let g:fzf_preview_window = ['right', 'ctrl-/']
let g:fzf_layout = { 'down': "40%" }
let g:fzf_history_dir = '~/.local/share/fzf-history'



" Path completion with custom source command
" inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
" inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')

" Word completion with custom spec with popup layout option
" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})



" # Function to permanently delete views created by 'mkview'
function! MyDeleteView()
	let path = fnamemodify(bufname('%'),':p')
	" vim's odd =~ escaping for /
	let path = substitute(path, '=', '==', 'g')
	if empty($HOME)
	else
		let path = substitute(path, '^'.$HOME, '\~', '')
	endif
	let path = substitute(path, '/', '=+', 'g') . '='
	" view directory
	let path = &viewdir.'/'.path
	call delete(path)
	echo "Deleted: ".path
endfunction

" # Command Delview (and it's abbreviation 'delview')
command! Delview call MyDeleteView()
" Lower-case user commands: http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev delview <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Delview' : 'delview')<CR>

iabbrev incldue include
iabbrev shrug ¯\_(ツ)_/¯
iabbrev tableflip (ノ°Д°）ノ︵ ┻━┻

iabbrev uint8_T   uint8_t
iabbrev int8_T    int8_t
iabbrev uint16_T  uint16_t
iabbrev int16_T   int16_t
iabbrev uint32_T  uint32_t
iabbrev int32_T   int32_t
iabbrev uint64_T  uint64_t
iabbrev int64_T   int64_t

function! Abbrev_ints_for_buffer()
	iabbrev <buffer> u8  uint8_t
	iabbrev <buffer> i8  int8_t
	iabbrev <buffer> s8  int8_t
	iabbrev <buffer> u16 uint16_t
	iabbrev <buffer> i16 int16_t
	iabbrev <buffer> s16 int16_t
	iabbrev <buffer> u32 uint32_t
	iabbrev <buffer> i32 int32_t
	iabbrev <buffer> s32 int32_t
	iabbrev <buffer> u64 uint64_t
	iabbrev <buffer> i64 int64_t
	iabbrev <buffer> s64 int64_t
endfunction

augroup vimrc
	autocmd FileType cpp :call Abbrev_ints_for_buffer()
	autocmd FileType c   :call Abbrev_ints_for_buffer()
augroup END

" iabbrev uint128-t uint128_t
" iabbrev uint16-t  uint16_t
" iabbrev uint32-t  uint32_t
" iabbrev uint64-t  uint64_t
" iabbrev uint8-t   uint8_t
" 
" iabbrev uint128-T uint128_t
" iabbrev uint16-T  uint16_t
" iabbrev uint32-T  uint32_t
" iabbrev uint64-T  uint64_t
" iabbrev uint8-T   uint8_t

iabbrev :; ::









" Search for selected text, forwards or backwards.
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
			\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
			\gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
			\escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
			\gVzv:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
			\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
			\gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
			\escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
			\gVzv:call setreg('"', old_reg, old_regtype)<CR>









"gitgutter
let g:gitgutter_enabled = 0
nmap <leader>gg :GitGutterToggle<CR>

"rainbow parentheses
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['blue', 'yellow', 'LightRed', 'cyan', 'green', 'white'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'python': {
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
\		'cmake': 0,
\		'cpp': {
\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold', 'start=/\(\(\<operator\>\)\@<!<\)\&[a-zA-Z0-9_]@<\ze[^<]/ end=/>/'],
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
"set omnifunc=syntaxcomplete#Complete
"add spelling to completions, only when spelling is enabled
set complete+=kspell

" ignore whitespace in vimdiff
set diffopt=internal,filler,closeoff
set diffopt+=indent-heuristic,iwhite,hiddenoff,vertical,algorithm:histogram
let g:diff_translations = 0 " speedup

set breakindent
set showbreak=↪>\ 
set breakindentopt=min:20,shift:1


" ALE is prety big, so im keeping it as an opt package
" there is a lot of config i also want to skip if i haven't loaded vim ale
" yet.
command! LoadALE call LoadVimAle()
function! LoadVimAle()
	if g:have_loaded_ale == 1
		return
	endif
	let g:have_loaded_ale = 1
	packadd ale

	" VIM-ALE use compile_commands.json files for c/c++
	let g:ale_c_parse_compile_commands = 1
	" please use C++2a features
	let g:ale_cpp_gcc_options = '-std=c++2a -Wall'
	let g:ale_cpp_clang_options = '-std=c++2a -Wall'
	" work options: TODO make it decide weather we are at work
	let g:ale_objcpp_clangd_options = "-std=c++17 -Wc++17-extensions -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
	let g:ale_objcpp_clang_options  = "-std=c++17 -Wc++17-extensions -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
	let g:ale_cpp_clangd_options    = "-std=c++17 -Wc++17-extensions -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
	let g:ale_cpp_clang_options     = "-std=c++17 -Wc++17-extensions -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
	let g:ale_cpp_gcc_options       = "-std=c++17 -Wc++17-extensions -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
	let g:ale_c_parse_compile_commands = 1
	"let g:ale_linters_explicit = 1
	let g:ale_completion_enabled = 1
	"let b:ale_linters = [
	"\	'clangd', 'clang',
	"\	'language_server', 'shell', 'shellcheck',
	"\]
	"let b:ale_linters = [ 'clangd', 'clang', 'language_server', 'shell', 'shellcheck' ]
	"let b:ale_linters = ['ccls', 'clang', 'clangcheck', 'clangd', 'clangtidy', 'clazy', 'cppcheck', 'cpplint', 'cquery', 'flawfinder', 'gcc']
	"let b:ale_linters = ['clang', 'gcc', clangd]
	" let b:ale_linters = ['language_server', 'shell', 'shellcheck']
	augroup vimrc
		autocmd FileType cpp :ALEDisableBuffer
		autocmd FileType c   :ALEDisableBuffer
		autocmd FileType sh  :ALEEnableBuffer
		autocmd FileType vim :ALEEnableBuffer
	augroup END
	let b:ale_linters = {
	\	'sh': ['language_server', 'shell', 'shellcheck'],
	\	'vim': ['ale_custom_linting_rules', 'vint']
	\}

	windo :e
endfunction
let g:have_loaded_ale = 0

" -- rtags config --
set completefunc=RtagsCompleteFunc
set omnifunc=RtagsCompleteFunc
let g:rtagsRcCmd='/usr/local/bin/rc'
" use quickfix window instead of location list
" let g:rtagsUseLocationList = 0
" let g:rtagsJumpStackMaxSize = 100
let g:rtagsUseDefaultMappings = 0
noremap <Space>ri :call rtags#SymbolInfo()<CR>
noremap <Space>rj :call rtags#JumpTo(g:SAME_WINDOW)<CR>
noremap <Space>rJ :call rtags#JumpTo(g:SAME_WINDOW, { '--declaration-only' : '' })<CR>
noremap <Space>rS :call rtags#JumpTo(g:H_SPLIT)<CR>
noremap <Space>rV :call rtags#JumpTo(g:V_SPLIT)<CR>
noremap <Space>rT :call rtags#JumpTo(g:NEW_TAB)<CR>
noremap <Space>rp :call rtags#JumpToParent()<CR>
noremap <Space>rf :call rtags#FindRefs()<CR>
noremap <Space>rF :call rtags#FindRefsCallTree()<CR>
noremap <Space>rn :call rtags#FindRefsByName(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
noremap <Space>rs :call rtags#FindSymbols(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
noremap <Space>rr :call rtags#ReindexFile()<CR>
noremap <Space>rl :call rtags#ProjectList()<CR>
noremap <Space>rw :call rtags#RenameSymbolUnderCursor()<CR>
noremap <Space>rv :call rtags#FindVirtuals()<CR>
noremap <Space>rb :call rtags#JumpBack()<CR>
noremap <Space>rh :call rtags#ShowHierarchy()<CR>
noremap <Space>rC :call rtags#FindSuperClasses()<CR>
noremap <Space>rc :call rtags#FindSubClasses()<CR>
noremap <Space>rd :call rtags#Diagnostics()<CR>

" -- end rtags configuration --


augroup vimrc
	" python.vim sets tabstop to 8 like this, so i need to override it
	autocmd FileType python setlocal nospell tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
	autocmd FileType yaml setlocal nospell tabstop=4 softtabstop=4 shiftwidth=4 expandtab cinoptions+=J1

	autocmd FileType swift setlocal noexpandtab

	"to add a filetype for unrecognised file
	autocmd BufRead,BufNewFile *.bidl      :set filetype=c
	autocmd BufRead,BufNewFile *.blui      :set filetype=yaml
	autocmd BufRead,BufNewFile *.md        :set filetype=markdown
	autocmd BufRead,BufNewFile .bashal     :set filetype=sh
	autocmd BufRead,BufNewFile .bashfunc   :set filetype=sh
	autocmd BufRead,BufNewFile SConscript* :set filetype=python
	autocmd BufRead,BufNewFile SConstruct* :set filetype=python
	autocmd BufRead,BufNewFile *.py        :set filetype=python
	autocmd BufRead,BufNewFile *.fbs       :set filetype=proto

	" autoindent
	autocmd FileType objcpp set autoindent

	" disable 'included file' completion for c++, c, objc, objcpp: rtags is much faster
	autocmd FileType cpp setlocal complete-=i
	autocmd FileType c setlocal complete-=i
	autocmd FileType objc setlocal complete-=i
	autocmd FileType objcpp setlocal complete-=i

	"spelling
	autocmd FileType markdown setlocal spell
	autocmd FileType text setlocal spell

	"no spelling
	autocmd FileType cs setlocal nospell
	autocmd FileType python setlocal nospell
	" python.vim's indenting is retarded for arrays. disable it
	"let g:pyindent_disable_parentheses_indenting=1
	"let g:pyindent_open_paren = 'shiftwidth()'
	"let g:pyindent_closed_paren_align_last_line = v:false
	"let g:python_indent.closed_paren_align_last_line = v:false
	let g:python_indent =
				\ {
				\ 'closed_paren_align_last_line': v:false,
				\ 'open_paren': 'shiftwidth()'
				\ }

	autocmd FileType cmake :RainbowToggleOff
	autocmd FileType c :RainbowToggleOn
	autocmd FileType cpp :RainbowToggleOn
	autocmd FileType objc :RainbowToggleOn
	autocmd FileType objcpp :RainbowToggleOn
	autocmd FileType yaml :RainbowToggleOn

	"to add a filetype for unrecognised file
	autocmd BufRead,BufNewFile *.bidl     :set filetype=c
	autocmd BufRead,BufNewFile *.md       :set filetype=markdown
	autocmd BufRead,BufNewFile .bashal    :set filetype=sh
	autocmd BufRead,BufNewFile .bashfunc  :set filetype=sh
	autocmd BufRead,BufNewFile SConscript :set filetype=python
	autocmd BufRead,BufNewFile SConstruct :set filetype=python

	autocmd BufRead,BufNewFile *.cpp.tpl  :set filetype=cpp
	autocmd BufRead,BufNewFile *.c.tpl    :set filetype=c
	autocmd BufRead,BufNewFile *.hpp.tpl  :set filetype=cpp
	autocmd BufRead,BufNewFile *.h.tpl    :set filetype=c

	" DeviceTree.yaml are all indented with spaces
	autocmd BufRead,BufNewFile DeviceTree.yaml :setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd BufRead,BufNewFile *.blui          :setlocal shiftwidth=2 expandtab
augroup END

" syntax folding
"set foldmethod=syntax

" Syntax highlighting

" Enable syntax highighting
"syntax enable
syntax on
" Show matching parens, brackets, etc.
set showmatch
" 256 colours please
set t_Co=256
set undofile


" Italicised comments and attributes
highlight Comment cterm=italic
highlight htmlArg cterm=italic



" Set the dimmed colour for Limelight
"let g:limelight_conceal_ctermfg = 'LightGrey'



" Disable indentLine by default
"let g:indentLine_enabled = 0


" NERDTree

" Run NERDTree as soon as we launch Vim...
augroup vimrc
	"autocmd vimenter * NERDTree
	"" ...but focus on the file itself, rather than NERDTree
	"autocmd VimEnter * wincmd p
	" Close Vim if only NERDTree is left open
	autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | silent! quit | endif
	" for some reason there is a bug if its a separate tab when i do my NERDTreeCameraDir
augroup END

" If the setting is set to 2 then it behaves the same as if set to 1 except 
" that the CWD is changed whenever the tree root is changed. For example, if 
" the CWD is /home/marty/foobar and you make the node for 
" /home/marty/foobar/baz the new root then the CWD will become 
" /home/marty/foobar/baz.
let g:NERDTreeChDirMode = 2
let g:NERDTreeSortBookmarks = 0

function! NERDTreeGetTreeRoot()
	let ntree = g:NERDTree.ForCurrentTab()
	if type(ntree) == v:t_dict && ntree->has_key('getRoot')
		return ntree.getRoot().path.str()
	else
		return getcwd()
	endif
endfunction

function! VimRCGit(root, cmd)
	let l:result = trim(system('git -C ' . trim(a:root) . ' ' . trim(a:cmd)))
	if v:shell_error
		return v:null
	endif
	return l:result
endfunction

function! NERDTreeCameraDir()
	if ! exists('g:NERDTreeBookmark')
		return
	endif

	"echomsg "]===========================================================["
	let l:ntRoot = NERDTreeGetTreeRoot()
	let l:gitRoot = VimRCGit(l:ntRoot, 'rev-parse --show-toplevel')

	"if ! exists('t:GitRoot')
	"	echomsg 't:GitRoot "" l:gitRoot ' . l:gitRoot
	"else
	"	echomsg 't:GitRoot ' . t:GitRoot . ' l:gitRoot ' . l:gitRoot
	"endif

	if ! exists('t:GitRoot') || t:GitRoot != l:gitRoot || g:->get('LastGitRoot', '') != t:GitRoot
		let t:GitRoot = l:gitRoot
		let g:LastGitRoot = t:GitRoot

		" must use weird call syntax for scriptlocal methods...
		call g:NERDTreeBookmark.ClearAll()
	else
		return
	endif

	if l:gitRoot == v:null
		return
	endif

	let l:rootDirname = trim(system('basename ' . l:gitRoot)) " TODO: do this inside vimscript for portability

	let l:bookmarks = call(g:NERDTreeBookmark.Bookmarks, [])
	let l:gitRootNTPath = call(g:NERDTreePath.New, [l:gitRoot])
	call g:NERDTreeBookmark.AddBookmark(l:rootDirname, l:gitRootNTPath)

	let l:origin = VimRCGit(l:gitRoot, 'remote get-url origin')
	if l:origin == 'git@git-eng.bmd.network:Software/Projects/Cameras.git'
		let l:configDir = call(g:NERDTreePath.New, [l:gitRoot . '/Config'])
		let l:mainDir   = call(g:NERDTreePath.New, [l:gitRoot . '/Cameras/Embedded2/Camera'])
		let l:commonDir = call(g:NERDTreePath.New, [l:gitRoot . '/Cameras/Embedded2/Common'])

		call g:NERDTreeBookmark.AddBookmark('-Config', l:configDir)
		call g:NERDTreeBookmark.AddBookmark('-Common', l:commonDir)
		call g:NERDTreeBookmark.AddBookmark('-Camera', l:mainDir)
	endif
endfunction!

" this version should not nuke bookmarks!
function! NERDTreeCameraDir2()
	if ! exists('g:NERDTreeBookmark')
		return
	endif

	"echomsg "]===========================================================["
	let l:ntRoot = NERDTreeGetTreeRoot()
	let l:gitRoot = VimRCGit(l:ntRoot, 'rev-parse --show-toplevel')
	let t:TabBookmarks = t:->get('TabBookmarks', [])

	" clear: when tab changes
	let l:clear = ! exists('t:GitRoot') || l:gitRoot == v:null || g:->get('LastGitRoot', '') != t:GitRoot
	" regen: when this tabs git root changes
	let l:regen = ! exists('t:GitRoot') || t:GitRoot != l:gitRoot
	" add: when cleared
	let l:add = l:clear || l:regen

	let t:GitRoot = l:gitRoot
	let g:LastGitRoot = t:GitRoot

	if l:clear
		"echomsg "clear..."
		" remove all bookmarks from other tabs...
		if exists('g:LastTabBookmarks')
			"echomsg 'removing previous tabs bookmarks'
			for i in g:LastTabBookmarks
				call i.delete()
			endfor
		else
			let g:LastTabBookmarks = []
		endif
	endif

	if l:regen
		"echomsg "regen..."
		" remove all bookmarks in this tab
		let t:TabBookmarks = []

		" TODO: make it read origin and relative directory bookmarks from a dictionary
		if l:gitRoot != v:null
			" add git root
			let l:rootDirname = trim(system('basename ' . l:gitRoot)) " TODO: do this inside vimscript for portability
			let l:bookmarks = call(g:NERDTreeBookmark.Bookmarks, [])
			let l:gitRootNTPath = call(g:NERDTreePath.New, [l:gitRoot])
			let l:spacingLength = (28 - len(l:rootDirname)) / 2
			let l:headerName = '=' . repeat('=', l:spacingLength) . l:rootDirname . repeat('=', l:spacingLength)
			call add(t:TabBookmarks, call(g:NERDTreeBookmark.New, [l:headerName, l:gitRootNTPath]))

			" check origin if it matches this
			let l:origin = VimRCGit(l:gitRoot, 'remote get-url origin')
			if l:origin == 'git@git-eng.bmd.network:Software/Projects/Cameras.git'

		" must use weird call syntax for scriptlocal methods...
				"echomsg "generating bookmarks for this tab..."
				let l:configDir = call(g:NERDTreePath.New, [l:gitRoot . '/Config'])
				let l:mainDir   = call(g:NERDTreePath.New, [l:gitRoot . '/Cameras/Embedded2/Camera'])
				let l:commonDir = call(g:NERDTreePath.New, [l:gitRoot . '/Cameras/Embedded2/Common'])

				call add(t:TabBookmarks, call(g:NERDTreeBookmark.New, ['▸Config', l:configDir]))
				call add(t:TabBookmarks, call(g:NERDTreeBookmark.New, ['▸Camera', l:mainDir]))
				call add(t:TabBookmarks, call(g:NERDTreeBookmark.New, ['▸Common', l:commonDir]))
			endif

		endif
	endif

	if l:add
		"echomsg "add..."
		let l:NerdTreeBookmarks = call(g:NERDTreeBookmark.Bookmarks, [])
		for i in t:TabBookmarks
			"echomsg i.name
			call add(l:NerdTreeBookmarks, i)
		endfor
		let g:LastTabBookmarks = t:TabBookmarks
	endif
endfunction!

augroup vimrc
	" autocmd tabenter * tcd `=NERDTreeGetTreeRoot()` | echo NERDTreeGetTreeRoot()
	" make sure call NERDTreeCameraDir() happens after tcd!
	autocmd tabenter * tcd `=NERDTreeGetTreeRoot()` | echo NERDTreeGetTreeRoot() | call NERDTreeCameraDir2()
	autocmd dirchanged,vimenter * call NERDTreeCameraDir2()
augroup END

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('c',      'blue',    'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('cpp',    'blue',    'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('objc',   'cyan',    'none', 'cyan',    '#151515')
call NERDTreeHighlightFile('objcpp', 'cyan',    'none', 'cyan',    '#151515')

call NERDTreeHighlightFile('vim',    'Magenta', 'none', '#ff00ff', '#151515')

call NERDTreeHighlightFile('ini',    'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('yml',    'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('config', 'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('conf',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('json',   'yellow',  'none', 'yellow',  '#151515')

call NERDTreeHighlightFile('html',   'green',   'none', 'green',   '#151515')
call NERDTreeHighlightFile('styl',   'green',   'none', 'green',   '#151515')
call NERDTreeHighlightFile('js',     'green',   'none', 'green',   '#151515')

augroup vimrc
	" Needs to be done after NERDTree loads.. hence autocmd
	autocmd VimEnter * call NERDTreeAddKeyMap({
				\ 'key': 'yy',
				\ 'callback': 'NERDTreeYankCurrentNode',
				\ 'quickhelpText': 'put full path of current node into the default register' })

	autocmd VimEnter * call NERDTreeAddKeyMap({
				\ 'key': 'gt',
				\ 'callback': 'NERDTreeSetTabLabel',
				\ 'quickhelpText': 'let t:TabLabel = dir/file name' })
augroup END

function! NERDTreeYankCurrentNode()
	let n = g:NERDTreeFileNode.GetSelected()
	if n != {}
		call setreg('"', n.path.str())
	endif
endfunction

function! NERDTreeSetTabLabel()
	let n = g:NERDTreeFileNode.GetSelected()
	if n != {}
		let t:TabLabel=fnamemodify(n.path.str(), ':t')
	endif
endfunction



function! DeleteInactiveBufs()
	"From tabpagebuflist() help, get a list of all buffers in all tabs
	let tablist = []
	for i in range(tabpagenr('$'))
		call extend(tablist, tabpagebuflist(i + 1))
	endfor

	"Below originally inspired by Hara Krishna Dara and Keith Roberts
	"http://tech.groups.yahoo.com/group/vim/message/56425
	let nWipeouts = 0
	for i in range(1, bufnr('$'))
		if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
			"bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
			silent exec 'bwipeout' i
			let nWipeouts = nWipeouts + 1
		endif
	endfor
	echomsg nWipeouts . ' buffer(s) wiped out'
endfunction


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

" make quickfix use the previous window selected before quickfix window was selected.
set switchbuf=uselast



" Text management

" 2 spaces please
"set expandtab "cancer - replaces tabs with spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4
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
" CTRL-A & CTRL-X formats, recognise 0x (hex), 0b (binary), alpha (alphabetical), but not octal " (0...)
set nrformats=alpha,hex,bin

" Auto-format
set formatoptions+=l
set formatoptions-=t
" Auto-format comments
"set formatoptions+=caroqnwj
"set formatoptions+=aroqnwj




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
set statusline=%f\ %#comment#%m%*\ %{FugitiveStatusline()}\ %=Line\ %l/%L\ Col\ %c\ (%p%%)
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
augroup vimrc
	"autocmd FileType gitcommit set textwidth=72
augroup END
" Colour the column just after our line limit so that we don't type over it
"set colorcolumn=+81
" In Git commit messages, also colour the 51st column (for titles)
augroup vimrc
	"autocmd FileType gitcommit set colorcolumn+=51
augroup END
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


augroup vimrc
	autocmd FileType cpp nmap <buffer> <leader>L :s/\s*\(\[.*\]\)\s*\n\?\s*{\s*\(.*;\)\s*}/\r\1\r{\r\2\r}<CR> =3k
augroup END


" start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <plug>(EasyAlign)
" start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <plug>(EasyAlign)

nnoremap <ScrollWheelRight> zl
nnoremap <ScrollWheelLeft> zh


" open/close NERDTree
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>gn :NERDTreeToggleVCS<CR>
nmap <leader>gN :NERDTreeToggleVCS<CR><C-w>p:NERDTreeFind<CR>
nmap <leader>N :NERDTreeFind<CR>


" find first error:
nnoremap <leader>e 010k?angele@/e\n\?r\n\?r\n\?o\n\?r\n\?:\n\?
" just use ^[ instead of esc
" jj to throw you into normal mode from insert mode
"inoremap jj <esc>
" jk to throw you into normal mode from insert mode
"inoremap jk <esc>
" Disable arrow keys (hardcore)
"map  <up>    <nop>
"imap <up>    <nop>
"map  <down>  <nop>
"imap <down>  <nop>
"map  <left>  <nop>
"imap <left>  <nop>
"map  <right> <nop>
"imap <right> <nop>
"nnoremap <Left> :echoe "Use h"<CR>
"nnoremap <Right> :echoe "Use l"<CR>
"nnoremap <Up> :echoe "Use k"<CR>
"nnoremap <Down> :echoe "Use j"<CR>
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
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l
" `gb` switches to next buffer, like `gt` does with tabs
nnoremap gb :bn<Cr>
" `gB` switches to previous buffer, like `gT` does with tabs
nnoremap gB :bp<Cr>
" `gf` opens file under cursor in a new vertical split
" nnoremap gf :vertical wincmd f<CR>
" `gF` opens file under cursor in a new split
nnoremap gF <C-w>f
" Toggle `hlsearch` with <Space>/
nnoremap g/ :set hlsearch!<CR>
" Toggle `spell` with <Space>?
nnoremap g? :set spell!<CR>
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



"current favorite colorscheme
" colorscheme javipolo
colorscheme habamax

" Unexpandtab - save spaces but show tabs
function! Unexpandtab()
	let modified = getbufinfo()[0].changed
	set noet|retab!
	augroup unexpand
	autocmd!
	autocmd BufWrite <buffer> set et|retab!
	autocmd BufWritePost <buffer> set noet|retab!
	augroup END
	if ! modified
		:write
	endif
endfunction
" actually not mapping this, its too easy to type
" nnoremap <leader>gu :call Unexpandtab()<CR>







" shortcuts for next/prev quickfix
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprevious<CR>
" and location..
nnoremap <leader>ln :lnext<CR>
nnoremap <leader>lp :lprevious<CR>
augroup QuickFix
	autocmd!
	" n/N/p go forwards and back in quickfix window
	autocmd FileType qf nnoremap <buffer> n :cnext<CR>zz<C-W><C-P>
	autocmd FileType qf nnoremap <buffer> N :cprev<CR>zz<C-W><C-P>
	autocmd FileType qf nnoremap <buffer> p :cprev<CR>zz<C-W><C-P>

	" and the same for a location window.. (also uses FileType qf)
	autocmd FileType qf nnoremap <buffer> n :lnext<CR>zz<C-W><C-P>
	autocmd FileType qf nnoremap <buffer> N :hprev<CR>zz<C-W><C-P>
	autocmd FileType qf nnoremap <buffer> p :lprev<CR>zz<C-W><C-P>
augroup END









"" load local vimrc files... should be at the end
"set secure
"let s:this_file = expand("<sfile>")
augroup vimrc
	""autocmd BufEnter    ?* call LoadLocalVimrc(expand("<afile>"))
	""autocmd BufWinEnter ?* call LoadLocalVimrc(expand("<afile>"))
	""autocmd WinEnter    ?* call LoadLocalVimrc(expand("<afile>"))
	"autocmd BufRead     ?* call LoadLocalVimrc(expand("<afile>"))
	""autocmd BufNew      ?* call LoadLocalVimrc(expand("<afile>"))
augroup END
"
"function! LoadLocalVimrc(filename)
"	let l:filepath = fnamemodify(a:filename, ':h')
"	let l:file = findfile("local.vimrc", l:filepath . ";/")
"	if l:file != ''
"		execute "source" l:file
"		execute "nnoremap <F8> :$tabe " . s:this_file . "<CR>:sp " . l:file . "<CR>"
"	endif
"endfunction


" leader for plugins: backslash
let mapleader = "\\"
