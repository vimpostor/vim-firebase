func firebase#jump#jump(s)
	let args = len(a:s) ? a:s : "diff HEAD HEAD~1"
	cexpr system('/usr/share/git/git-jump/git-jump --stdout ' . args)
endfunc

func firebase#jump#compl(a, l, p)
	return ["diff", "merge", "grep", "ws", "HEAD"]->filter({_, v -> !stridx(v, a:a)})
endfunc
