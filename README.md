# zero-toggle.vim

A Vim plugin to toggle the most commonly used Vim settings with intuitive `yo*` key mappings.

## Features

- Toggle editor options: `number`, `relativenumber`, `wrap`, `spell`, `list`, `cursorline`, `cursorcolumn`, `hlsearch`, `ignorecase`, `expandtab`, `incsearch`, `virtualedit`, `conceallevel`, `colorcolumn`, `scrolloff`, `clipboard`
- Toggle `listchars` components: EOL marker, trailing space, indent guides (`leadmultispace`)
- Cycle diff algorithm (`patience` ↔ `histogram`)
- Toggle `diff` mode per window
- Change indent width on the fly (`yo2`, `yo4`, `yo8`)
- Swap `gj`/`gk` ↔ `j`/`k` for soft-wrapped line navigation
- Improved fold mappings that echo the current `foldlevel`
- Line-move mappings (`<M-j>` / `<M-k>`) when vim-unimpaired is absent
- Automatically skips unimpaired-style mappings when [vim-unimpaired](https://github.com/tpope/vim-unimpaired) is loaded
- Works with **Vim** (7.4+) and **Neovim** (Lua)

## Installation

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'phongnh/zero-toggle.vim'
```

### [lazy.nvim](https://github.com/folke/lazy.nvim) (Neovim)

```lua
{ 'phongnh/zero-toggle.vim' }
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim) (Neovim)

```lua
use 'phongnh/zero-toggle.vim'
```

## Key Mappings

All mappings use the `yo` prefix (mnemonic: **y**ou **o**ption).

### Always available

| Mapping | Description |
|---------|-------------|
| `yo2` | Set shiftwidth/tabstop to 2 |
| `yo4` | Set shiftwidth/tabstop to 4 |
| `yo8` | Set shiftwidth/tabstop to 8 |
| `yoe` | Toggle `expandtab` |
| `yoS` | Toggle `incsearch` |
| `yoz` | Toggle centred-scroll (`scrolloff=999`) |
| `yom` | Toggle `gj`/`gk` ↔ `j`/`k` |
| `yoy` | Toggle `clipboard` (`unnamedplus` / `unnamed`) |
| `yoC` | Toggle `conceallevel` (0 ↔ 2) |
| `yoD` | Cycle diff algorithm (`patience` ↔ `histogram`) |
| `yoE` | Toggle `eol:§` in `listchars` |
| `yo<Space>` | Toggle `trail:·` in `listchars` |
| `yoI` | Toggle indent guides (`leadmultispace`) in `listchars` |
| `zr` / `zm` | Decrease / increase foldlevel (echoes current level) |
| `zR` / `zM` | Open / close all folds (echoes current level) |
| `zi` | Toggle `foldenable` |
| `z]` / `z[` | Increment / decrement `foldcolumn` |

### Controlled by `g:zero_toggle_unimpaired_mappings`

The mappings below duplicate those provided by
[vim-unimpaired](https://github.com/tpope/vim-unimpaired). Whether they are
installed is controlled by `g:zero_toggle_unimpaired_mappings`:

| Value | Behaviour |
|-------|-----------|
| `1` | Always install the mappings |
| `0` | Never install the mappings |
| unset *(default)* | Auto-detect: skip if `plugin/unimpaired.vim` is found on `&runtimepath` |

| Mapping | Description |
|---------|-------------|
| `yob` | Toggle `background` (dark ↔ light) |
| `yoc` / `yo-` / `yo_` | Toggle `cursorline` |
| `you` / `yo\|` | Toggle `cursorcolumn` |
| `yoh` | Toggle `hlsearch` |
| `yoi` | Toggle `ignorecase` |
| `yol` | Toggle `list` |
| `yon` | Toggle `number` |
| `yor` | Toggle `relativenumber` |
| `yos` | Toggle `spell` |
| `yow` | Toggle `wrap` |
| `yov` | Toggle `virtualedit=all` |
| `yox` / `yo+` | Toggle `cursorline` + `cursorcolumn` together |
| `yot` | Toggle `colorcolumn=+1` |
| `yod` | Toggle `diffthis` / `diffoff` |
| `<M-j>` / `∆` / `]e` | Move line(s) down |
| `<M-k>` / `˚` / `[e` | Move line(s) up |

## Configuration

### `g:zero_toggle_unimpaired_mappings`

Controls whether the unimpaired-style `yo*` mappings and line-move mappings are
installed (see table above).

```vim
" Always install (useful when vim-unimpaired is loaded but you still want these)
let g:zero_toggle_unimpaired_mappings = 1

" Never install
let g:zero_toggle_unimpaired_mappings = 0

" Default: auto-detect from &runtimepath (no need to set anything)
```

## Versions

The plugin ships all two implementations and selects the right one automatically:

| Implementation | File | Loaded when |
|---|---|---|
| Vimscript | `plugin/zero_toggle.vim` | Vim |
| Lua | `plugin/zero_toggle.lua` | Neovim |

## License

MIT License

## Credits

Created by Phong Nguyen

The unimpaired-style `yo*` mappings and line-move mappings are inspired by
[vim-unimpaired](https://github.com/tpope/vim-unimpaired) by Tim Pope.
