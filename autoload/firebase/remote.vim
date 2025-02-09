func firebase#remote#url()
	return trim(system('git config remote.origin.url'))
endfunc

func firebase#remote#trimgit(s)
	if stridx(a:s, ".git", len(a:s) - 4) < 0
		return a:s
	endif
	return strcharpart(a:s, 0, len(a:s) - 4)
endfunc

func firebase#remote#weburl()
	let u = firebase#remote#url()

	if stridx(u, "http") != 0
		" replace only the first column
		let u = substitute(u, ":", "/", "")

		if stridx(u, ":") >= 0 || stridx(u, "git@") != 0
			" special URL with multiple columns or not starting with git@, better error out as caution
			echoe "Unsupported remote URL"
			return ""
		endif

		" git@ to https://
		let u = "https://" . strcharpart(u, 4)
	endif

	return firebase#remote#trimgit(u)
endfunc

func firebase#remote#reponame()
	let u = firebase#remote#weburl()
	return strcharpart(u, stridx(u, "/", 8) + 1)
endfunc

func firebase#remote#permalink()
	return printf("%s/blob/%s/%s", firebase#remote#weburl(), firebase#commit#head(), firebase#util#repopath(expand('%')))
endfunc

func firebase#remote#permalink_cursor(v)
	let x = line(".'<"[a:v:2*a:v])
	let y = line(".'>"[a:v:2*a:v])
	let r = firebase#remote#permalink() . printf("#L%d", x)
	if a:v
		let r = r . printf("-%d", y)
	endif
	return r
endfunc

func firebase#remote#copylink()
	call firebase#util#copy_clipboard(firebase#remote#permalink())
endfunc

func firebase#remote#copylink_cursor(v)
	call firebase#util#copy_clipboard(firebase#remote#permalink_cursor(a:v))
endfunc
