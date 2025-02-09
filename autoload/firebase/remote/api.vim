func firebase#remote#api#issues(prefix)
	let r = firebase#remote#github#issues()->filter({_, v -> stridx(v.word, a:prefix) == 0})
	if empty(r)
		echo "No matching issues"
	endif
	return r
endfunc
