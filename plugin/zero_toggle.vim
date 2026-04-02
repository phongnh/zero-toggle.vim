" plugin/zero_toggle.vim - Toggle common Vim settings (legacy Vimscript)
" Maintainer:   Phong Nguyen

if has('nvim') || exists('g:loaded_zero_toggle')
    finish
endif

" Use Vim9script implementation if available, otherwise fall back to legacy
if has('vim9script')
    " Add vim9/ subdirectory to runtimepath so vim9/autoload/zero_toggle.vim
    " is found when the Vim9script plugin sources it via 'import autoload'
    let s:vim9dir = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') .. '/vim9'
    if isdirectory(s:vim9dir) && index(split(&runtimepath, ','), s:vim9dir) < 0
        execute 'set runtimepath^=' . fnameescape(s:vim9dir)
    endif
    source <sfile>:p:h:h/vim9/plugin/zero_toggle.vim
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
