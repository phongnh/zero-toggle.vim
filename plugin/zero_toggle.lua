-- plugin/zero_toggle.lua - Toggle common Vim settings (Neovim Lua)
-- Maintainer:   Phong Nguyen

if vim.g.loaded_zero_toggle then
  return
end
vim.g.loaded_zero_toggle = 1

local zero_toggle = require("zero_toggle")

zero_toggle.setup()
