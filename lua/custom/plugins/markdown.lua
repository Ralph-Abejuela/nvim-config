-- markview.nvim: Live markdown preview in Neovim
-- https://github.com/OXY2DEV/markview.nvim
-- Automatically renders headers, bold, italic, code blocks, etc.

vim.pack.add { 'https://github.com/OXY2DEV/markview.nvim' }

pcall(function()
  require('markview').setup {
    markdown = {
      headings = true,
      horizontal_rules = true,
      block_quotes = true,
      list_items = true,
      tables = true,
      code_blocks = true,
      html = true,
      math_blocks = true,
    },
    preview = {
      filetypes = { 'markdown', 'quarto', 'rmd' },
      ignore_buftypes = {},
      modes = { 'n', 'no', 'c' },
      hybrid_modes = { 'i' },
      max_width = 80,
      max_height = 40,
    },
  }
end)

-- Keymap: toggle markdown preview
vim.keymap.set('n', '<leader>mp', function()
  if pcall(require, 'markview') then
    require('markview').toggle()
  end
end, { desc = '[M]arkdown [P]review toggle' })
