-- Colorscheme — the only eagerly-loaded plugin (priority 1000)
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'mocha',
      integrations = {
        gitsigns = true,
        neo_tree = true,
        treesitter = true,
        bufferline = true,
        which_key = true,
        mini = {
          statusline = true,
          indentscope = true,
          pairs = true,
          surround = true,
        },
      },
    },
  },
}
