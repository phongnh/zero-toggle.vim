-- lua/zero_toggle.lua - Toggle common Vim settings (Neovim Lua)
-- Maintainer:   Phong Nguyen

local M = {}

-- ============================================================================
-- Helper Functions
-- ============================================================================

local map = vim.keymap.set
local fn = vim.fn
local o = vim.o

--- Toggle gj/gk <-> j/k mappings.
local function toggle_gjk()
  if fn.mapcheck("j", "n") == "" or fn.mapcheck("k", "n") == "" then
    map({ "n", "x" }, "j", function()
      return vim.v.count == 0 and "gj" or "j"
    end, { expr = true })
    map({ "n", "x" }, "k", function()
      return vim.v.count == 0 and "gk" or "k"
    end, { expr = true })
    map({ "n", "x" }, "gj", "j")
    map({ "n", "x" }, "gk", "k")
    vim.api.nvim_echo({ { "Enabled gj/gk!" } }, false, {})
  else
    for _, lhs in ipairs({ "j", "k", "gj", "gk" }) do
      pcall(vim.keymap.del, "n", lhs)
      pcall(vim.keymap.del, "x", lhs)
    end
    vim.api.nvim_echo({ { "Disabled gj/gk!" } }, false, {})
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
  if opt == nil and fn.globpath(o.rtp, "plugin/unimpaired.vim") ~= "" then
    return
  end

  local silent = { silent = true }

  -- Background
  map("n", "yob", function()
    o.background = o.background == "dark" and "light" or "dark"
    vim.api.nvim_echo({ { "background=" .. o.background } }, false, {})
  end, silent)

  -- Cursorline
  local function toggle_cursorline()
    vim.wo.cursorline = not vim.wo.cursorline
    vim.api.nvim_echo({ { "cursorline " .. (vim.wo.cursorline and "on" or "off") } }, false, {})
  end
  map("n", "yoc", toggle_cursorline, silent)
  map("n", "yo-", toggle_cursorline, silent)
  map("n", "yo_", toggle_cursorline, silent)

  -- Cursorcolumn
  local function toggle_cursorcolumn()
    vim.wo.cursorcolumn = not vim.wo.cursorcolumn
    vim.api.nvim_echo({ { "cursorcolumn " .. (vim.wo.cursorcolumn and "on" or "off") } }, false, {})
  end
  map("n", "you", toggle_cursorcolumn, silent)
  map("n", "yo|", toggle_cursorcolumn, silent)

  -- Hlsearch
  map("n", "yoh", function()
    o.hlsearch = not o.hlsearch
    vim.api.nvim_echo({ { "hlsearch " .. (o.hlsearch and "on" or "off") } }, false, {})
  end, silent)

  -- Ignorecase
  map("n", "yoi", function()
    o.ignorecase = not o.ignorecase
    vim.api.nvim_echo({ { "ignorecase " .. (o.ignorecase and "on" or "off") } }, false, {})
  end, silent)

  -- List
  map("n", "yol", function()
    vim.wo.list = not vim.wo.list
    vim.api.nvim_echo({ { "list " .. (vim.wo.list and "on" or "off") } }, false, {})
  end, silent)

  -- Number
  map("n", "yon", function()
    vim.wo.number = not vim.wo.number
    vim.api.nvim_echo({ { "number " .. (vim.wo.number and "on" or "off") } }, false, {})
  end, silent)

  -- Relativenumber
  map("n", "yor", function()
    vim.wo.relativenumber = not vim.wo.relativenumber
    vim.api.nvim_echo({ { "relativenumber " .. (vim.wo.relativenumber and "on" or "off") } }, false, {})
  end, silent)

  -- Spell
  map("n", "yos", function()
    vim.wo.spell = not vim.wo.spell
    vim.api.nvim_echo({ { "spell " .. (vim.wo.spell and "on" or "off") } }, false, {})
  end, silent)

  -- Wrap
  map("n", "yow", function()
    vim.wo.wrap = not vim.wo.wrap
    vim.api.nvim_echo({ { "wrap " .. (vim.wo.wrap and "on" or "off") } }, false, {})
  end, silent)

  -- Virtualedit
  map("n", "yov", function()
    if o.virtualedit:find("all") then
      o.virtualedit = o.virtualedit:gsub(",?all", ""):gsub("all,?", "")
      if o.virtualedit == "" then
        o.virtualedit = "block"
      end
    else
      o.virtualedit = o.virtualedit ~= "" and (o.virtualedit .. ",all") or "all"
    end
    vim.api.nvim_echo({ { "virtualedit=" .. o.virtualedit } }, false, {})
  end, silent)

  -- Cursorline + cursorcolumn cross
  local function toggle_cross()
    local on = vim.wo.cursorline and vim.wo.cursorcolumn
    vim.wo.cursorline = not on
    vim.wo.cursorcolumn = not on
    vim.api.nvim_echo({ { "cursorline+cursorcolumn " .. (not on and "on" or "off") } }, false, {})
  end
  map("n", "yox", toggle_cross, silent)
  map("n", "yo+", toggle_cross, silent)

  -- Colorcolumn
  map("n", "yot", function()
    vim.wo.colorcolumn = vim.wo.colorcolumn == "" and "+1" or ""
    vim.api.nvim_echo({ { "colorcolumn=" .. vim.wo.colorcolumn } }, false, {})
  end, silent)

  -- Diff
  if fn.has("diff") == 1 then
    map("n", "yod", function()
      if vim.wo.diff then
        vim.cmd("diffoff")
      else
        vim.cmd("diffthis")
      end
    end, silent)
  end

  -- Move lines up/down
  map("n", "<M-j>", "<Cmd>move .+1<Bar>normal! ==<CR>", silent)
  map("n", "<M-k>", "<Cmd>move .-2<Bar>normal! ==<CR>", silent)
  map("v", "<M-j>", ":move '>+1<Bar>normal! gv=gv<CR>", silent)
  map("v", "<M-k>", ":move '<-2<Bar>normal! gv=gv<CR>", silent)
  map("i", "<M-j>", "<Cmd>move .+1<Bar>normal! ==<CR>", silent)
  map("i", "<M-k>", "<Cmd>move .-2<Bar>normal! ==<CR>", silent)

  -- macOS Option+J / Option+K aliases
  map("n", "∆", "<M-j>")
  map("n", "˚", "<M-k>")
  map("v", "∆", "<M-j>")
  map("v", "˚", "<M-k>")
  map("i", "∆", "<M-j>")
  map("i", "˚", "<M-k>")

  map("n", "]e", "<M-j>")
  map("n", "[e", "<M-k>")
  map("v", "]e", "<M-j>")
  map("v", "[e", "<M-k>")
