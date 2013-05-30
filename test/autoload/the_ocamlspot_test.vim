" requre vim-scall

let s:testcase = vimtest#new('the_ocamlspot#parse_path_range')

  function! s:testcase.parse_range_lxxxcxxxbxxx_form()
    let spot = '</path/to/src.ml:l11c22b333:l23c1b444>'
    call self.assert.equals({
    \ 'path' : '/path/to/src.ml',
    \ 'range' : {
    \   'start' : ['11', '22'],
    \   'end' : ['23', '1']
    \ }}, Scall('the_ocamlspot:parse_path_range', spot))
  endfunction

  function! s:testcase.parse_range_all_form()
    let spot = '</path/to/src.ml:all>'
    call self.assert.equals({
    \ 'path' : '/path/to/src.ml',
    \ 'range' : {
    \   'start' : ['1', '1'],
    \   'end' : ['$', '$']
    \ }}, Scall('the_ocamlspot:parse_path_range', spot))
  endfunction

  function! s:testcase.parse_range_minus1_form()
    let spot = '</path/to/src.ml:-1:-1>'
    call self.assert.equals({
    \ 'path' : '/path/to/src.ml',
    \ 'range' : {
    \   'start' : ['1', '1'],
    \   'end' : ['$', '$']
    \ }}, Scall('the_ocamlspot:parse_path_range', spot))
  endfunction

  function! s:testcase.parse_range_failure()
    let spot = '</path/to/src.ml:lcb091:9l12b>'
    call self.assert.throw('Spot parsing error')
    call Scall('the_ocamlspot:parse_path_range', spot)
  endfunction

unlet s:testcase


let s:testcase = vimtest#new('the_ocamlspot#range_to_regex')

  function! s:testcase.range_to_regex()
    let range = {
    \ 'start' : ['1', '2'],
    \ 'end' : ['3', '4']
    \ }
    call self.assert.equals('\v(%1l%3v)\_.*(%3l%5v)', Scall('the_ocamlspot:range_to_regex', range))
  endfunction

  function! s:testcase.range_to_regex_all()
    let range = {
    \ 'start' : ['1', '1'],
    \ 'end' : ['$', '$']
    \ }
    call self.assert.equals('\v(%1l%2v)\_.*()', Scall('the_ocamlspot:range_to_regex', range))
  endfunction

unlet s:testcase

