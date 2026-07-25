-- flash.nvim: Rapid navigation with search labels and treesitter-aware jumping
-- https://github.com/folke/flash.nvim
-- Press s for forward jump, S for backward, f/t/F/T enhanced

vim.pack.add { 'https://github.com/folke/flash.nvim' }

require('flash').setup {
  labels = 'asdfghjklqwertyuiopzxcvbnm',
  search = {
    multi_window = true,
    wrap = true,
  },
  jump = {
    autojump = false,
  },
  label = {
    rainbow = { enabled = true },
  },
  modes = {
    char = {
      jump_labels = true,
      multi_line = false,
    },
  },
}

-- Enhanced f/t/F/T with flash labels
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash treesitter jump' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Flash remote' })
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Flash treesitter search' })
