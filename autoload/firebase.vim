func firebase#init()
	let g:firebase_options = extend(firebase#default_options(), get(g:, 'firebase_options', {}))

	if g:firebase_options.default_mappings
		au Filetype gitrebase nnoremap <silent> <LocalLeader>n :call firebase#rebase#newbranch_n()<CR>| xnoremap <silent> <LocalLeader>n :<C-U>call firebase#rebase#newbranch_v()<CR>
		au Filetype gitrebase nnoremap <silent> <LocalLeader>m :call firebase#rebase#movecommit()<CR>| xnoremap <silent> <LocalLeader>m :<C-U>call firebase#rebase#movecommits()<CR>
		au Filetype gitrebase nnoremap <silent> <LocalLeader>p :call firebase#rebase#push_current()<CR>

		" yank permalink to clipboard
		nnoremap <silent> <Leader>yg :call firebase#remote#copylink()<CR>
		nnoremap <silent> <LocalLeader>yg :call firebase#remote#copylink_cursor(0)<CR>
		xnoremap <silent> <LocalLeader>yg :<C-U>call firebase#remote#copylink_cursor(1)<CR>
	endif

	if g:firebase_options.autocursor
		au Filetype gitrebase call firebase#rebase#autocursor()
	endif

	au Filetype gitcommit setlocal omnifunc=firebase#commit#complete_issue
endfunc

func firebase#default_options()
	return #{
		\ autocursor: 1,
		\ autopush: 0,
		\ branch_format: "%s",
		\ default_mappings: 1,
		\ pushref_formats: [],
	\ }
endfunc
