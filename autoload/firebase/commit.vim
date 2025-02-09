func firebase#commit#complete_issue(findstart, base)
	if a:findstart
		let p = searchpos('\D', 'bnW', line('.'))[1]
		return p > 0 && getline('.')[p - 1] ==# '#' ? p : -3
	endif
	return firebase#remote#api#issues(a:base)
endfunc

func firebase#commit#head()
	return trim(system("git rev-parse HEAD"))
endfunc
