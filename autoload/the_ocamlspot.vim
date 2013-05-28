function! the_ocamlspot#run_ocaml_spot(bufname_line_col)
  let bufname = a:bufname_line_col[0]
  let line = a:bufname_line_col[1]
  let col = a:bufname_line_col[2]
  let ocamlspot_cmd = printf('ocamlspot %s:l%dc%d 2>&1', bufname, line, col)
  let result = system(ocamlspot_cmd)
  let g:ocamlspot_result = result
  return the_ocamlspot#parse_result(result)
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

function! the_ocamlspot#parse_xtree(xtree) abort
  let matches = matchlist(a:spot, '\vXTree\:\ \<(\f+):(all|[\-0-9lcb]+:[\-0-9lcb]+)\>')
  if empty(matches)
    return {}
  else
    let path = matches[1]
    let range = matches[2]
    let regurated_range = s:parse_range(range)
    return {'path': matches[1], 'range': regurated_range}
  endif
endfunction

function! the_ocamlspot#parse_path_range(spot) abort
  let matches = matchlist(a:spot, '\v\w+\:\ \<(\f+):(all|[\-0-9lcb]+:[\-0-9lcb]+)\>')
  if empty(matches)
    return {}
  else
    let path = matches[1]
    let range = matches[2]
    let regurated_range = s:parse_range(range)
    return {'path': matches[1], 'range': regurated_range}
  endif
endfunction

" parse range value and return regurated form Dictionary
" it returns {start: [sline, scol], end: [eline, ecol]}
function! s:parse_range(range) abort
    if a:range ==# 'all' || a:range ==# '-1:-1'
      return {
      \   'start' : ['1', '1'],
      \   'end'   : ['$', '$']
      \ }
    elseif a:range =~# '\v^l.+c.+b.+\:l.+c.+b.+$'
      let matches = matchlist(a:range, '\vl([\-0-9]+)c([\-0-9]+)b[\-0-9]+\:l([\-0-9]+)c([\-0-9]+)b[\-0-9]+')
      return {
      \ 'start' : [matches[1], str2nr(matches[2]) + 1],
      \ 'end'   : [matches[3], str2nr(matches[4]) + 1]
      \ }
    else
      throw 'Spot parsing error'
    endif
endfunction

function! the_ocamlspot#range_to_regex(range)
  let sl = '%' . a:range.start[0] . 'l'
  let sc = '%' . a:range.start[1] . 'v'

  let el = (a:range.end[0] ==# '$') ? '' : '%' . a:range.end[0] . 'l'
  let ec = (a:range.end[1] ==# '$') ? '' : '%' . a:range.end[1] . 'v'

  return printf('\v(%s%s)\_.*(%s%s)', sl, sc, el, ec)
endfunction

function! s:balloon_buffer_cursor()
  return [bufname(v:beval_bufnr), v:beval_lnum, v:beval_col - 1]
endfunction

function! the_ocamlspot#balloon_spotter()
  let target = s:balloon_buffer_cursor()
  return the_ocamlspot#get_type_info(the_ocamlspot#run_ocaml_spot(target))
endfunction

