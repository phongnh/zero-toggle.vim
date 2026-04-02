" autoload/zero_toggle.vim - Toggle common Vim settings (legacy Vimscript)
" Maintainer:   Phong Nguyen

" ============================================================================
" Helper Functions
" ============================================================================

function! s:toggle_gjk() abort
    if empty(mapcheck('j', 'n')) || empty(mapcheck('k', 'n'))
        nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
        xnoremap <expr> j v:count == 0 ? 'gj' : 'j'
        nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
        xnoremap <expr> k v:count == 0 ? 'gk' : 'k'
        nnoremap gj j
        xnoremap gj j
        nnoremap gk k
        xnoremap gk k
        echo 'Enabled gj/gk!'
    else
        silent! nunmap j
        silent! xunmap j
        silent! nunmap k
        silent! xunmap k
        silent! nunmap gj
        silent! xunmap gj
        silent! nunmap gk
        silent! xunmap gk
        echo 'Disabled gj/gk!'
    endif
endfunction

function! s:setup_unimpaired_mappings() abort
    " g:zero_toggle_unimpaired_mappings:
    "   1   → always set mappings
    "   0   → never set mappings
    "   unset → auto-detect: skip if vim-unimpaired is on the runtimepath
    let l:opt = get(g:, 'zero_toggle_unimpaired_mappings', -1)
    if l:opt == 0
        return
    endif
    if l:opt < 0 && !empty(globpath(&rtp, 'plugin/unimpaired.vim'))
        return
    endif

    " Background
    nnoremap <silent> yob :<C-U>set background=<C-R>=&background == 'dark' ? 'light' : 'dark'<CR><CR><Cmd>set background?<CR>
    " Cursorline
    nnoremap <silent> yoc :<C-U>setlocal cursorline! cursorline?<CR>
    nnoremap <silent> yo- :<C-U>setlocal cursorline! cursorline?<CR>
    nnoremap <silent> yo_ :<C-U>setlocal cursorline! cursorline?<CR>
    " Cursorcolumn
    nnoremap <silent> you :<C-U>setlocal cursorcolumn! cursorcolumn?<CR>
    nnoremap <silent> yo<Bar> :<C-U>setlocal cursorcolumn! cursorcolumn?<CR>
    " Hlsearch
    nnoremap <silent> yoh :<C-U>set hlsearch! hlsearch?<CR>
    " Ignorecase
    nnoremap <silent> yoi :<C-U>set ignorecase! ignorecase?<CR>
    " List
    nnoremap <silent> yol :<C-U>setlocal list! list?<CR>
    " Number
    nnoremap <silent> yon :<C-U>setlocal number! number?<CR>
    " Relativenumber
    nnoremap <silent> yor :<C-U>setlocal relativenumber! relativenumber?<CR>
    " Spell
    nnoremap <silent> yos :<C-U>setlocal spell! spell?<CR>
    " Wrap
    nnoremap <silent> yow :<C-U>setlocal wrap! wrap?<CR>
    " Virtualedit
    nnoremap <expr> yov printf(":\<C-U>set virtualedit%s=all\<CR>", &virtualedit =~# 'all' ? '-' : '+')
    " Cursorline + cursorcolumn cross
    nnoremap <expr> yox printf(":\<C-U>set %s\<CR>", &cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn')
    nnoremap <expr> yo+ printf(":\<C-U>set %s\<CR>", &cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn')
    " Colorcolumn
    nnoremap <expr> yot printf(":\<C-U>set colorcolumn=%s\<CR>", empty(&colorcolumn) ? '+1' : '')

    if has('diff')
        nnoremap <expr> yod printf(":\<C-U>%s\<CR>", &diff ? 'diffoff' : 'diffthis')
    endif

    " Move lines up/down
    nnoremap <silent> <M-j> <Cmd>move .+1<Bar>normal! ==<CR>
    nnoremap <silent> <M-k> <Cmd>move .-2<Bar>normal! ==<CR>
    vnoremap <silent> <M-j> :move '>+1<Bar>normal! gv=gv<CR>
    vnoremap <silent> <M-k> :move '<-2<Bar>normal! gv=gv<CR>
    inoremap <silent> <M-j> <Cmd>move .+1<Bar>normal! ==<CR>
    inoremap <silent> <M-k> <Cmd>move .-2<Bar>normal! ==<CR>

    " macOS Alt key aliases (Option+J / Option+K)
    nmap ∆ <M-j>
    nmap ˚ <M-k>
    vmap ∆ <M-j>
    vmap ˚ <M-k>
    imap ∆ <M-j>
    imap ˚ <M-k>

    nmap ]e <M-j>
    nmap [e <M-k>
    vmap ]e <M-j>
    vmap [e <M-k>
endfunction

function! s:setup_indent_guides_autocmd() abort
    augroup ZeroToggleShiftwidth
        autocmd!
        autocmd OptionSet shiftwidth
                    \   if &listchars =~# '\V\<leadmultispace\>'
                    \ |     execute printf('set listchars-=leadmultispace:┊%s', escape(repeat(' ', v:option_old - 1), ' '))
                    \ |     execute printf('set listchars+=leadmultispace:┊%s', escape(repeat(' ', v:option_new - 1), ' '))
                    \ | endif
    augroup END
endfunction

" ============================================================================
" Public Setup Function
" ============================================================================

function! zero_toggle#setup() abort
    " Change shiftwidth / tabstop
    nnoremap <silent> yo2 :<C-U>setlocal <C-R>=&expandtab ? 'shiftwidth=2 shiftwidth?' : 'tabstop=2 tabstop?'<CR><CR>
    nnoremap <silent> yo4 :<C-U>setlocal <C-R>=&expandtab ? 'shiftwidth=4 shiftwidth?' : 'tabstop=4 tabstop?'<CR><CR>
    nnoremap <silent> yo8 :<C-U>setlocal <C-R>=&expandtab ? 'shiftwidth=8 shiftwidth?' : 'tabstop=8 tabstop?'<CR><CR>

    " Toggle incsearch
    nnoremap <silent> yoS :<C-U>set incsearch! incsearch?<CR>

    " Toggle expandtab
    nnoremap <silent> yoe :<C-U>setlocal expandtab! expandtab?<CR>

    " Toggle "keep current line centred" (scrolloff trick)
    nnoremap <silent> yoz :<C-U>let &scrolloff = 1000 - &scrolloff<Bar>set scrolloff?<CR>

    " Toggle gj/gk
    nnoremap <silent> yom :<C-U>call <SID>toggle_gjk()<CR>

    " Toggle clipboard
    if has('clipboard')
        if has('unnamedplus')
            nnoremap <expr> yoy printf(":\<C-U>set clipboard%s=unnamedplus\<CR>", stridx(&clipboard, 'unnamedplus') > -1 ? '-' : '^')
        else
            nnoremap <expr> yoy printf(":\<C-U>set clipboard%s=unnamed\<CR>", stridx(&clipboard, 'unnamed') > -1 ? '-' : '^')
        endif
    endif

    " Toggle conceallevel
    if has('conceal')
        nnoremap <expr> yoC printf(":\<C-U>set conceallevel=%s\<CR>", &conceallevel > 0 ? 0 : 2)
    endif

    " Cycle diff algorithm
    if has('diff')
        nnoremap yoD :<C-U>set <C-R>=&diffopt =~# 'algorithm:histogram' ? 'diffopt-=algorithm:histogram diffopt+=algorithm:patience' : 'diffopt-=algorithm:patience diffopt+=algorithm:histogram'<CR><CR>
    endif

    " Toggle EOL in listchars
    nnoremap <expr> yoE printf(":\<C-U>set listchars%s=eol:§\<CR>", &listchars =~# '\V\<eol\>' ? '-' : '+')

    " Toggle trailing space in listchars
    nnoremap <expr> yo<Space> printf(":\<C-U>set listchars%s=trail:·\<CR>", &listchars =~# '\V\<trail\>' ? '-' : '+')

    " Toggle indent guides (requires Vim patch 8.2.5066 for leadmultispace)
    if has('patch-8.2.5066')
        nnoremap <expr> yoI printf(":\<C-U>set listchars%s=leadmultispace:┊%s\<CR>",
                    \ &listchars =~# '\V\<leadmultispace\>' ? '-' : '+',
                    \ escape(repeat(' ', (exists('*shiftwidth') ? shiftwidth() : &shiftwidth) - 1), ' '))
        call s:setup_indent_guides_autocmd()
    endif

    " Improved fold mappings — show foldlevel after each change
    nnoremap <silent> zr zr:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zm zm:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zR zR:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zM zM:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zi zi:<C-U>setlocal foldenable?<CR>
    nnoremap <silent> z] :<C-U>let &foldcolumn = &foldcolumn + 1<Bar>setlocal foldcolumn?<CR>
    nnoremap <silent> z[ :<C-U>let &foldcolumn = &foldcolumn - 1<Bar>setlocal foldcolumn?<CR>

    call s:setup_unimpaired_mappings()
endfunction
