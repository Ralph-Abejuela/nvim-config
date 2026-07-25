-- snacks.nvim: Picker, statusline, dashboard, bigfile, words, scroll, indent, scope
-- https://github.com/folke/snacks.nvim

vim.pack.add { 'https://github.com/folke/snacks.nvim' }

local snacks = require 'snacks'

snacks.setup {
  bigfile = { enabled = true },
  -- dashboard disabled: requires lazy.nvim internals (lazy.stats).
  -- Use mini.starter (already installed via mini.nvim) or alpha-nvim for a dashboard.
  dashboard = { enabled = false },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  quickfile = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  styles = {
    notification = {
      wo = { wrap = true },
    },
  },
}

-- Picker: fuzzy finder replacing Telescope
snacks.setup({
  picker = {
    enabled = true,
    sources = {
      files = { hidden = true, ignored = false },
      explorer = { hidden = true, ignored = false },
    },
  },
})

-- Statusline replacing mini.statusline
snacks.setup({
  statusline = {
    enabled = true,
  },
})

-- Picker keymaps (same leader keys as old Telescope setup)
vim.keymap.set('n', '<leader>sh', function() snacks.picker.help() end, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', function() snacks.picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', function() snacks.picker.files() end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', function() snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sw', function() snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', function() snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', function() snacks.picker.resume() end, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', function() snacks.picker.recent() end, { desc = '[S]earch Recent Files' })
vim.keymap.set('n', '<leader>sc', function() snacks.picker.commands() end, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', function() snacks.picker.buffers() end, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sn', function() snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
vim.keymap.set('n', '<leader>/', function() snacks.picker.grep_buffers() end, { desc = '[/] Search in current buffer' })

-- LSP picker mappings (on LspAttach)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('snacks-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = buf, desc = 'LSP: ' .. desc })
    end
    map('grr', function() snacks.picker.lsp_references() end, '[G]oto [R]eferences')
    map('gri', function() snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
    map('grd', function() snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
    map('gO', function() snacks.picker.lsp_symbols() end, 'Open Document Symbols')
    map('gW', function() snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
    map('grt', function() snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')
  end,
})
