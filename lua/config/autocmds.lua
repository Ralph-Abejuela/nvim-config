-- Autocmds. Runs eagerly.

local augroup = vim.api.nvim_create_augroup('UserConfig', { clear = true })

-- Big-file guard: >2MB disables treesitter/LSP/folding/undo
vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' }, {
  group = augroup,
  callback = function()
    local f = vim.fn.expand('<afile>')
    if vim.fn.getfsize(f) > 2 * 1024 * 1024 then
      vim.b.bigfile = true
      vim.bo.foldmethod = 'manual'
      vim.bo.undofile = false
    end
  end,
})


vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  callback = function()
    if vim.b.bigfile then
      vim.bo.syntax = 'off'
      vim.bo.foldmethod = 'manual'
      pcall(vim.treesitter.stop, 0)
    end
  end,
})

-- Wipe stray empty buffers once a real file is open: `nvim` leaves a
-- `[No Name]` buffer, `nvim .` leaves a `.` directory buffer. neo-tree opens
-- files via bufadd() + `:b` (never :edit), so these leftovers stay listed
-- and show as stray tabs in bufferline.
vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup,
  callback = function()
    local cur = vim.api.nvim_get_current_buf()
    -- bufname() (not nvim_buf_get_name): the `nvim .` dir buffer is named
    -- '.' but get_name() resolves it to the absolute cwd path
    local curname = vim.fn.bufname(cur)
    if vim.bo[cur].buftype ~= '' or curname == '' or curname == '.' then
      return
    end
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.fn.bufname(bufnr)
      if
        bufnr ~= cur
        and vim.bo[bufnr].buftype == ''
        and not vim.bo[bufnr].modified
        and (name == '' or name == '.')
      then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
      end
    end
  end,
})

-- Live cmdline completion popup while typing (: / ?) — nvim 0.12
-- wildtrigger() + CmdlineChanged (see :h cmdline-autocompletion).
vim.api.nvim_create_autocmd('CmdlineChanged', {
  group = augroup,
  pattern = { ':', '/', '?' },
  callback = function()
    vim.cmd('call wildtrigger()')
  end,
})

-- PEP8 indentation for python
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = { 'python' },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})

-- Float diagnostics on hover (CursorHold)
vim.api.nvim_create_autocmd('CursorHold', {
  group = augroup,
  callback = function()
    if vim.b.bigfile or vim.bo.buftype ~= '' then
      return
    end
    if #vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.WARN } }) > 0 then
      vim.diagnostic.open_float(nil, { focusable = false, scope = 'line' })
    end
  end,
})

-- nvim-lint on save
vim.api.nvim_create_autocmd('BufWritePost', {
  group = augroup,
  callback = function()
    local ok, lint = pcall(require, 'lint')
    if ok then
      lint.try_lint()
    end
  end,
})

-- Close the neo-tree when it's the last window left (replaces neo-tree's
-- close_if_last_window, minus its modified-buffer guard that hijacks :wq —
-- vim's own E37 already protects unsaved buffers).
vim.api.nvim_create_autocmd('WinClosed', {
  group = augroup,
  callback = function(args)
    local closing_win = tonumber(args.match)
    local others = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if win ~= closing_win and vim.api.nvim_win_get_config(win).relative == '' then
        others[#others + 1] = win
      end
    end
    if #others ~= 1 then
      return
    end
    local remaining = others[1]
    local buf = vim.api.nvim_win_get_buf(remaining)
    if vim.bo[buf].filetype ~= 'neo-tree' then
      return
    end
    if vim.b[buf].neo_tree_position == 'current' then
      return -- split-style tree: closing it would close the file too
    end
    vim.schedule(function()
      pcall(vim.cmd, 'q!')
    end)
  end,
})
