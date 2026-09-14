-- File tree: neo-tree (dotfiles + gitignored visible, follows current file).
-- Loads eagerly so its BufEnter hijack + setup()'s argv(0) check are live
-- before nvim opens the startup arg — `nvim .` opens the tree, not netrw.
return (function()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/nvim-neo-tree/neo-tree.nvim',
  })

  require('neo-tree').setup({
    -- close_if_last_window = false (default): the WinClosed autocmd gated
    -- on it blocks closing when any buffer is modified ("Cannot close
    -- because one of the files is modified…") — a false positive that
    -- hijacks :wq (vim's own E37 already guards unsaved buffers). The
    -- useful part (close the tree when it's the last window left) is
    -- reimplemented without the guard in lua/config/autocmds.lua.
    -- hijack `nvim .` / `:e dir` so the tree opens instead of netrw
    hijack_netrw_behavior = 'open_default',
    filesystem = {
      follow_current_file = { enabled = true },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = { width = 30 },
  })
end)()
