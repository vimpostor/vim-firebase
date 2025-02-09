let s:branchlist = []
let s:x = 0
let s:y = 0

func firebase#rebase#newbranch_internal(v)
	let b = input('Branch name: ')
	if empty(b)
		return
	endif
	let b = printf(g:firebase_options.branch_format, b)

	let x = line(".'<"[a:v:2*a:v])
	let y = line(".'>"[a:v:2*a:v])
	let c = getline(x, y)
	call deletebufline('%', x, y)
	call append(x - 1, printf("merge %1$s # Merge branch '%1$s'", b))
	keepjumps norm! {
	call append(line('.') - 1, printf("\n# Branch %1$s\nreset onto\n%2$s\nupdate-ref refs/heads/%1$s\nlabel %1$s", b, c->join("\n"))->split("\n", 1))
	call cursor(x + len(c) + 6, 1)

	if g:firebase_options.autopush
		call firebase#rebase#push(b)
	endif
endfunc

func firebase#rebase#newbranch_n()
	call firebase#rebase#newbranch_internal(0)
endfunc

func firebase#rebase#newbranch_v()
	call firebase#rebase#newbranch_internal(1)
endfunc

func firebase#rebase#matchbranches(l)
	return filter(a:l, 'v:val =~# "^u\\(pdate-ref\\)\\? refs/heads/"')->map({_, v -> matchlist(v, 'refs/heads/\(.*\)')[1]})
endfunc

func firebase#rebase#branchlist()
	return firebase#rebase#matchbranches(getline(1, '$'))
endfunc

func firebase#rebase#branchline(b)
	return 1 + getline(1, '$')->indexof({_, v -> 1 + match(v, printf("u\\(pdate-ref\\)\\? refs/heads/%s", a:b))})
endfunc

func firebase#rebase#labelline(b)
	return 1 + getline(1, '$')->indexof({_, v -> 1 + match(v, printf("^l\\(abel\\)\\? %s$", a:b))})
endfunc

func firebase#rebase#domove(w, i)
	if a:i < 1
		return
	endif

	let b = s:branchlist[a:i - 1]
	let c = getline(s:x, s:y)
	call deletebufline('%', s:x, s:y)
	let l = firebase#rebase#branchline(b)
	call append(l - 1, c)

	if g:firebase_options.autopush
		call firebase#rebase#push(b)
	endif
endfunc

func firebase#rebase#move_internal(v)
	let s:x = line(".'<"[a:v:2*a:v])
	let s:y = line(".'>"[a:v:2*a:v])
	let s:branchlist = firebase#rebase#branchlist()
	call firebase#util#choose("Move to", s:branchlist, 'firebase#rebase#domove')
endfunc

func firebase#rebase#movecommit()
	call firebase#rebase#move_internal(0)
endfunc

func firebase#rebase#movecommits()
	call firebase#rebase#move_internal(1)
endfunc

func firebase#rebase#push(branch)
	let l = firebase#rebase#labelline(a:branch)
	if l && empty(getline(l + 1))
		call append(l, printf("exec git push origin %s", a:branch))
	endif
endfunc

func firebase#rebase#push_current()
	let b = firebase#rebase#matchbranches(getline('.', '$'))->get(0, '')
	call firebase#rebase#push(b)
endfunc

func firebase#rebase#autocursor()
	" it's quite the bad heuristic, but we try to find the last reset onto
	let l = getline(1, '$')->reverse()->indexof('v:val =~# "^\\(rese\\)\\?t onto$"')
	if l >= 0
		call cursor(line('$') - l + 1, 1)
	endif
endfunc
