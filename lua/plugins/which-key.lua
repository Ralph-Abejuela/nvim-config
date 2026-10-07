-- which-key shows every custom binding, in plain English, as you type.
-- Press <Space> and pause: it opens the menu of everything
-- leader-prefixed; <leader>? (default binding) lists them all at once.
return (function()
  vim.pack.add { 'https://github.com/folke/which-key.nvim' }

  require('which-key').setup {
    presets = { operators = true, motions = true }, -- hint vanilla keys too
  }
  require('which-key').add {
    { '<leader>b', group = 'Buffers' },
    { '<leader>c', group = 'Language server (LSP)' },
    { '<leader>f', group = 'Files / Search' },
    { '<leader>h', group = 'Git hunks' },
  }

  -- Full cheat sheet: every global keybind, vim-native included
  vim.keymap.set('n', '<leader>?', function() require('which-key').show { global = true } end, { desc = 'Show every keybind, vim-native included' })
end)()
