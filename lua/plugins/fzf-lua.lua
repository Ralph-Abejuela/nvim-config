-- Fuzzy finder (files, grep, buffers, recents) + global vim.ui.select.
-- register_ui_select() replaces Neovim's default numbered-prompt picker so
-- code actions and other vim.ui.select consumers open an interactive fzf UI.
return (function()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim', -- no-op if already active
    'https://github.com/ibhagwan/fzf-lua',
  })

  require('fzf-lua').setup({})
  require('fzf-lua').register_ui_select()
end)()
