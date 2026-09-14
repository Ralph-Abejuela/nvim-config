-- Git: inline hunks (gitsigns) + lazygit in floating terminal (toggleterm)
return (function()
  vim.pack.add({
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/akinsho/toggleterm.nvim',
  })

  require('gitsigns').setup({})

  require('toggleterm').setup({
    direction = 'float',
    float_opts = { border = 'rounded' },
    open_mapping = false, -- use <leader>t instead of auto C-`
    shell = 'pwsh', -- interactive terminals get pwsh; nvim's global shell stays cmd (see options.lua)
  })

  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({ cmd = 'lazygit', direction = 'float', hidden = true })
  vim.api.nvim_create_user_command('Lazygit', function()
    lazygit:toggle()
  end, {})
end)()
