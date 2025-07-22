func firebase#remote#url()
	let r = trim(system('git config remote.origin.url'))
	if empty(r)
		let r = trim(system('fossil remote'))
	endif
	return r
endfunc

func firebase#remote#trimgit(s)
	if stridx(a:s, ".git", len(a:s) - 4) < 0
		return a:s
	endif
	return strcharpart(a:s, 0, len(a:s) - 4)
endfunc

func firebase#remote#weburl()
	let u = firebase#remote#url()

	if stridx(u, "git://") == 0
		let u = "https://" . strcharpart(u, 6)
	elseif stridx(u, "http") != 0
		" assume git@host:namespace/repo.git style URL
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

func firebase#remote#pushref_format()
	let u = firebase#remote#url()
	for i in g:firebase_options.pushref_formats
		if u =~# i.remote
			return i.push
		endif
	endfor
	return "refs/heads/%s"
endfunc

func firebase#remote#permalink_format(linestart, lineend)
	let format = "%1$s/%2$s/%3$s/%4$s"
	let weburl = firebase#remote#weburl()
	let blob = "blob"
	let ref = firebase#commit#head()
	let path = firebase#util#repopath(expand('%'))
	let supportsrange = 1
	let linemark = "#L"
	let repeatlinemark = "-L"

	if !stridx(weburl, "https://codeberg.org")
		let blob = "src/commit"
	elseif !stridx(weburl, "https://code.qt.io")
		let format = "%1$s/%2$s/%4$s?id=%3$s"
		let weburl = "https://code.qt.io/cgit" . strcharpart(weburl, 18) . ".git"
		let blob = "tree"
		let supportsrange = 0
		let linemark = "#n"
	elseif !stridx(weburl, "https://chiselapp.com")
		let format = "%1$s/%2$s?name=%4$s&ci=%3$s"
		let blob = "file"
		let ref = json_decode(system("fossil json status")).payload.checkout.uuid
		let path = expand('%')
		let linemark = "&ln="
		let repeatlinemark = "-"
	endif

	let res = printf(format, weburl, blob, ref, path)
	if len(a:linestart)
		let res .= linemark . a:linestart
		if supportsrange && len(a:lineend)
			let res .= repeatlinemark . a:lineend
		endif
	endif
	return res
endfunc

func firebase#remote#permalink()
	return firebase#remote#permalink_format("", "")
endfunc

func firebase#remote#permalink_cursor(v)
	let x = line(".'<"[a:v:2*a:v])
	let y = line(".'>"[a:v:2*a:v])
	return firebase#remote#permalink_format(x, a:v ? y : "")
endfunc

func firebase#remote#copylink()
	call firebase#util#copy_clipboard(firebase#remote#permalink())
endfunc

func firebase#remote#copylink_cursor(v)
	call firebase#util#copy_clipboard(firebase#remote#permalink_cursor(a:v))
endfunc