end

--- Set up the shiftwidth autocmd for indent-guides leadmultispace sync.
local function setup_indent_guides_autocmd()
  vim.api.nvim_create_augroup("ZeroToggleShiftwidth", { clear = true })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = "ZeroToggleShiftwidth",
    pattern = "shiftwidth",
    callback = function(ev)
      local lc = o.listchars
      if not lc:find("leadmultispace") then
        return
      end
      local old_sw = ev.match and tonumber(ev.match) or (vim.v.option_old and tonumber(vim.v.option_old))
      local new_sw = tonumber(vim.v.option_new) or fn.shiftwidth()
      if old_sw and old_sw > 1 then
        lc = lc:gsub("leadmultispace:┊" .. string.rep(" ", old_sw - 1) .. ",?", "")
          :gsub(",leadmultispace:┊" .. string.rep(" ", old_sw - 1), "")
      elseif old_sw == 1 then
        lc = lc:gsub("leadmultispace:┊,?", ""):gsub(",leadmultispace:┊", "")
      end
      local suffix = new_sw > 1 and ("┊" .. string.rep(" ", new_sw - 1)) or "┊"
      lc = lc ~= "" and (lc .. ",leadmultispace:" .. suffix) or ("leadmultispace:" .. suffix)
      o.listchars = lc
    end,
  })
end

-- ============================================================================
-- Public API
-- ============================================================================

