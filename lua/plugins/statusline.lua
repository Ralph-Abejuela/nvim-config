-- Statusline: mini.statusline
return {
  {
    'echasnovski/mini.statusline',
    version = false,
    event = 'VeryLazy',
    config = function()
      require('mini.statusline').setup({ use_icons = true })
    end,
  },
}
