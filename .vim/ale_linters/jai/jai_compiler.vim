
let s:header = '\v^((\w+:)?/[a-zA-Z /\\]*\.jai):(\d+),(\d+):( (Error|Warning):)? (.*)'
let s:file_line = '\v\(((\w+:)?/[a-zA-Z /\\]*\.jai):(\d+)\)'
let s:callsite_args = "\\vThe call site's argument types are: (.*)"
let s:ignore = '\v^((\w+:)?/[a-zA-Z /\\]*\.jai):\d+,\d+: Info: ... in argument'

function! ale_linters#jai#jai_compiler#Handle(buffer, lines) abort
	let l:output = []
	let l:last_error = -1
	let l:last_note = -1
	let l:last_error_is_overload = 0
	let l:overload_callsite_args = ""
	let l:last_note_is_overload = 0

    for l:line in a:lines
		" echom "line: '" . l:line . "'"

		let l:ignore_this_header = match(l:line, s:ignore) != -1
		if l:ignore_this_header
			echom "ignore: " . l:line
			let l:match = []
		else
			let l:match = matchlist(l:line, s:header)
		endif

		if !empty(l:match) && !l:ignore_this_header
			let l:filename = l:match[1]
			let l:error_type = l:match[6]
			let l:line_no = str2nr(l:match[3])
			let l:col_no = str2nr(l:match[4])
			let l:text = l:match[7]

			if l:error_type is# 'Error'
				let l:last_error = len(l:output)
				" echom "l:last_error " . l:last_error

				if l:text == "Procedure call did not match any of the possible overloads."
					let l:last_error_is_overload = 1
				else
					let l:last_error_is_overload = 0
				endif
			else
				if l:last_error != -1
					" echom "Append note to last error " . l:last_error
					let l:output[l:last_error].detail = l:output[l:last_error].detail . "\n" . l:line

					if l:output[l:last_error].lnum == l:line_no
						" echom "Skip this note as it shares a line with the previous error"

						if l:last_error_is_overload
							let l:match = matchlist(l:text, s:callsite_args)
							let l:overload_callsite_args = l:match[1]
						endif

						continue
					endif
				endif

				let l:last_note_is_overload = 0
				let l:last_note = len(l:output)
				" echom "l:last_note " . l:last_note
			endif

			call add(l:output, {
			\   'filename': l:filename,
			\   'type':     l:error_type,
			\   'lnum':     l:line_no,
			\   'col':      l:col_no,
			\   'text':     l:text,
			\   'detail':   l:text,
			\})
		else
			if l:last_error_is_overload

				if l:ignore_this_header
					let l:match = []
				else
					let l:match = matchlist(l:line, s:file_line)
				endif

				if !empty(l:match) && !l:ignore_this_header
					let l:filename = l:match[1]
					let l:line_no = str2nr(l:match[3])
					let l:text = "Mismatching arguments. calllsite: " . l:overload_callsite_args

					let l:last_note_is_overload = 1
					let l:last_note = len(l:output)
					echom "overload note: " . l:last_note
					call add(l:output, {
					\   'filename': l:filename,
					\   'type':     "Note",
					\   'lnum':     l:line_no,
					\   'text':     l:text,
					\   'detail':   l:text,
					\})
				elseif l:last_note_is_overload && !l:ignore_this_header
					let l:text = trim(l:line)
					if !empty(l:text) && stridx(l:text, "^^^") == -1
						let l:text = l:overload_callsite_args . " " . l:text
						let l:output[l:last_note].text = l:text
					endif
				endif
			endif

			if l:last_error > l:last_note
				" last error is valid, and we don't care about notes.
				" echom "append to last error only " . l:last_error
				let l:output[l:last_error].detail = l:output[l:last_error].detail . "\n" . l:line
			elseif l:last_note != -1
				" last note id valid and we care about it.
				" echom "append to last note " . l:last_note
				let l:output[l:last_note].detail = l:output[l:last_note].detail . "\n" . l:line

				if l:last_error != -1
					" last error is also valid, which means this note applies to the last error.
					" echom "also append to last error " . l:last_error
					let l:output[l:last_error].detail = l:output[l:last_error].detail . "\n" . l:line
				endif
			endif
		endif
	endfor

	return l:output
endfunction

function! ale_linters#jai#jai_compiler#GetDir(bufnr)
	let filepath = bufname(a:bufnr)
	let cwd = fnamemodify(l:filepath, ':p:h')
	let last_wd = cwd

	while 1
		if filereadable(cwd . '/first.jai')
			" echom "foudn first.jai at " . cwd
			return cwd
		endif

		let last_wd = cwd
		let cwd = fnamemodify(cwd, ":p:h:h")

		if last_wd == cwd
			break
		endif
	endwhile

	" echom "Could not find first.jai!"
	return fnamemodify(l:filepath, ':p:h')
endfunction

let s:no_output_code = '#import "Compiler"; #run set_build_options_dc(.{ do_output = false });'

call ale#linter#Define('jai', {
	\ 'name': 'jai_compiler',
	\ 'executable': "jai",
	\ 'command': "%e first.jai -add \'" . s:no_output_code . "\'",
	\ 'cwd': function("ale_linters#jai#jai_compiler#GetDir"),
	\ 'lint_file': 1,
	\ 'output_stream': 'stderr',
	\ 'callback': 'ale_linters#jai#jai_compiler#Handle',
	\})
