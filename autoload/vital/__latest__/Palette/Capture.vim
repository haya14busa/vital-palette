scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:verbosefiles = []

function! s:_verbosefile_push(file)
	call add(s:verbosefiles, &verbosefile)
	let &verbosefile = a:file
	return a:file
endfunction


function! s:_verbosefile_pop()
	let filename = &verbosefile
	let &verbosefile = get(s:verbosefiles, -1)
	call remove(s:verbosefiles, -1)
	return filename
endfunction


function! s:_reset()
	let s:verbosefiles = []
endfunction

function! s:command(cmd, ...)
	let s:_dict = get(a:, 1, {})
	for s:_key in keys(s:_dict)
		let {s:key} = s:_dict[s:key]
	endfor
	call s:_verbosefile_push(tempname())
	redir =>result
	execute "silent" a:cmd
	redir END
	call s:_verbosefile_pop()
	return result
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
