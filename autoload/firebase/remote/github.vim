func firebase#remote#github#issues()
	let r = get(json_decode(system(printf("curl -q --silent -H 'Accept: application/json' -H 'Content-Type: application/json' 'https://api.github.com/search/issues?per_page=100&q=repo:%s+state:open+is:issue'", firebase#remote#reponame()))), "items", [])
	return r->map({_, v -> #{word: v.number, abbr: '#' . v.number, menu: v.title, info: substitute(v.body, '\r', '', 'g')}})
endfunc
