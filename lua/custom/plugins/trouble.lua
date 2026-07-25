-- trouble.nvim: Pretty list for diagnostics, references, quickfix, etc.
-- https://github.com/folke/trouble.nvim
-- Use <leader>xx for diagnostics, <leader>xX for workspace diagnostics

vim.pack.add { 'https://github.com/folke/trouble.nvim' }

require('trouble').setup {
  modes = {
    diagnostics = {
      mode = 'diagnostics',
      preview = { type = 'split', relative = 'win', position = 'right', size = 0.4 },
    },
  },
}

-- Keymaps
vim.keymap.set('n', '<leader>xx', function() require('trouble').toggle 'diagnostics' end, { desc = '[X] Toggle diagnostics list' })
vim.keymap.set('n', '<leader>xX', function() require('trouble').toggle 'diagnostics_filter' end, { desc = '[X] Workspace diagnostics' })
vim.keymap.set('n', '<leader>xq', function() require('trouble').toggle 'quickfix' end, { desc = '[X] Toggle quickfix list' })
vim.keymap.set('n', '<leader>xl', function() require('trouble').toggle 'loclist' end, { desc = '[X] Toggle location list' })
vim.keymap.set('n', 'gR', function() require('trouble').toggle 'lsp_references' end, { desc = '[X] Toggle LSP references' })
