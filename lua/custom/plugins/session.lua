-- auto-session.nvim: Automatic session management
-- https://github.com/rmagatti/auto-session
-- Saves/restores tabs, splits, buffers, and working directory

vim.pack.add { 'https://github.com/rmagatti/auto-session' }

local ok, auto_session = pcall(require, 'auto-session')
if not ok then return end

auto_session.setup {
  log_level = 'error',
  auto_session_suppress_dirs = {
    vim.fn.expand '~',
    vim.fn.expand '~/Downloads',
    vim.fn.expand '~/Documents',
    '/',
  },
  auto_save = true,
  auto_restore = true,
  auto_restore_last_session = false,
  use_git_branch = true,
  -- Session lens: preview session before restoring
  session_lens = {
    load_on_setup = true,
    theme_conf = { border = true },
    previewer = true,
  },
}

-- Keymaps
vim.keymap.set('n', '<leader>wr', function() require('auto-session').RestoreSession() end, { desc = '[W]orkspace [R]estore session' })
vim.keymap.set('n', '<leader>ws', function() require('auto-session').SaveSession() end, { desc = '[W]orkspace [S]ave session' })
vim.keymap.set('n', '<leader>wl', function() require('auto-session').SearchSession() end, { desc = '[W]orkspace session [L]ens' })
vim.keymap.set('n', '<leader>wd', function() require('auto-session').DeleteSession() end, { desc = '[W]orkspace [D]elete session' })
