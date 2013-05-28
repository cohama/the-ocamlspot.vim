if exists('g:loaded_the_ocamlspot')
  finish
endif
let g:loaded_the_ocamlspot = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:current_buffer_cursor()
  return [expand('%'), line('.'), virtcol('.') - 1]
endfunction

function! s:preview_definition(ocamlspot_result)
  let spot = the_ocamlspot#get_info(a:ocamlspot_result, 'Spot')

  if empty(spot)
    echo 'No definition found'
    call s:get_ocaml_type(a:ocamlspot_result)
    return
  endif

  let spot_dict = the_ocamlspot#parse_spot(spot)

  execute 'pedit +' . spot_dict.range.start[0] . ' ' . spot_dict.path
endfunction

function! s:get_ocaml_type(ocamlspot_result)
  let type = the_ocamlspot#get_info(a:ocamlspot_result, 'Val', 'Type', 'Error')
  echo type
endfunction

function! s:the_ocamlspot_main(query_type)
  let target = s:current_buffer_cursor()
  let result = the_ocamlspot#run_ocaml_spot(target)

  try
    if a:query_type ==# 'type'
      call s:get_ocaml_type(result)
    elseif a:query_type ==# 'preview'
      call s:preview_definition(result)
    endif
  catch
    if has_key(result, 'Error')
      echo result.Error
    else
      echoerr 'Unexpected Error!'
    endif
  endtry
endfunction

command! -nargs=0 TheOCamlType call <SID>the_ocamlspot_main('type')
command! -nargs=0 TheOCamlDefPreview call <SID>the_ocamlspot_main('preview')

augroup the-ocamlspot
  autocmd!
  if !exists('g:the_ocamlspot_no_default_auto_commands') || !g:the_ocamlspot_no_default_auto_commands
    autocmd CursorHold <buffer> TheOCamlType
  endif
augroup END

if !exists('g:the_ocamlspot_no_default_key_mappings') || !g:the_ocamlspot_no_default_key_mappings
  nnoremap <buffer> <Leader>ot :<C-u>TheOCamlType<CR>
  nnoremap <buffer> <Leader>op :<C-u>TheOCamlDefPreview<CR>
endif

if has('gui_running') && has('balloon_eval')
  if !exists('g:the_ocamlspot_no_balloon') || !g:the_ocamlspot_no_balloon
    setlocal ballooneval balloonexpr=the_ocamlspot#balloon_spotter()
  endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
