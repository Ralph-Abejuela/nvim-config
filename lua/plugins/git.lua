-- Git: inline hunks (gitsigns) + lazygit in floating terminal (toggleterm)
return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  {
    'akinsho/toggleterm.nvim',
    cmd = { 'ToggleTerm', 'Lazygit' },
    opts = {
      direction = 'float',
      float_opts = { border = 'rounded' },
      open_mapping = false, -- use <leader>t instead of auto C-`
      shell = 'pwsh', -- interactive terminals get pwsh; nvim's global shell stays cmd (see options.lua)
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)

      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({ cmd = 'lazygit', direction = 'float', hidden = true })
      vim.api.nvim_create_user_command('Lazygit', function()
        lazygit:toggle()
      end, {})
    end,
  },
}
