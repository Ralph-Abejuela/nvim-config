-- Neo-tree: Sidebar file explorer with git status, icons, filtering
-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- Press <leader>e to toggle, \ to reveal current file

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('neo-tree').setup {
  close_if_last_window = true,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        '.git',
        'node_modules',
      },
      never_show = {},
    },
    window = {
      mappings = {
        ['\\'] = 'close_window',
        ['<leader>e'] = 'close_window',
      },
    },
  },
  default_component_configs = {
    indent = { with_markers = false },
    icon = { folder_closed = '', folder_open = '', folder_empty = '' },
  },
}

-- Toggle neo-tree
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = '[E]xplore toggle (Neo-tree)' })

-- Reveal current file in neo-tree
vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'Neo-tree: reveal current file' })
