-- Git: inline change markers in the gutter (gitsigns), described in plain
-- English for the which-key hint system.
return (function()
  vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }

  require('gitsigns').setup {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = vim.keymap.set
      local opts = { buffer = bufnr }

      map('n', ']h', gs.next_hunk, vim.tbl_extend('force', opts, { desc = 'Jump to next change' }))
      map('n', '[h', gs.prev_hunk, vim.tbl_extend('force', opts, { desc = 'Jump to previous change' }))
      map('n', '<leader>gp', gs.preview_hunk, vim.tbl_extend('force', opts, { desc = 'Preview this change' }))
      map('n', '<leader>hs', gs.stage_hunk, vim.tbl_extend('force', opts, { desc = 'Stage (commit) this change' }))
      map('n', '<leader>hr', gs.reset_hunk, vim.tbl_extend('force', opts, { desc = 'Undo this change' }))
      map(
        'v',
        '<leader>hs',
        function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
        vim.tbl_extend('force', opts, { desc = 'Stage selected changes' })
      )
      map(
        'v',
        '<leader>hr',
        function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
        vim.tbl_extend('force', opts, { desc = 'Undo selected changes' })
      )
      -- text object: inside a change, e.g. `vih`
      map({ 'o', 'x' }, 'ih', gs.select_hunk, vim.tbl_extend('force', opts, { desc = 'Select (inner change)' }))
    end,
  }
end)()
