if exists('g:loaded_the_ocamlspot')
  finish
endif
let g:loaded_the_ocamlspot = 1

let s:save_cpo = &cpo
set cpo&vim


let &cpo = s:save_cpo
unlet s:save_cpo
