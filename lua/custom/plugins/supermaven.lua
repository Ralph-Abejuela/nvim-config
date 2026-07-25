-- supermaven.nvim: Free AI code completion
-- https://github.com/supermaven-inc/supermaven-nvim
-- Integrates with blink.cmp as a completion source

vim.pack.add {
  'https://github.com/supermaven-inc/supermaven-nvim',
}

require('supermaven-nvim').setup {
  keymaps = {
    accept_suggestion = '<C-y>',
    clear_suggestion = '<C-]>',
    accept_word = '<C-j>',
  },
  ignore_filetypes = {},
  color = {
    suggestion_color = '#808080',
    cterm = 244,
  },
  log_level = 'warn',
  disable_in_insert_mode = false,
}

-- Note: Supermaven integrates with blink.cmp automatically via its built-in
-- source. If you want to use Supermaven as a standalone (not through blink),
-- set disable_in_insert_mode = true in supermaven-nvim and use its inline
-- ghost text instead.
