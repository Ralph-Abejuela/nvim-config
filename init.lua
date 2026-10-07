--[[
Neovim 0.12 LSP-first config — vim.pack (built-in plugin manager).

Design priorities (in order):
  1. LSP for ANY language, installed lazily: open a file of a language whose
     server is not installed and the server downloads itself. No ensure-list.
  2. Every custom keybind has a plain-English description surfaced by
     which-key (leader hints as you type) — no vim experience assumed.
  3. Warm LSP: a language server starts once per language per session and is
     reused by every later buffer of that language. Closing files never
     restarts it, and already-served languages are memoized so re-opening a
     file costs a single table lookup.
  4. Zero LSP configuration: servers run on nvim-lspconfig recipe defaults;
     nothing is hand-tuned per language (one documented exception: lua_ls,
     because editing this config IS editing lua).
  5. VSCode-parity behavior: goto/refs/rename/hover/code-actions/refactor,
     inline diagnostics + hover detail, inlay hints, formatter via LSP,
     file explorer, fuzzy finder, git gutter, snippets.
  6. Fast: eager load is ~10 tiny plugin files; treesitter parsers and LSP
     servers install lazily on first use, cached afterwards.
  7. Snippets: LuaSnip + friendly-snippets.
  8. Useful completion sorting: exact match > fuzzy score (frecency +
     proximity) > item kind (fields/variables/functions first) > sort_text.

Load order matters: blink-cmp before lsp (capabilities query), colorscheme
first (no flash), everything else after.
]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'config.options'
require 'config.keymaps'
require 'config.statusline'
require 'config.autocmds'

-- Post-update hook: refresh treesitter parsers whenever nvim-treesitter is
-- updated. Must exist BEFORE the first vim.pack.add() (:h vim.pack-hooks).
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

require 'plugins.colorscheme'
require 'plugins.blink-cmp'
require 'plugins.lsp'
require 'plugins.treesitter'
require 'plugins.neo-tree'
require 'plugins.fzf-lua'
require 'plugins.git'
require 'plugins.which-key'
