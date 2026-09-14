-- Keymaps. Runs eagerly; plugin commands resolve lazily on keypress.

local map = vim.keymap.set

-- Better defaults
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<C-s>', '<cmd>write<CR>', { desc = 'Save' })
map('i', '<C-s>', '<Esc><cmd>write<CR>', { desc = 'Save' })
map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal' })

-- Keep selection when indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Move lines while keeping selection
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move up' })

-- Command line: keep history nav on arrows while the completion popup is up
map('c', '<Up>', function()
  if vim.fn.wildmenumode() == 1 then
    return vim.api.nvim_replace_termcodes('<C-E><Up>', true, false, true)
  end
  return '<Up>'
end, { expr = true })
map('c', '<Down>', function()
  if vim.fn.wildmenumode() == 1 then
    return vim.api.nvim_replace_termcodes('<C-E><Down>', true, false, true)
  end
  return '<Down>'
end, { expr = true })

-- NOTE: no custom cmdline <Tab> mapping — blink.cmp owns Tab in ':'
-- (shows/cycles the completion menu); a global c-mode map would shadow it.
-- In / and ? the native wildchar-Tab applies (see autocmds.lua).

-- ---- Leader: Space ----

-- Find (fzf-lua)
map('n', '<leader>ff', '<cmd>FzfLua files<CR>', { desc = 'Find files' })
map('n', '<leader>fg', '<cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<CR>', { desc = 'Buffers' })
map('n', '<leader>fr', '<cmd>FzfLua oldfiles<CR>', { desc = 'Recent files' })

-- File tree
map('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'File tree' })

-- Code (LSP)
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Definition' })
map('n', 'grd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Implementation' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })

-- Full diagnostics float (inline text truncates long messages)
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Diagnostics float' })

-- Toggle inlay hints (inline type/param annotations)
map('n', '<leader>ci', function()
  vim.g.inlay_hints_enabled = vim.g.inlay_hints_enabled == false
  vim.lsp.inlay_hint.enable(vim.g.inlay_hints_enabled, { bufnr = 0 })
  print('Inlay hints: ' .. (vim.g.inlay_hints_enabled and 'on' or 'off'))
end, { desc = 'Toggle inlay hints' })

-- Format (conform, keybind only — no format on save)
map('n', '<leader>cf', function()
  require('conform').format({ lsp_fallback = true })
end, { desc = 'Format' })

-- Git
map('n', '<leader>g', '<cmd>Lazygit<CR>', { desc = 'Lazygit' })

-- Harpoon (quick file pinning)
map('n', '<leader>a', function()
  require('harpoon'):list():add()
end, { desc = 'Harpoon add' })
map('n', '<leader>h', function()
  require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
end, { desc = 'Harpoon menu' })

-- Terminal
map('n', '<leader>t', '<cmd>ToggleTerm<CR>', { desc = 'Terminal' })

-- Sessions (persistence.nvim)
map('n', '<leader>qs', '<cmd>PersistenceSave<CR>', { desc = 'Save session' })
map('n', '<leader>ql', '<cmd>PersistenceLoad<CR>', { desc = 'Load session' })
