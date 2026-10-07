-- Keymaps. Philosophy: every custom binding gets a plain-English `desc` so
-- which-key surfaces it in full sentences; vanilla vim behavior is kept
-- wherever it already exists. Press <Space> and wait to see everything.

local map = vim.keymap.set

-- ---- The absolute basics ----

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlighting' })
map('n', '<C-s>', '<cmd>write<CR>', { desc = 'Save file' })
map('i', '<C-s>', '<Esc><cmd>write<CR>a', { desc = 'Save file (stay in insert)' })
map('n', '<leader>q', '<cmd>quit<CR>', { desc = 'Quit this window' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Leave terminal (back to normal mode)' })

-- ---- Windows (panes) ----

map('n', '<C-h>', '<C-w>h', { desc = 'Window: go left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window: go down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window: go up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window: go right' })

-- ---- Buffers / files ----

map('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle the file explorer' })
map('n', '<leader>bb', '<cmd>FzfLua buffers<CR>', { desc = 'Switch to an open file (buffer)' })
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Close this file' })
map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next open file' })
map('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous open file' })

map('n', '<leader>ff', '<cmd>FzfLua files<CR>', { desc = 'Find files by name' })
map('n', '<leader>fs', '<cmd>FzfLua live_grep<CR>', { desc = 'Search text across the project' })
map('n', '<leader>fr', '<cmd>FzfLua oldfiles<CR>', { desc = 'Recently used files' })

map('n', '<leader>t', function()
  -- 25%-height terminal below; inside it press <Esc><Esc> to get back
  vim.cmd 'botright 12split | terminal pwsh'
  vim.cmd 'startinsert'
end, { desc = 'Open a terminal below' })

-- ---- LSP: the VSCode-equivalent commands ----
-- These do nothing until a language server is running; prefix descriptions
-- say exactly that.

map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to where this symbol is defined' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'Find all places this symbol is used' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to where this symbol is implemented' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover: show docs / type info' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename the symbol under the cursor' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Quick fixes and refactorings' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show the full error/warning here' })
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous error or warning' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next error or warning' })
map('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, { desc = 'Format this file (uses the language server)' })
map('n', '<leader>ci', function()
  vim.g.inlay_hints_enabled = vim.g.inlay_hints_enabled == false
  vim.lsp.inlay_hint.enable(vim.g.inlay_hints_enabled, { bufnr = 0 })
  print('Inlay hints: ' .. (vim.g.inlay_hints_enabled and 'on' or 'off'))
end, { desc = 'Toggle inline type/parameter hints' })

-- ---- Text editing conveniences (kept from before, all described) ----

-- Keep selection when indenting
map('v', '<', '<gv', { desc = 'Indent left, keep selection' })
map('v', '>', '>gv', { desc = 'Indent right, keep selection' })

-- Move the selected lines up/down
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Command line: keep history nav on arrows while the completion popup is up
map('c', '<Up>', function()
  if vim.fn.wildmenumode() == 1 then return vim.api.nvim_replace_termcodes('<C-E><Up>', true, false, true) end
  return '<Up>'
end, { desc = 'Command history up' })
map('c', '<Down>', function()
  if vim.fn.wildmenumode() == 1 then return vim.api.nvim_replace_termcodes('<C-E><Down>', true, false, true) end
  return '<Down>'
end, { desc = 'Command history down' })
