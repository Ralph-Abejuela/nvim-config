-- Buffer tabs at top
return (function()
  vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons', -- no-op if already active
    'https://github.com/akinsho/bufferline.nvim',
  })

  require('bufferline').setup({
    options = {
      diagnostics = 'nvim_lsp',
      -- Custom close handler (bufferline README-recommended): switch to the
      -- most-recently-used OTHER file buffer BEFORE deleting, so nvim never
      -- falls back to the neo-tree buffer (which made the tree expand to
      -- full width) and never closes the window/quit on a tab close.
      -- Closing the last file buffer falls through to :bwipeout; the
      -- BufDelete handler in config/autocmds.lua quits nvim then.
      close_command = function(bufnr)
        if vim.api.nvim_get_current_buf() == bufnr then
          local target, mru = nil, 0
          for _, n in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.fn.bufname(n)
            if
              n ~= bufnr
              and name ~= ''
              and name ~= '.'
              and vim.bo[n].buftype == ''
              and vim.bo[n].filetype ~= 'neo-tree'
              and vim.fn.isdirectory(vim.fn.fnamemodify(name, ':p')) ~= 1
            then
              local used = vim.fn.getbufinfo(n)[1].lastused or 0
              if used > mru then
                mru = used
                target = n
              end
            end
          end
          if target then
            vim.cmd.buffer(target)
          end
        end
        vim.cmd('bwipeout ' .. bufnr)
      end,
      offsets = {
        { filetype = 'neo-tree', text = 'File Explorer', highlight = 'Directory' },
      },
    },
  })
end)()
