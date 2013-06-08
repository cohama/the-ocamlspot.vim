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

if !exists('g:the_ocamlspot_no_default_auto_commands')
  let g:the_ocamlspot_no_default_auto_commands = 0
endif
if !exists('g:the_ocamlspot_no_default_key_mappings')
  let g:the_ocamlspot_no_default_key_mappings = 0
endif
if !exists('g:the_ocamlspot_no_balloon')
  let g:the_ocamlspot_no_balloon = 0
endif

command! -buffer -nargs=0 TheOCamlType call the_ocamlspot#main('type')
command! -buffer -nargs=0 TheOCamlDefPreview call the_ocamlspot#main('preview')

nnoremap <SID>(the-ocamlspot-type) :<C-u>call the_ocamlspot#main('type')<CR>
nnoremap <SID>(the-ocamlspot-def-preview) :<C-u>call the_ocamlspot#main('preview')<CR>

nnoremap <script> <Plug>(the-ocamlspot-type) <SID>(the-ocamlspot-type)
nnoremap <script> <Plug>(the-ocamlspot-def-preview) <SID>(the-ocamlspot-def-preview)

function! s:define_highlights()
  highlight default link TheOCamlSpotTree PmenuSel
  highlight default link TheOCamlSpotSpot MatchParen
  highlight default link TheOCamlSpotTypeKind Title
  highlight default link TheOCamlSpotVarName Identifier
  highlight default link TheOCamlSpotType Type
endfunction
call s:define_highlights()

augroup the-ocamlspot
  autocmd!
  autocmd CursorHold <buffer> call s:the_ocaml_type_cursorhold()
  autocmd ColorScheme * call s:define_highlights()
augroup END

function! s:the_ocaml_type_cursorhold()
  if !g:the_ocamlspot_no_default_auto_commands
    TheOCamlType
    autocmd the-ocamlspot CursorMoved <buffer> call the_ocamlspot#clear_highlight() | autocmd! the-ocamlspot CursorMoved
  endif
endfunction

if !g:the_ocamlspot_no_default_key_mappings
  nmap <buffer> <Leader>ot <Plug>(the-ocamlspot-type)
  nmap <buffer> <Leader>op <Plug>(the-ocamlspot-def-preview)
endif

if has('gui_running') && has('balloon_eval')
  setlocal ballooneval balloonexpr=the_ocamlspot#balloon_spotter()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
