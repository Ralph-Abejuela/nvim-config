-- toggleterm.nvim: Persistent floating/split terminal
-- https://github.com/akinsho/toggleterm.nvim
-- Use <C-\\> to toggle, <leader>tt for float, <leader>tT for horizontal

vim.pack.add {
  {
    src = 'https://github.com/akinsho/toggleterm.nvim',
    version = vim.version.range '*',
  },
}

require('toggleterm').setup {
  size = function(term)
    if term.direction == 'horizontal' then return 15 end
    if term.direction == 'vertical' then return vim.o.columns * 0.4 end
    return 20 -- float
  end,
  open_mapping = '<C-\\>', -- Toggle terminal with Ctrl+\
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  -- Cross-platform shell: pwsh (Win/Linux) > zsh > bash > sh
  shell = vim.fn.executable('pwsh') == 1 and (vim.fn.has('win32') == 1 and 'pwsh.exe' or 'pwsh')
    or vim.fn.executable('zsh') == 1 and 'zsh'
    or vim.fn.executable('bash') == 1 and 'bash'
    or 'sh',
  float_opts = {
    border = 'curved',
    winblend = 0,
    highlights = { border = 'Normal', background = 'Normal' },
  },
}

-- Additional keymaps for terminal types (outside <leader>t which is owned by testing)
vim.keymap.set('n', '<leader>tt', function()
  require('toggleterm').toggle(0, 100, nil, 'float')
end, { desc = '[T]oggle [T]erminal (float)' })

vim.keymap.set('n', '<leader>tT', function()
  require('toggleterm').toggle(15, 100, nil, 'horizontal')
end, { desc = '[T]oggle [T]erminal (horizontal)' })

-- Terminal mode: use Esc to exit insert mode in terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal insert mode' })
