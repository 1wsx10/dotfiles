
" TODO:
" put these on the status line to replace vim-airline
" fugitive plugin
" filename (full)
" filetype maybe?
" if the file has been edited without saving
"	https://github.com/inkarkat/vim-StatusLineHighlight/blob/master/plugin/StatusLineHighlight.vim
" also change active window to different background colour.. maybe make 
" non-active a lower contrast
"
" make a hotkey for y"% that would do :let "@ = @% 
" (but instead of just % you can type any buffer you want)


set nofixendofline

let g:mac=0
if has("unix")
	let s:uname = system("uname")
	if s:uname == "Darwin\n"
		let g:mac=1
	endif
endif

"Space as a Leader
let mapleader = "\<Space>"
" Use Vim features, not Vi
set nocompatible

set encoding=utf-8

"current favorite colorscheme
colorscheme javipolo


" make vitality fix the focus, but don't make it break my font
"let g:vitality_fix_cursor = 0
"let g:vitality_fix_focus = 1
"let g:vitality_always_assume_iterm = 0


" save a session if we are dying...
au VimLeave * if v:dying | mksession! | endif


" Surround
let g:surround_{char2nr("#if")} = "#if \1if token: \1\r#endif // \1\1"

" VEBUGGER - lldb integration within vim
let g:vebugger_leader='<Leader>d'
"TODO: set lldb path
let g:vebugger_path_python_lldb='/usr/bin/python'
let g:vebugger_path_python_2='/usr/bin/python'











" suckless - better window-manager keybinds
let g:suckless_tmap = 1 " allow keybinds within :term windows
let g:suckless_tabline = 1
let g:suckless_guitablabel = 1
let g:suckless_wrap_around_jk = 0  " wrap in current column (wmii-like)
let g:suckless_wrap_around_hl = 0  " wrap in current tab    (wmii-like)
"let g:MetaSendsEscape = 0  " use this if Alt-j outputs an 'ê' on your terminal Vim
"let g:MetaSendsEscape = 1  " use this if Alt shortcuts don't work on gVim / MacVim