function M.setup()
  local silent = { silent = true }

  -- Change shiftwidth / tabstop
  map("n", "yo2", function()
    if vim.bo.expandtab then
      vim.bo.shiftwidth = 2
      vim.api.nvim_echo({ { "shiftwidth=2" } }, false, {})
    else
      vim.bo.tabstop = 2
      vim.api.nvim_echo({ { "tabstop=2" } }, false, {})
    end
  end, silent)
  map("n", "yo4", function()
    if vim.bo.expandtab then
      vim.bo.shiftwidth = 4
      vim.api.nvim_echo({ { "shiftwidth=4" } }, false, {})
    else
      vim.bo.tabstop = 4
      vim.api.nvim_echo({ { "tabstop=4" } }, false, {})
    end
  end, silent)
  map("n", "yo8", function()
    if vim.bo.expandtab then
      vim.bo.shiftwidth = 8
      vim.api.nvim_echo({ { "shiftwidth=8" } }, false, {})
    else
      vim.bo.tabstop = 8
      vim.api.nvim_echo({ { "tabstop=8" } }, false, {})
    end
  end, silent)

  -- Toggle incsearch
  map("n", "yoS", function()
    o.incsearch = not o.incsearch
    vim.api.nvim_echo({ { "incsearch " .. (o.incsearch and "on" or "off") } }, false, {})
  end, silent)

  -- Toggle expandtab
  map("n", "yoe", function()
    vim.bo.expandtab = not vim.bo.expandtab
    vim.api.nvim_echo({ { "expandtab " .. (vim.bo.expandtab and "on" or "off") } }, false, {})
  end, silent)

  -- Toggle "keep current line centred" (scrolloff trick)
  map("n", "yoz", function()
    o.scrolloff = 1000 - o.scrolloff
    vim.api.nvim_echo({ { "scrolloff=" .. o.scrolloff } }, false, {})
  end, silent)

  -- Toggle gj/gk
  map("n", "yom", toggle_gjk, silent)

  -- Toggle clipboard
  if fn.has("clipboard") == 1 then
    map("n", "yoy", function()
      local reg = fn.has("unnamedplus") == 1 and "unnamedplus" or "unnamed"
      if o.clipboard:find(reg) then
        o.clipboard = o.clipboard:gsub(",?" .. reg, ""):gsub(reg .. ",?", "")
      else
        o.clipboard = o.clipboard ~= "" and (o.clipboard .. "," .. reg) or reg
      end
      vim.api.nvim_echo({ { "clipboard=" .. o.clipboard } }, false, {})
    end, silent)
  end

  -- Toggle conceallevel
  if fn.has("conceal") == 1 then
    map("n", "yoC", function()
      vim.wo.conceallevel = vim.wo.conceallevel > 0 and 0 or 2
      vim.api.nvim_echo({ { "conceallevel=" .. vim.wo.conceallevel } }, false, {})
    end, silent)
  end

  -- Cycle diff algorithm (patience <-> histogram)
  if fn.has("diff") == 1 then
    map("n", "yoD", function()
      if o.diffopt:find("algorithm:histogram") then
        o.diffopt = o.diffopt:gsub("algorithm:histogram", "algorithm:patience")
      else
        o.diffopt = o.diffopt:gsub("algorithm:patience", "algorithm:histogram")
        if not o.diffopt:find("algorithm:") then
          o.diffopt = o.diffopt .. ",algorithm:histogram"
        end
      end
      vim.api.nvim_echo({ { "diffopt=" .. o.diffopt } }, false, {})
    end, silent)
  end

  -- Toggle EOL in listchars
  map("n", "yoE", function()
    local lc = o.listchars
    if lc:find("eol:") then
      o.listchars = lc:gsub(",?eol:[^,]*", ""):gsub("eol:[^,]*,?", "")
    else
      o.listchars = lc ~= "" and (lc .. ",eol:§") or "eol:§"
    end
    vim.api.nvim_echo({ { "listchars=" .. o.listchars } }, false, {})
  end, silent)

  -- Toggle trailing space in listchars
  map("n", "yo<Space>", function()
    local lc = o.listchars
    if lc:find("trail:") then
      o.listchars = lc:gsub(",?trail:[^,]*", ""):gsub("trail:[^,]*,?", "")
    else
      o.listchars = lc ~= "" and (lc .. ",trail:·") or "trail:·"
    end
    vim.api.nvim_echo({ { "listchars=" .. o.listchars } }, false, {})
  end, silent)

  -- Toggle indent guides via leadmultispace (Neovim always supports this)
  map("n", "yoI", function()
    local lc = o.listchars
    local sw = fn.shiftwidth()
    local marker = "leadmultispace:┊" .. string.rep(" ", math.max(sw - 1, 0))
    if lc:find("leadmultispace:") then
      o.listchars = lc:gsub(",?leadmultispace:[^,]*", ""):gsub("leadmultispace:[^,]*,?", "")
    else
      o.listchars = lc ~= "" and (lc .. "," .. marker) or marker
    end
    vim.api.nvim_echo({ { "listchars=" .. o.listchars } }, false, {})
  end, silent)
  setup_indent_guides_autocmd()

  -- Improved fold mappings — echo foldlevel after each change
  map("n", "zr", function()
    vim.cmd("normal! zr")
    vim.api.nvim_echo({ { "foldlevel=" .. vim.wo.foldlevel } }, false, {})
  end, silent)
  map("n", "zm", function()
    vim.cmd("normal! zm")
    vim.api.nvim_echo({ { "foldlevel=" .. vim.wo.foldlevel } }, false, {})
  end, silent)
  map("n", "zR", function()
    vim.cmd("normal! zR")
    vim.api.nvim_echo({ { "foldlevel=" .. vim.wo.foldlevel } }, false, {})
  end, silent)
  map("n", "zM", function()
    vim.cmd("normal! zM")
    vim.api.nvim_echo({ { "foldlevel=" .. vim.wo.foldlevel } }, false, {})
  end, silent)
  map("n", "zi", function()
    vim.cmd("normal! zi")
    vim.api.nvim_echo({ { "foldenable " .. (vim.wo.foldenable and "on" or "off") } }, false, {})
  end, silent)
  map("n", "z]", function()
    vim.wo.foldcolumn = tostring(tonumber(vim.wo.foldcolumn) + 1)
    vim.api.nvim_echo({ { "foldcolumn=" .. vim.wo.foldcolumn } }, false, {})
  end, silent)
  map("n", "z[", function()
    local fc = math.max(tonumber(vim.wo.foldcolumn) - 1, 0)
    vim.wo.foldcolumn = tostring(fc)
    vim.api.nvim_echo({ { "foldcolumn=" .. vim.wo.foldcolumn } }, false, {})
  end, silent)

  setup_unimpaired_mappings()
end

return M
