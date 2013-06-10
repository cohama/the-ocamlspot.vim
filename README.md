The OCamlSpot Dot Vim !!!
========================================

the-ocamlspot.vim is a wrapper of OCamlSpotter.
You can easily browse an OCaml code.
Indicating the type information of a term, jumping to the definition.
And a lot of features will be implemented soon!

This plugin depends on [OCamlSpotter](http://opam.ocamlpro.com/pkg/ocamlspot.4.00.1.2.1.2.html)

You should install OCamlSpotter before using this plugin.

Screen Shots
----------------------------------------

### Indicate Type
![Indicate type](http://gyazo.com/8624b5f39ed10b0679ba6d5616afd64f.png)

### Jump to Definition
![Jump to definition](http://gyazo.com/41f4cc49cdfe87b40fab60d89ee28013.png)

Installation
----------------------------------------
If you use [gmarik/Vundle](https://github.com/gmarik/vundle)
```VimL
Bundle 'cohama/the-ocamlspot.vim'
```

If you use [Shougo/NeoBundle](https://github.com/Shougo/neobundle.vim)
```VimL
NeoBundle 'cohama/the-ocamlspot.vim'
```

or

```VimL
NeoBundleLazy 'cohama/the-ocamlspot.vim', {
\ 'autoload' : {
\   'filetypes' : 'ocaml'
\ }}
```
