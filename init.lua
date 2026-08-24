--[[
Neovim 0.12 modular config — lazy.nvim, <80ms startup target.

  lua/config/*.lua   → options, keymaps, autocmds (eager, tiny)
  lua/plugins/*.lua  → one lazy.nvim spec per plugin (all lazy)
]]

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', repo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Leader must be set before any lazy spec is processed
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Eager core (tiny, no plugins)
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Everything else lazy
require('lazy').setup({
  { import = 'plugins' },
}, {
  defaults = { lazy = true },
  install = { colorscheme = { 'tokyonight' } },
  checker = { enabled = false },
  performance = {
    cache = { enabled = true },
  },
})
