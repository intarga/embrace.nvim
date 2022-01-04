if exists('g:loaded_embrace') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim           " reset them to defaults

command! EmbraceHelloWorld lua require("embrace").sayHelloWorld()

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_embrace = 1
