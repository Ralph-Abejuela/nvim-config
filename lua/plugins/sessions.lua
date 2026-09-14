-- Sessions: auto save/restore per project dir
return (function()
  vim.pack.add({ 'https://github.com/folke/persistence.nvim' })
  require('persistence').setup({})
end)()
