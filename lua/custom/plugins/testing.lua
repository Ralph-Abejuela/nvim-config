-- neotest: Modern test runner with adapter support
-- https://github.com/nvim-neotest/neotest
-- Adapters: vitest (js/ts), jest (js/ts), go (go), pytest (python), rust (cargo)

vim.pack.add {
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-lua/plenary.nvim',
}

-- neotest will auto-detect adapters based on filetype
-- Install adapters on demand or configure them explicitly below.
-- Common adapters (add to vim.pack.add above if needed):
--   'https://github.com/nvim-neotest/neotest-vitest'   -- Vitest (Vite-based js/ts)
--   'https://github.com/nvim-neotest/neotest-jest'     -- Jest
--   'https://github.com/nvim-neotest/neotest-go'       -- Go
--   'https://github.com/nvim-neotest/neotest-python'   -- pytest
--   'https://github.com/rouge8/neotest-rust'           -- cargo test

local ok, neotest = pcall(require, 'neotest')
if not ok then return end

neotest.setup {
  adapters = {
    -- require('neotest-vitest'),   -- Uncomment when adapter is installed
    -- require('neotest-jest'),
    -- require('neotest-go'),
    -- require('neotest-python'),
    -- require('neotest-rust'),
  },
  status = { enabled = true, signs = true },
  output = { open_on_run = true },
  quickfix = { enabled = true },
}

-- Keymaps
vim.keymap.set('n', '<leader>tr', function() neotest.run.run() end, { desc = '[T]est [R]un nearest' })
vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand '%') end, { desc = '[T]est run [F]ile' })
vim.keymap.set('n', '<leader>tS', function() neotest.run.run(vim.fn.getcwd()) end, { desc = '[T]est run [S]uite' })
vim.keymap.set('n', '<leader>tl', function() neotest.run.run_last() end, { desc = '[T]est run [L]ast' })
vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = '[T]est [S]ummary toggle' })
vim.keymap.set('n', '<leader>to', function() neotest.output.open() end, { desc = '[T]est [O]utput' })
vim.keymap.set('n', '<leader>ta', function() neotest.attach() end, { desc = '[T]est [A]ttach (debug)' })
