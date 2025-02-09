func firebase#rebase#newbranch_internal(v)
	let b = input('Branch name: ')
	let x = line(".'<"[a:v:2*a:v])
	let y = line(".'>"[a:v:2*a:v])
	let c = getbufline(bufnr('%'), x, y)
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
