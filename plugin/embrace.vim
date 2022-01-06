if exists('g:loaded_embrace') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim           " reset them to defaults

command! EmbraceNext       lua require("embrace").move_next_matching_brace()
command! EmbracePrev       lua require("embrace").move_prev_matching_brace()
command! EmbraceInsertList lua require("embrace").insert_before_list()
command! EmbraceAppendList lua require("embrace").insert_after_list()
command! EmbraceInsertElem lua require("embrace").insert_before_elem()
command! EmbraceAppendElem lua require("embrace").insert_after_elem()
command! EmbraceSlurpBack  lua require("embrace").slurp_back()
command! EmbraceSlurpForth lua require("embrace").slurp_forth()
command! EmbraceSplice     lua require("embrace").splice()

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_embrace = 1
