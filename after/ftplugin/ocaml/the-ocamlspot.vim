if exists('g:loaded_the_ocamlspot')
  finish
endif
let g:loaded_the_ocamlspot = 1

let s:save_cpo = &cpo
set cpo&vim

if !executable('ocamlspot')
  echoerr 'OCamlSpotter is not installed!'
  finish
endif

command! -buffer -nargs=0 TheOCamlType call the_ocamlspot#main('type')
command! -buffer -nargs=0 TheOCamlDefPreview call the_ocamlspot#main('preview')

nnoremap <SID>(the-ocamlspot-type) :<C-u>call the_ocamlspot#main('type')<CR>
nnoremap <SID>(the-ocamlspot-def-preview) :<C-u>call the_ocamlspot#main('preview')<CR>

nnoremap <script> <Plug>(the-ocamlspot-type) <SID>(the-ocamlspot-type)
nnoremap <script> <Plug>(the-ocamlspot-def-preview) <SID>(the-ocamlspot-def-preview)

augroup the-ocamlspot
  autocmd!
  if !get(g:, 'the_ocamlspot_no_default_auto_commands', 0)
    autocmd CursorHold <buffer> TheOCamlType
  endif
augroup END

if !get(g:, 'the_ocamlspot_no_default_key_mappings', 0)
  nmap <buffer> <Leader>ot <Plug>(the-ocamlspot-type)
  nmap <buffer> <Leader>op <Plug>(the-ocamlspot-def-preview)
endif

if has('gui_running') && has('balloon_eval')
  if !get(g:, 'the_ocamlspot_no_balloon', 0)
    setlocal ballooneval balloonexpr=the_ocamlspot#balloon_spotter()
  endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
