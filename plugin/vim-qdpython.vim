" Title:      QDPython
" Description:  A Plugin to provide a quick, easy way to run Python code in Vim.
" Last Change:  9 Aug 2023
" Maintainer:   https://github.com/juansegaes

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_qdpython")
    finish
endif
let g:loaded_qdpython = 1

" Exposes the plugin's functions for use as commands in Vim.
"command! -nargs=0 DisplayTime call example-plugin#DisplayTime()
"command! -nargs=0 DefineWord call example-plugin#DefineWord()
"command! -nargs=0 AspellCheck call example-plugin#AspellCheck()

let g:python_buffer_id = -1
let g:new_buffer_created = 0

"Change the current buffer to specific buffer by id
function! ChangeBufferById(target_buffer_id)
		for i in range(1, winnr('$'))
				let bufnr = winbufnr(i)
				if bufnr ==# a:target_buffer_id
						execute i . 'wincmd w'
						return
				endif
		endfor
endfunction

function! Execute_code_python()
	if bufwinid(g:python_buffer_id) == -1
		if g:python_buffer_id >= 0
			"close buffer python_buffer_id
			execute 'bdelete! ' . g:python_buffer_id
		endif
		let current_file = expand('%:p')  " Get the full path of the current file
    let cmd = 'vsplit | term python ' . shellescape(current_file, 1)
    execute cmd
		let g:python_buffer_id=bufnr('%')
	else
		let current_file = expand('%:p')  " Get the full path of the current file
		call ChangeBufferById(g:python_buffer_id)
    let cmd = 'term python ' . shellescape(current_file, 1)
    execute cmd
		if g:new_buffer_created
			execute 'bdelete! ' . g:python_buffer_id
		endif
		let g:new_buffer_created = 1
		let g:python_buffer_id=bufnr('%')
	endif
endfunction


    
"command! -nargs=0 QDPython call qdpython#Execute_code_python()
autocmd FileType python nnoremap <F2> :call Execute_code_python()<CR>

