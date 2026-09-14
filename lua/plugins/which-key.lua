-- Leader key hints as you type
return (function()
  vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

  require('which-key').setup({})
  require('which-key').add({
    { '<leader>f', group = 'Find' },
    { '<leader>c', group = 'Code' },
    { '<leader>g', group = 'Git' },
    { '<leader>h', group = 'Harpoon' },
    { '<leader>t', group = 'Terminal' },
    { '<leader>q', group = 'Session' },
  })
end)()
