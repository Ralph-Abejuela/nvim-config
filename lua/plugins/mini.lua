-- mini.nvim editing QoL: auto-pairs, surround, indent scope
return (function()
  vim.pack.add({
    'https://github.com/echasnovski/mini.pairs',
    'https://github.com/echasnovski/mini.surround',
    'https://github.com/echasnovski/mini.indentscope',
  })

  require('mini.pairs').setup()

  -- gs prefix mappings (gsa/gsd/gsr, visual s) come from setup() defaults
  require('mini.surround').setup()

  local indentscope = require('mini.indentscope')
  indentscope.setup({
    draw = { animation = indentscope.gen_animation.none() },
    symbol = '▏',
  })
end)()
