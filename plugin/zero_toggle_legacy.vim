" plugin/zero_toggle_legacy.vim - Toggle common Vim settings (legacy Vimscript)
" Maintainer:   Phong Nguyen

if has('vim9script') || has('nvim') || exists('g:loaded_zero_toggle')
    finish
endif
let g:loaded_zero_toggle = 1

" Save cpoptions
let s:save_cpo = &cpoptions
set cpoptions&vim

call zero_toggle#legacy#setup()

" Restore cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
