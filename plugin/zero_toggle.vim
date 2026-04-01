" plugin/zero_toggle.vim - Toggle common Vim settings
" Maintainer:   Phong Nguyen

if has('nvim') || exists('g:loaded_zero_toggle')
    finish
endif
let g:loaded_zero_toggle = 1

" Save cpoptions
let s:save_cpo = &cpoptions
set cpoptions&vim

call zero_toggle#setup()

" Restore cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
