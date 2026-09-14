-- Colorscheme — loaded first so the UI never flashes unstyled.
return (function()
  vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' })
  require('tokyonight').setup({
    style = 'night', -- darkest Tokyo Night (moon/storm/day are alternates)
  })
  vim.cmd.colorscheme('tokyonight')
end)()
