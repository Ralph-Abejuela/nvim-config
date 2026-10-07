-- Autocmds. Runs eagerly.

local augroup = vim.api.nvim_create_augroup('UserConfig', { clear = true })

-- Big-file guard: >2MB disables treesitter/folding/undo
vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' }, {
  group = augroup,
  callback = function(ev)
    local f = vim.fn.expand '<afile>'
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

-- Briefly highlight yanked text (like VSCode's selection flash)
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  callback = function() vim.hl.on_yank { timeout = 200 } end,
})

-- PEP8: python uses 4-space indent even though the global default is 2
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = { 'python' },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})

-- Live cmdline completion popup while typing (/ and ? only) — nvim 0.12
-- wildtrigger. ':' is owned by blink.cmp (plugins/blink-cmp.lua).
-- Skip re-trigger while an item is SELECTED: cycling with Tab updates the
-- cmdline (CmdlineChanged again); re-triggering would reset the selection.
vim.api.nvim_create_autocmd('CmdlineChanged', {
  group = augroup,
  pattern = { '/', '?' },
  callback = function()
    local info = vim.fn.cmdcomplete_info()
    if vim.fn.wildmenumode() == 1 and (info.selected or -1) ~= -1 then return end
    vim.cmd 'call wildtrigger()'
  end,
})
