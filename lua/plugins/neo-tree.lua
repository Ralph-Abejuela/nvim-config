-- File tree: neo-tree. `nvim .` / :e dir opens the tree instead of netrw.
return (function()
  vim.pack.add {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/nvim-neo-tree/neo-tree.nvim',
  }

  require('neo-tree').setup {
    hijack_netrw_behavior = 'open_default', -- `nvim .` opens the tree
    filesystem = {
      follow_current_file = { enabled = true },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false, -- VSCode-like: everything visible
      },
    },
    window = { width = 30 },
  }
end)()
