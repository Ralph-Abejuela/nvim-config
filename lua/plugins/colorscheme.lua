-- Colorscheme — the only eagerly-loaded plugin (priority 1000).
-- config() must explicitly call colorscheme: lazy loads + setups the plugin,
-- but does not apply it.
return {
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    lazy = false,
    priority = 1000,
    opts = {
      style = 'night', -- darkest Tokyo Night (moon/storm/day are alternates)
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme('tokyonight')
    end,
  },
}
