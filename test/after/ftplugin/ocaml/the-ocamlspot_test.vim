let s:testcase = vimtest#new('the_ocamlspot#get_info')

  function! s:testcase.get_type_info_get_Val()
    let result_dict = {
    \ 'Val': 'the Val',
    \ 'Type': 'the Type',
    \ 'Dummy': 'just a dummy'
    \ }
    call self.assert.equals('the Val', the_ocamlspot#get_info(result_dict, 'Val', 'Type', 'Error'))
  endfunction

  function! s:testcase.get_type_info_get_Type()
    let result_dict = {
    \ 'Type': 'the Type',
    \ 'Dummy': 'just a dummy'
    \ }
    call self.assert.equals('the Type', the_ocamlspot#get_info(result_dict, 'Val', 'Type', 'Error'))
  endfunction

  function! s:testcase.get_type_info_known_error()
    let result_dict = {
    \ 'Dummy': 'just a dummy',
    \ 'Error': 'the known error'
    \ }
    call self.assert.equals('the known error', the_ocamlspot#get_info(result_dict, 'Val', 'Type', 'Error'))
  endfunction

  function! s:testcase.get_type_info_unexpected_error()
    let result_dict = {
    \ 'Dummy': 'just a dummy'
    \ }
    call self.assert.equals('', the_ocamlspot#get_info(result_dict, 'Val', 'Type'))
  endfunction

unlet s:testcase


let s:testcase = vimtest#new('the_ocamlspot#ParseSpot')

  function! s:testcase.parse_spot_lxxxcxxxbxxx_form()
    let spot = 'Spot: </path/to/src.ml:l11c22b333:l23c1b444>'
    call self.assert.equals({
    \ 'path' : '/path/to/src.ml',
    \ 'range' : {
    \   'start' : ['11', '22'],
    \   'end' : ['23', '1']
    \ }}, the_ocamlspot#parse_spot(spot))
  endfunction

  function! s:testcase.parse_spot_all_form()
    let spot = 'Spot: </path/to/src.ml:all>'
    call self.assert.equals({
    \ 'path' : '/path/to/src.ml',
    \ 'range' : {
    \   'start' : ['1', '1'],
    \   'end' : ['$', '$']
    \ }}, the_ocamlspot#parse_spot(spot))
  endfunction

  function! s:testcase.parse_spot_minus1_form()
    let spot = 'Spot: </path/to/src.ml:-1:-1>'
    call self.assert.equals({
    \ 'path' : '/path/to/src.ml',
    \ 'range' : {
    \   'start' : ['1', '1'],
    \   'end' : ['$', '$']
    \ }}, the_ocamlspot#parse_spot(spot))
  endfunction

  function! s:testcase.parse_spot_failure()
    let spot = 'Spot: </path/to/src.ml:lcb091:9l12b>'
    call self.assert.throw('Spot parsing error')
    call the_ocamlspot#parse_spot(spot)
  endfunction

unlet s:testcase
