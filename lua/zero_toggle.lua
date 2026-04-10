-- lua/zero_toggle.lua - Toggle common Vim settings (Neovim Lua)
-- Maintainer:   Phong Nguyen

local M = {}

-- ============================================================================
-- Helper Functions
-- ============================================================================

local function echo(...)
  local args = {}
  for idx = 1, select("#", ...) do
    args[idx] = select(idx, ...)
  end
  vim.api.nvim_echo({ { table.concat(args, " ") } }, false, {})
end

--- Toggle gj/gk <-> j/k mappings.
local function toggle_gjk()
  if vim.fn.mapcheck("j", "n") == "" or vim.fn.mapcheck("k", "n") == "" then
    vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })
    vim.keymap.set({ "n", "x" }, "gj", "j")
    vim.keymap.set({ "n", "x" }, "gj", "k")
    echo("Enabled gj/gk!")
  else
    for _, lhs in ipairs({ "j", "k", "gj", "gk" }) do
      pcall(vim.keymap.del, "n", lhs)
      pcall(vim.keymap.del, "x", lhs)
    end
    echo("Disabled gj/gk!")
  end
end

--- Setup unimpaired-style mappings according to g:zero_toggle_unimpaired_mappings.
-- 1     → always set mappings
-- 0     → never set mappings
-- unset → auto-detect: skip if vim-unimpaired is on the runtimepath
local function setup_unimpaired_mappings()
  local opt = vim.g.zero_toggle_unimpaired_mappings
  if opt == 0 then
    return
  end
  if opt == nil and vim.fn.globpath(vim.o.rtp, "plugin/unimpaired.vim") ~= "" then
    return
  end

  local opts = { silent = true }

  -- Background
  vim.keymap.set("n", "yob", function()
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
    echo("set background=" .. vim.o.background)
  end, opts)

  -- Cursorline
  vim.keymap.set("n", "yoc", "<Cmd>setlocal cursorline! cursorline!<CR>", opts)
  vim.keymap.set("n", "yo-", "<Cmd>setlocal cursorline! cursorline!<CR>", opts)
  vim.keymap.set("n", "yo_", "<Cmd>setlocal cursorline! cursorline!<CR>", opts)

  -- Cursorcolumn
  vim.keymap.set("n", "you", "<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>", opts)
  vim.keymap.set("n", "yo<Bar>", "<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>", opts)

  -- Hlsearch
  vim.keymap.set("n", "yoh", "<Cmd>set hlsearch! hlsearch?<CR>", opts)

  -- Ignorecase
  vim.keymap.set("n", "yoi", "<Cmd>set ignorecase! ignorecase?<CR>", opts)

  -- List
  vim.keymap.set("n", "yol", "<Cmd>setlocal list! list?<CR>", opts)

  -- Number
  vim.keymap.set("n", "yon", "<Cmd>setlocal number! number?<CR>", opts)

  -- Relativenumber
  vim.keymap.set("n", "yor", "<Cmd>setlocal relativenumber! relativenumber?<CR>", opts)

  -- Spell
  vim.keymap.set("n", "yos", "<Cmd>setlocal spell! spell?<CR>", opts)

  -- Wrap
  vim.keymap.set("n", "yow", "<Cmd>setlocal wrap! wrap?<CR>", opts)

  -- Virtualedit
  vim.keymap.set("n", "yov", function()
    if vim.tbl_contains(vim.opt.virtualedit:get(), "all") then
      vim.opt.virtualedit:remove("all")
      echo("set virtualedit-=all")
    else
      vim.opt.virtualedit:append("all")
      echo("set virtualedit+=all")
    end
  end, opts)

  local function toggle_cursorline_and_cursorcolumn()
    if vim.wo.cursorline and vim.wo.cursorcolumn then
      vim.wo.cursorline = false
      vim.wo.cursorcolumn = false
      echo("set nocursorline nocursorcolumn")
    else
      vim.wo.cursorline = true
      vim.wo.cursorcolumn = true
      echo("set cursorline cursorcolumn")
    end
  end

  vim.keymap.set("n", "yox", toggle_cursorline_and_cursorcolumn, opts)
  vim.keymap.set("n", "yo+", toggle_cursorline_and_cursorcolumn, opts)

  -- Colorcolumn
  vim.keymap.set("n", "yot", function()
    vim.wo.colorcolumn = vim.wo.colorcolumn == "" and "+1" or ""
    echo("set cursorcolumn=" .. vim.wo.colorcolumn)
  end, opts)

  -- Diff
  if vim.fn.has("diff") == 1 then
    vim.keymap.set("n", "yod", function()
      if vim.wo.diff then
        vim.cmd("diffoff")
        echo("diffoff")
      else
        vim.cmd("diffthis")
        echo("diffthis")
      end
    end, opts)
  end

  -- Move lines up/down
  vim.keymap.set("n", "<M-j>", "<Cmd>move .+1<Bar>normal! ==<CR>", opts)
  vim.keymap.set("n", "<M-k>", "<Cmd>move .-2<Bar>normal! ==<CR>", opts)
  vim.keymap.set("v", "<M-j>", ":move '>+1<Bar>normal! gv=gv<CR>", opts)
  vim.keymap.set("v", "<M-k>", ":move '<-2<Bar>normal! gv=gv<CR>", opts)
  vim.keymap.set("i", "<M-j>", "<Cmd>move .+1<Bar>normal! ==<CR>", opts)
  vim.keymap.set("i", "<M-k>", "<Cmd>move .-2<Bar>normal! ==<CR>", opts)

  -- macOS Option+J / Option+K aliases
  vim.keymap.set("n", "∆", "<M-j>")
  vim.keymap.set("n", "˚", "<M-k>")
  vim.keymap.set("v", "∆", "<M-j>")
  vim.keymap.set("v", "˚", "<M-k>")
  vim.keymap.set("i", "∆", "<M-j>")
  vim.keymap.set("i", "˚", "<M-k>")

  vim.keymap.set("n", "]e", "<M-j>")
  vim.keymap.set("n", "[e", "<M-k>")
  vim.keymap.set("v", "]e", "<M-j>")
  vim.keymap.set("v", "[e", "<M-k>")
