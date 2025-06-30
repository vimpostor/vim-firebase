func firebase#jump#jump(s)
	cexpr system('/usr/share/git/git-jump/git-jump --stdout ' . a:s)
endfunc

func firebase#jump#compl(a, l, p)
	return ["diff", "merge", "grep", "ws", "HEAD"]->filter({_, v -> !stridx(v, a:a)})
endfunc
