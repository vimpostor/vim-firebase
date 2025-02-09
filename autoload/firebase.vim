func firebase#init()
	let g:firebase_options = extend(firebase#default_options(), get(g:, 'firebase_options', {}))

	if g:firebase_options.default_mappings
		au Filetype gitrebase nnoremap <silent> <LocalLeader>n :call firebase#rebase#newbranch_n()<CR>| xnoremap <silent> <LocalLeader>n :<C-U>call firebase#rebase#newbranch_v()<CR>
	endif
endfunc

func firebase#default_options()
	return #{
		\ default_mappings: 1,
	\ }
endfunc