" SaneOS - use meta (alt) key
let g:suckless_mappings = {
\        '<M-[sdf]>'      :   'SetTilingMode("[sdf]")'    ,
"\        '<M-[hjkl]>'     :    'SelectWindow("[hjkl]")'   , " using custom binding because i don't want to leave terminal in ^w-N mode when moving away
"\        '<M-[HJKL]>'     :      'MoveWindow("[hjkl]")'   , " using custom binding because it breaks with terminal windows
\      '<C-M-[hjkl]>'     :    'ResizeWindow("[hjkl]")'   ,
\        '<M-[oO]>'       :    'CreateWindow("[sv]")'     ,
"\        '<M-w>'          :     'CloseWindow()'           , " using custom binding because it breaks with terminal windows
\   '<Leader>[123456789]' :       'SelectTab([123456789])',
\  '<Leader>t[123456789]' : 'MoveWindowToTab([123456789])',
\  '<Leader>T[123456789]' : 'CopyWindowToTab([123456789])',
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

"map <M-H> <C-w>H
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
tmap <M-w> <C-w>q
map <M-q> <C-w>q
tmap <M-q> <C-w>:q!<CR>





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
set tabline=%!MyTabLine()












" Gundo - undo tree
" display the undo tree with <leader>u.
nnoremap <leader>u :GundoToggle<CR>
let g:gundo_prefer_python3 = 1
let g:gundo_width = 70
"let g:gundo_preview_height = 40
"let g:gundo_right = 1



" fzf.vim
nnoremap g/ :BLines<CR>



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
command Delview call MyDeleteView()
" Lower-case user commands: http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev delview <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Delview' : 'delview')<CR>









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
"set diffopt+=iwhite
set diffopt+="indent-heuristic",iwhite,closeoff,hiddenoff,vertical
let g:diff_translations = 0 " speedup

" VIM-ALE use compile_commands.json files for c/c++
let g:ale_c_parse_compile_commands = 1
" please use C++2a features
let g:ale_cpp_gcc_options = '-std=c++2a -Wall'
let g:ale_cpp_clang_options = '-std=c++2a -Wall'
" work options: TODO make it decide weather we are at work
let g:ale_objcpp_clangd_options = "-std=c++17 -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
let g:ale_objcpp_clang_options = "-std=c++17 -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
let g:ale_cpp_clangd_options = "-std=c++17 -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
let g:ale_cpp_clang_options = "-std=c++17 -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
let g:ale_cpp_gcc_options = "-std=c++17 -Wall -I/Users/angele/Cameras/Acquisition/VirtualDevice/FreeRTOS -I/Users/angele/Cameras/Cameras/Embedded2/Camera/CameraAPI/Services/"
let g:ale_c_parse_compile_commands = 1
"let g:ale_linters_explicit = 1
let g:ale_completion_enabled = 1
"let b:ale_linters = [
"\	'clangd', 'clang',
"\	'language_server', 'shell', 'shellcheck',
"\]
"let b:ale_linters = [ 'clangd', 'clang', 'language_server', 'shell', 'shellcheck' ]
"let b:ale_linters = ['ccls', 'clang', 'clangcheck', 'clangd', 'clangtidy', 'clazy', 'cppcheck', 'cpplint', 'cquery', 'flawfinder', 'gcc']
"let b:ale_linters = ['clang', 'gcc']
let b:ale_linters = ['language_server', 'shell', 'shellcheck']
autocmd FileType cpp :ALEDisable
autocmd FileType sh :ALEEnable
"let b:ale_linters = {
"\	'cpp': ['clangd', 'clang'],
"\	'sh': ['language_server', 'shell', 'shellcheck'],
"\}

" -- rtags config --
set completefunc=RtagsCompleteFunc
set omnifunc=RtagsCompleteFunc
let g:rtagsRcCmd='/usr/local/bin/rc'
" use quickfix window instead of location list
" let g:rtagsUseLocationList = 0
" let g:rtagsJumpStackMaxSize = 100

" -- end rtags configuration --


" python.vim sets tabstop to 8 like this, so i need to override it
autocmd FileType python setlocal nospell tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
"to add a filetype for unrecognised file
autocmd BufRead,BufNewFile *.bidl     :set filetype=c
autocmd BufRead,BufNewFile *.md       :set filetype=markdown
autocmd BufRead,BufNewFile .bashal    :set filetype=sh
autocmd BufRead,BufNewFile .bashfunc  :set filetype=sh
autocmd BufRead,BufNewFile SConscript :set filetype=python
autocmd BufRead,BufNewFile SConstruct :set filetype=python
autocmd BufRead,BufNewFile *.py       :set filetype=python

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
let g:pyindent_open_paren = 'shiftwidth()'

autocmd FileType cmake :RainbowToggleOff

"to add a filetype for unrecognised file
autocmd BufRead,BufNewFile *.bidl     :set filetype=c
autocmd BufRead,BufNewFile *.md       :set filetype=markdown
autocmd BufRead,BufNewFile .bashal    :set filetype=sh
autocmd BufRead,BufNewFile .bashfunc  :set filetype=sh
autocmd BufRead,BufNewFile SConscript :set filetype=python
autocmd BufRead,BufNewFile SConstruct :set filetype=python

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
"autocmd vimenter * NERDTree
"" ...but focus on the file itself, rather than NERDTree
"autocmd VimEnter * wincmd p
" Close Vim if only NERDTree is left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" If the setting is set to 2 then it behaves the same as if set to 1 except 
" that the CWD is changed whenever the tree root is changed. For example, if 
" the CWD is /home/marty/foobar and you make the node for 
" /home/marty/foobar/baz the new root then the CWD will become 
" /home/marty/foobar/baz.
let g:NERDTreeChDirMode = 2

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

" Needs to be done after NERDTree loads.. hence autocmd
autocmd VimEnter * call NERDTreeAddKeyMap({
			\ 'key': 'yy',
			\ 'callback': 'NERDTreeYankCurrentNode',
			\ 'quickhelpText': 'put full path of current node into the default register' })

function! NERDTreeYankCurrentNode()
	let n = g:NERDTreeFileNode.GetSelected()
	if n != {}
		call setreg('"', n.path.str())
	endif
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



" Text management

filetype plugin indent on
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
" Interpret numbers with leading zeroes as decimal, not octal
set nrformats=
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
"autocmd FileType gitcommit set textwidth=72
" Colour the column just after our line limit so that we don't type over it
"set colorcolumn=+81
" In Git commit messages, also colour the 51st column (for titles)
"autocmd FileType gitcommit set colorcolumn+=51
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


" start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <plug>(EasyAlign)
" start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <plug>(EasyAlign)

nnoremap <ScrollWheelRight> zl
nnoremap <ScrollWheelLeft> zh


" open/close NERDTree
nmap <leader>n :NERDTreeToggle<CR>
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
nnoremap <leader>/ :set hlsearch!<CR>
" Toggle `spell` with <Space>?
nnoremap <leader>? :set spell!<CR>
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


"" load local vimrc files... should be at the end
"set secure
"let s:this_file = expand("<sfile>")
""autocmd BufEnter    ?* call LoadLocalVimrc(expand("<afile>"))
""autocmd BufWinEnter ?* call LoadLocalVimrc(expand("<afile>"))
""autocmd WinEnter    ?* call LoadLocalVimrc(expand("<afile>"))
"autocmd BufRead     ?* call LoadLocalVimrc(expand("<afile>"))
""autocmd BufNew      ?* call LoadLocalVimrc(expand("<afile>"))
"
"function! LoadLocalVimrc(filename)
"	let l:filepath = fnamemodify(a:filename, ':h')
"	let l:file = findfile("local.vimrc", l:filepath . ";/")
"	if l:file != ''
"		execute "source" l:file
"		execute "nnoremap <F8> :$tabe " . s:this_file . "<CR>:sp " . l:file . "<CR>"
"	endif
"endfunction
