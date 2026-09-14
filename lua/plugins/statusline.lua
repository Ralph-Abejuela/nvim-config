-- Statusline: mini.statusline
return (function()
  vim.pack.add({ 'https://github.com/echasnovski/mini.statusline' })
  require('mini.statusline').setup({ use_icons = true })
end)()
