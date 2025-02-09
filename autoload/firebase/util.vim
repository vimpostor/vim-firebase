func firebase#util#choose(arr, callback)
	if len(a:arr) == 1
		" no need to choose
		call function(a:callback)(-1, 1)
		return
	endif

	if has('nvim')
		let buf = nvim_create_buf(0, 1)
		call nvim_buf_set_lines(buf, 0, -1, 1, a:arr)
		let win = nvim_open_win(buf, 1, #{relative: "cursor", bufpos: getpos('.')[1:2], width: len(a:arr[0]), height: len(a:arr), style: "minimal"})
		call nvim_buf_set_keymap(buf, "n", "<CR>", ':let a = line(".")<CR>:close<CR>:call ' . a:callback . '(-1, a)<CR>', #{})
	else
		call popup_menu(a:arr, #{callback: a:callback})
	endif
endfunc
