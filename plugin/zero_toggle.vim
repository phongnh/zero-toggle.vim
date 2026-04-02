" plugin/zero_toggle.vim - Toggle common Vim settings (Vim9script)
" Maintainer:   Phong Nguyen

if !has('vim9script') || has('nvim') || exists('g:loaded_zero_toggle')
    finish
endif

vim9script

g:loaded_zero_toggle = 1

import autoload 'zero_toggle.vim' as ZeroToggle

ZeroToggle.Setup()
