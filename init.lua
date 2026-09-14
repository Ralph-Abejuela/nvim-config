--[[
Neovim 0.12 modular config — vim.pack (built-in plugin manager), <80ms target.

  lua/config/*.lua   → options, keymaps, autocmds (eager, tiny)
  lua/plugins/*.lua  → one vim.pack.add() + setup() per plugin (all eager)

Load order matters here: a plugin's vim.pack.add() must run before anything
that requires its modules. Shared dependencies (plenary, web-devicons, …) are
listed in each file that needs them — re-adding an active plugin is a no-op.
]]

-- Leader must be set before any plugin loads
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Post-update hook: refresh treesitter parsers whenever nvim-treesitter is
-- updated. Must be created BEFORE the first vim.pack.add() (:h vim.pack-hooks).
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

-- Everything eager, in dependency order (colorscheme first to avoid flash)
require('plugins.colorscheme')
require('plugins.blink-cmp')
require('plugins.mini')
require('plugins.statusline')
require('plugins.treesitter')
require('plugins.autotag')
require('plugins.lsp')
require('plugins.neo-tree')
require('plugins.bufferline')
require('plugins.fzf-lua')
require('plugins.git')
require('plugins.harpoon')
require('plugins.copilot')
require('plugins.format')
require('plugins.sessions')
require('plugins.which-key')
