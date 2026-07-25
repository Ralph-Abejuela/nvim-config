-- rainbow-delimiters.nvim: Rainbow-colored parentheses/brackets
-- https://github.com/HiPhish/rainbow-delimiters.nvim
-- Uses treesitter queries for accurate bracket pairing

vim.pack.add { 'https://github.com/HiPhish/rainbow-delimiters.nvim' }

-- Enable rainbow delimiters for all filetypes with treesitter
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype
    -- Skip non-code filetypes
    if vim.tbl_contains({ '', 'markdown', 'txt', 'help', 'dashboard' }, ft) then return end
    pcall(function()
      vim.treesitter.start(buf)
      require('rainbow-delimiters').enable(buf, { strategy = require('rainbow-delimiters').strategy['global'] })
    end)
  end,
})

-- Also enable on existing buffers
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == '' and vim.api.nvim_buf_is_loaded(buf) then
        pcall(function() require('rainbow-delimiters').enable(buf, { strategy = require('rainbow-delimiters').strategy['global'] }) end)
      end
    end
  end,
})