end

-- ============================================================================
-- Public API
-- ============================================================================

function M.setup()
  local opts = { silent = true }

  -- Change shiftwidth / tabstop
  local function change_shiftwidth_or_tabstop(size)
    return function()
      if vim.bo.expandtab then
        vim.bo.shiftwidth = size
        vim.cmd("set shiftwidth?")
      else
        vim.bo.tabstop = size
        vim.cmd("set tabstop?")
      end
    end
  end

  vim.keymap.set("n", "yo2", change_shiftwidth_or_tabstop(2), opts)
  vim.keymap.set("n", "yo4", change_shiftwidth_or_tabstop(4), opts)
  vim.keymap.set("n", "yo8", change_shiftwidth_or_tabstop(8), opts)

  -- Toggle incsearch
  vim.keymap.set("n", "yoS", "<Cmd>set incsearch! incsearch?<CR>", opts)

  -- Toggle expandtab
  vim.keymap.set("n", "yoe", "<Cmd>setlocal expandtab! expandtab?<CR>", opts)

  -- Toggle "keep current line centred" (scrolloff trick)
  vim.keymap.set("n", "yoz", "<Cmd>lua vim.o.scrolloff = 1000 - vim.o.scrolloff<CR><Cmd>set scrolloff?<CR>", opts)

  -- Toggle gj/gk
  vim.keymap.set("n", "yom", toggle_gjk, opts)

  -- Toggle clipboard
  if vim.fn.has("clipboard") == 1 then
    local clipboard = vim.fn.has("unnamedplus") == 1 and "unnamedplus" or "unnamed"
    vim.keymap.set("n", "yoy", function()
      if vim.tbl_contains(vim.opt.clipboard:get(), clipboard) then
        vim.opt.clipboard:remove(clipboard)
        echo("set clipboard-=" .. clipboard)
      else
        vim.opt.clipboard:prepend(clipboard)
        echo("set clipboard^=" .. clipboard)
      end
    end, opts)
  end

  -- Toggle conceallevel
  if vim.fn.has("conceal") == 1 then
    vim.keymap.set("n", "yoC", function()
      vim.wo.conceallevel = vim.wo.conceallevel > 0 and 0 or 2
      echo("set conceallevel=" .. vim.wo.conceallevel)
    end, opts)
  end

  -- Cycle diff algorithm (patience <-> histogram)
  if vim.fn.has("diff") == 1 then
    vim.keymap.set("n", "yoD", function()
      if vim.tbl_contains(vim.opt.diffopt:get(), "algorithm:histogram") then
        vim.opt.diffopt:remove("algorithm:histogram")
        vim.opt.diffopt:append("algorithm:patience")
        echo("set diffopt+=algorithm:patience")
      else
        vim.opt.diffopt:append("algorithm:histogram")
        echo("set diffopt+=algorithm:histogram")
      end
    end, opts)
  end

  -- Toggle EOL in listchars
  vim.keymap.set("n", "yoE", function()
    local listchars = vim.opt_local.listchars:get()
    if listchars.eol ~= nil then
      echo("setlocal listchars-=eol:" .. listchars.eol)
      listchars.eol = nil
      vim.opt_local.listchars = listchars
    else
      vim.opt_local.listchars:append({ eol = "§" })
      echo("setlocal listchars+=eol:§")
    end
  end, opts)

  -- Toggle trailing space in listchars
  vim.keymap.set("n", "yo<Space>", function()
    local listchars = vim.opt_local.listchars:get()
    if listchars.trail ~= nil then
      echo("setlocal listchars-=trail:" .. listchars.trail)
      listchars.trail = nil
      vim.opt_local.listchars = listchars
    else
      vim.opt_local.listchars:append({ trail = "·" })
      echo("setlocal listchars+=trail:·")
    end
  end, opts)

  -- Toggle indent guides via leadmultispace (Neovim always supports this)
  vim.keymap.set("n", "yoI", function()
    local listchars = vim.opt_local.listchars:get()
    if listchars.leadmultispace ~= nil then
      local value = listchars.leadmultispace
      listchars.leadmultispace = nil
      vim.opt_local.listchars = listchars
      echo("setlocal listchars-=leadmultispace:" .. value)
    else
      local value = "┊" .. string.rep(" ", math.max(vim.fn.shiftwidth() - 1, 0))
      vim.opt_local.listchars:append({ leadmultispace = value })
      echo("setlocal listchars+=" .. value)
    end
  end, opts)

  vim.api.nvim_create_autocmd("OptionSet", {
    group = vim.api.nvim_create_augroup("ZeroToggleShiftwidth", { clear = true }),
    pattern = "shiftwidth",
    callback = function()
      local listchars = vim.opt_local.listchars:get()
      if not listchars.leadmultispace then
        return
      end
      local new_shiftwidth = tonumber(vim.v.option_new) or vim.fn.shiftwidth()
      local value = "┊" .. string.rep(" ", math.max(new_shiftwidth - 1, 0))
      listchars.leadmultispace = value
      vim.opt_local.listchars = listchars
    end,
  })

  -- Improved fold mappings — echo foldlevel after each change
  vim.keymap.set("n", "zr", "zr<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "zm", "zm<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "zR", "zR<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "zM", "zM<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "zi", "zi<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "z]", "<Cmd>let &foldcolumn = &foldcolumn + 1<CR><Cmd>setlocal foldcolumn?<CR>", opts)
  vim.keymap.set("n", "z[", "<Cmd>let &foldcolumn = &foldcolumn - 1<CR><Cmd>setlocal foldcolumn?<CR>", opts)

  setup_unimpaired_mappings()
end

return M
