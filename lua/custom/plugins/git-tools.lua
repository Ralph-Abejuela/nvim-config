-- Git tools: diffview.nvim for git history/log UI, git-conflict.nvim for merge conflicts
-- diffview: https://github.com/sindrets/diffview.nvim
-- git-conflict: https://github.com/akinsho/git-conflict.nvim

vim.pack.add {
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/akinsho/git-conflict.nvim',
}

-- diffview.nvim
local dv_ok, diffview = pcall(require, 'diffview')
if dv_ok then
  diffview.setup {
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = 'diff3_mixed',
        disable_diagnostics = true,
      },
    },
  }

  vim.keymap.set('n', '<leader>gd', function() diffview.open() end, { desc = '[G]it [D]iff (diffview)' })
  vim.keymap.set('n', '<leader>gh', function() diffview.open(vim.fn.input('Commit range: ')) end, { desc = '[G]it diff [H]istory' })
  vim.keymap.set('n', '<leader>gf', function() diffview.file_history() end, { desc = '[G]it [F]ile history' })
end

-- git-conflict.nvim
local gc_ok, git_conflict = pcall(require, 'git-conflict')
if gc_ok then
  git_conflict.setup {
    default_mappings = true,
    default_commands = true,
    disable_diagnostics = true,
    list_opener = 'copen',
    highlights = {
      incoming = 'DiffAdd',
      current = 'DiffText',
      ancestor = 'DiffChange',
    },
  }
end
