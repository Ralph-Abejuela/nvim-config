-- barbar.nvim: Tab/buffer line with buffer management
-- https://github.com/romgrk/barbar.nvim

vim.pack.add {
  { src = 'https://github.com/romgrk/barbar.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/lewis6991/gitsigns.nvim',
}

require('barbar').setup {}

-- Move to previous/next buffer
vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>', { desc = 'Buffer: Previous' })
vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', { desc = 'Buffer: Next' })

-- Re-order buffer position
vim.keymap.set('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', { desc = 'Buffer: Move previous' })
vim.keymap.set('n', '<A->>', '<Cmd>BufferMoveNext<CR>', { desc = 'Buffer: Move next' })

-- Jump to buffer by number
vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', { desc = 'Buffer: Goto #1' })
vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', { desc = 'Buffer: Goto #2' })
vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', { desc = 'Buffer: Goto #3' })
vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', { desc = 'Buffer: Goto #4' })
vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', { desc = 'Buffer: Goto #5' })
vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', { desc = 'Buffer: Goto #6' })
vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', { desc = 'Buffer: Goto #7' })
vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', { desc = 'Buffer: Goto #8' })
vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', { desc = 'Buffer: Goto #9' })
vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', { desc = 'Buffer: Goto last' })

-- Pin/unpin buffer
vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', { desc = 'Buffer: Pin/unpin' })

-- Close buffer
vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>', { desc = 'Buffer: Close' })

-- Buffer picking
vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>', { desc = 'Buffer: Pick' })
vim.keymap.set('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', { desc = 'Buffer: Pick delete' })

-- Sort buffers
vim.keymap.set('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', { desc = 'Buffer: Order by number' })
vim.keymap.set('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', { desc = 'Buffer: Order by name' })
vim.keymap.set('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', { desc = 'Buffer: Order by directory' })
vim.keymap.set('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', { desc = 'Buffer: Order by language' })
vim.keymap.set('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', { desc = 'Buffer: Order by window' })
