-- File tree: neo-tree (dotfiles + gitignored visible, follows current file)
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    -- Must source before nvim opens the startup arg: only then are the
    -- BufEnter hijack autocmd + setup()'s argv(0) check live, so `nvim .`
    -- opens the tree instead of leaving a stray directory buffer.
    lazy = false,
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<CR>', desc = 'File tree' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = {
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
    },
  },
}
