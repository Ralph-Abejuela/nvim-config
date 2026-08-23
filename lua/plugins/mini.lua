-- mini.nvim editing QoL: auto-pairs, surround, indent scope
return {
  {
    'echasnovski/mini.pairs',
    version = false,
    event = 'InsertEnter',
    config = function()
      require('mini.pairs').setup()
    end,
  },
  {
    'echasnovski/mini.surround',
    version = false,
    keys = { { 'gsa', mode = 'n' }, { 'gsd', mode = 'n' }, { 'gsr', mode = 'n' }, { 's', mode = 'v' } },
    config = function()
      require('mini.surround').setup()
    end,
  },
  {
    'echasnovski/mini.indentscope',
    version = false,
    event = 'BufReadPre',
    config = function()
      local indentscope = require('mini.indentscope')
      indentscope.setup({
        draw = { animation = indentscope.gen_animation.none() },
        symbol = '▏',
      })
    end,
  },
}
