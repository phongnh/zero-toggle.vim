-- plugin/zero_toggle.lua - Toggle common Vim settings (Neovim Lua)
-- Maintainer:   Phong Nguyen

if vim.g.loaded_zero_toggle then
  return
end
vim.g.loaded_zero_toggle = 1

require("zero_toggle").setup()
