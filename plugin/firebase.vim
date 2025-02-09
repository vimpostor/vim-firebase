if exists('g:loaded_firebase')
	finish
endif
let g:loaded_firebase = 1

call firebase#init()
