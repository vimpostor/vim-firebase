func firebase#init()
	let g:firebase_options = extend(firebase#default_options(), get(g:, 'firebase_options', {}))

	if g:firebase_options.default_mappings
		au Filetype gitrebase nnoremap <silent> <LocalLeader>n :call firebase#rebase#newbranch_n()<CR>| xnoremap <silent> <LocalLeader>n :<C-U>call firebase#rebase#newbranch_v()<CR>
		au Filetype gitrebase nnoremap <silent> <LocalLeader>m :call firebase#rebase#movecommit()<CR>| xnoremap <silent> <LocalLeader>m :<C-U>call firebase#rebase#movecommits()<CR>
	endif
endfunc

func firebase#default_options()
	return #{
		\ default_mappings: 1,
		\ autopush: 0,
	\ }
endfunc
