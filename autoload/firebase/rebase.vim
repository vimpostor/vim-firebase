let s:branchlist = []
let s:x = 0
let s:y = 0

func firebase#rebase#newbranch_internal(v)
	let b = input('Branch name: ')
	let x = line(".'<"[a:v:2*a:v])
	let y = line(".'>"[a:v:2*a:v])
	let c = getline(x, y)
	call deletebufline('%', x, y)
	call append(x - 1, printf("merge %1$s # Merge branch '%1$s'", b))
	keepjumps norm! {
	call append(line('.') - 1, printf("\n# Branch %1$s\nreset onto\n%2$s\nupdate-ref refs/heads/%1$s\nlabel %1$s", b, c->join("\n"))->split("\n", 1))
	call cursor(x + len(c) + 6, 1)
endfunc

func firebase#rebase#newbranch_n()
	call firebase#rebase#newbranch_internal(0)
endfunc

func firebase#rebase#newbranch_v()
	call firebase#rebase#newbranch_internal(1)
endfunc

func firebase#rebase#branchlist()
	return getline(1, '$')->filter('v:val =~# "^u\\(pdate-ref\\)\\? refs/heads/"')->map({_, v -> matchlist(v, 'refs/heads/\(.*\)')[1]})
endfunc

func firebase#rebase#domove(w, i)
	let b = s:branchlist[a:i - 1]
	let c = getline(s:x, s:y)
	call deletebufline('%', s:x, s:y)
	let l = getline(1, '$')->indexof({_, v -> 1 + match(v, printf("u\\(pdate-ref\\)\\? refs/heads/%s", b))})
	call append(l, c)
endfunc

func firebase#rebase#move_internal(v)
	let s:x = line(".'<"[a:v:2*a:v])
	let s:y = line(".'>"[a:v:2*a:v])
	let s:branchlist = firebase#rebase#branchlist()
	call firebase#util#choose(s:branchlist, 'firebase#rebase#domove')
endfunc

func firebase#rebase#movecommit()
	call firebase#rebase#move_internal(0)
endfunc

func firebase#rebase#movecommits()
	call firebase#rebase#move_internal(1)
endfunc
