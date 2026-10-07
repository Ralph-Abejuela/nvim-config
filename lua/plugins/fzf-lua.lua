-- Fuzzy finder (files, text, buffers, recents) + vim.ui.select UI.
-- register_ui_select() replaces the numbered prompt for code actions with
-- these same fzf pickers.
return (function()
  vim.pack.add {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/ibhagwan/fzf-lua',
  }

  require('fzf-lua').setup {}
  require('fzf-lua').register_ui_select()
end)()
