function! the_ocamlspot#run_ocaml_spot(bufname_line_col)
  let bufname = a:bufname_line_col[0]
  let line = a:bufname_line_col[1]
  let col = a:bufname_line_col[2]
  let ocamlspot_cmd = printf('ocamlspot %s:l%dc%d 2>&1', bufname, line, col)
  let result = system(ocamlspot_cmd)
  let g:ocamlspot_result = result
  return the_ocamlspot#parse_result(result)
endfunction

function! the_ocamlspot#get_type_info(result_dict)
  return the_ocamlspot#get_info(a:result_dict, 'Val', 'Type', 'Error')
endfunction

function! the_ocamlspot#get_spot_info(result_dict)
  return the_ocamlspot#get_info(a:result_dict, 'Spot')
endfunction

function! the_ocamlspot#get_info(result_dict, ...)
  for desired_key in a:000
    if has_key(a:result_dict, desired_key)
      return a:result_dict[desired_key]
    endif
  endfor
  return ''
endfunction

function! the_ocamlspot#parse_result(result)
  let result_dict = {}
  for line in split(a:result, "\n")
    let matches = matchlist(line, '\v(\w+)\: (.+)')
    if !empty(matches)
      let key = matches[1]
      let value = matches[2]
      let result_dict[key] = key . ': ' . value
    endif
  endfor
  return result_dict
endfunction

function! the_ocamlspot#parse_spot(spot) abort
  let matches = matchlist(a:spot, '\vSpot\:\ \<(\f+):(all|[\-0-9lcb]+:[\-0-9lcb]+)\>')
  if empty(matches)
    return {}
  else
    let path = matches[1]
    let range = matches[2]
    let regurated_range = s:parse_spot_range(range)
    return {'path': matches[1], 'range': regurated_range}
  endif
endfunction

" parse range value and return regurated form Dictionary
" it returns {start: [sline, scol], end: [eline, ecol]}
function! s:parse_spot_range(range) abort
    if a:range ==# 'all' || a:range ==# '-1:-1'
      return {
      \   'start' : ['1', '1'],
      \   'end'   : ['$', '$']
      \ }
    elseif a:range =~# '\v^l.+c.+b.+\:l.+c.+b.+$'
      let matches = matchlist(a:range, '\vl([\-0-9]+)c([\-0-9]+)b[\-0-9]+\:l([\-0-9]+)c([\-0-9]+)b[\-0-9]+')
      return {
      \ 'start' : [matches[1], matches[2]],
      \ 'end'   : [matches[3], matches[4]]
      \ }
    else
      throw 'Spot parsing error'
    endif
endfunction

function! s:balloon_buffer_cursor()
  return [bufname(v:beval_bufnr), v:beval_lnum, v:beval_col - 1]
endfunction

function! the_ocamlspot#balloon_spotter()
  let target = s:balloon_buffer_cursor()
  return the_ocamlspot#get_type_info(the_ocamlspot#run_ocaml_spot(target))
endfunction

