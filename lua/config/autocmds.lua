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
-- Skip re-trigger while a popup item is SELECTED: cycling with Tab updates
-- the cmdline, which fires CmdlineChanged again — re-triggering then resets
-- the selection and Tab appeared to "not cycle". Typing sets selected=-1,
-- so the list still refreshes on normal keystrokes.
vim.api.nvim_create_autocmd('CmdlineChanged', {
  group = augroup,
  pattern = { ':', '/', '?' },
  callback = function()
    local info = vim.fn.cmdcomplete_info()
    if vim.fn.wildmenumode() == 1 and (info.selected or -1) ~= -1 then
      return
    end
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

-- Float diagnostics popup removed: errors are shown inline (virtual_text)
-- now; `<leader>cd` opens the full diagnostics float on demand.

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

-- Quit handling. Two distinct triggers, two handlers:
--   * BufDelete  -> tab close (x on the tab = :bd). :q/:wq never delete buffers.
--   * WinClosed  -> a window closed (:q/:wq/ZZ on the last file window). nvim
--                   would stay because the tree window survives — exit instead.
-- Both ignore startup: the netrw hijack on `nvim .` deletes the directory
-- buffer / juggles windows while vim.v.vim_did_enter == 0.

local function is_real_file_buf(bufnr)
  local name = vim.fn.bufname(bufnr)
  if name == '' or name == '.' then
    return false
  end
  if vim.bo[bufnr].buftype ~= '' or vim.bo[bufnr].filetype == 'neo-tree' then
    return false
  end
  return vim.fn.isdirectory(vim.fn.fnamemodify(name, ':p')) ~= 1
end

-- :q / :wq / ZZ on the last file window -> the file window closes, only the
-- tree remains -> quit nvim. The tree never blocks a quit.
-- qa (not qa!) keeps E37 protection: if a hidden buffer is modified, quit is
-- refused — and we fall back to showing that buffer instead of leaving the
-- user stranded on the tree.
vim.api.nvim_create_autocmd('WinClosed', {
  group = augroup,
  callback = function(args)
    if vim.v.vim_did_enter == 0 then
      return -- startup hijack window juggling
    end
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
      local ok, err = pcall(vim.cmd, 'qa')
      if not ok then
        vim.notify('Could not quit: ' .. tostring(err), vim.log.levels.WARN, {
          title = 'UserConfig',
        })
        -- E37 (unsaved changes): show the modified buffer instead of the tree
        for _, n in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[n].modified and is_real_file_buf(n) then
            pcall(vim.cmd.buffer, n)
            break
          end
        end
      end
    end)
  end,
})

-- Wipe leftover special buffers (help / checkhealth / scratch) after their
-- window closes. Core nvim closes the tabpage correctly, but the special
-- buffer stays LISTED and shows as an empty-looking tab in bufferline
-- (LazyVim #4638, neovim PR #31865). Never touches real file buffers.
vim.api.nvim_create_autocmd('WinClosed', {
  group = augroup,
  callback = function()
    vim.schedule(function()
      for _, n in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.fn.bufname(n)
        local bt = vim.bo[n].buftype
        if
          vim.api.nvim_buf_is_valid(n)
          and vim.fn.bufwinid(n) == -1 -- not displayed anywhere
          and not vim.bo[n].modified
          and (
            (bt ~= '' and bt ~= 'quickfix' and bt ~= 'terminal')
            or name:match('^%[')
          )
        then
          pcall(vim.api.nvim_buf_delete, n, { force = true })
        end
      end
    end)
  end,
})

-- Neo-tree opens files via bufadd() which creates UNLISTED buffers (and
-- bufadd doesn't fire BufAdd). An unlisted current file means :bd leaves no
-- listed buffer -> the window closes -> nvim quits on a single tab close.
-- Mark real file buffers listed whenever they're read/displayed.
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'BufReadPost' }, {
  group = augroup,
  callback = function()
    for _, n in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.fn.bufname(n) ~= ''
        and vim.bo[n].buftype == ''
        and vim.bo[n].filetype ~= 'neo-tree'
        and not vim.bo[n].buflisted
      then
        vim.bo[n].buflisted = true
      end
    end
  end,
})

-- Tab close (x on the tab = :bd). After the wipe, if the window fell back
-- to the neo-tree buffer or an empty buffer, show the most-recently-used
-- real file; if no file buffers remain (last tab), quit nvim.
-- Switching buffers BEFORE the wipe (inside BufDelete) perturbed nvim mid-
-- delete and closed the whole session; everything here runs scheduled, after
-- the wipe completes.
-- Remaining files found via nvim_list_bufs() (unlisted included — neo-tree
-- bufadd'd files can be unlisted, so a buflisted filter would falsely quit).
vim.api.nvim_create_autocmd('BufDelete', {
  group = augroup,
  callback = function(args)
    if vim.v.vim_did_enter == 0 then
      return -- startup hijack deletes the '.' directory buffer
    end
    local deleted = args.buf
    if not is_real_file_buf(deleted) then
      return -- not a real file (scratch/dir/terminal/tree)
    end
    vim.schedule(function()
      local cur = vim.api.nvim_get_current_buf()
      if is_real_file_buf(cur) then
        return -- nvim already landed on another file
      end

      -- most-recently-used real file buffer other than the deleted one
      local target, mru = nil, 0
      for _, n in ipairs(vim.api.nvim_list_bufs()) do
        if n ~= deleted and is_real_file_buf(n) then
          local used = vim.fn.getbufinfo(n)[1].lastused or 0
          if used > mru then
            mru = used
            target = n
          end
        end
      end
      if not target then
        local ok, err = pcall(vim.cmd, 'qa') -- last file tab closed -> quit
        if not ok then
          vim.notify('Could not quit: ' .. tostring(err), vim.log.levels.WARN, {
            title = 'UserConfig',
          })
        end
        return
      end

      -- put the file in a window that shows the tree/empty fallback (not the
      -- tree sidebar), falling back to the current window
      local win = vim.api.nvim_get_current_win()
      for _, w in ipairs(vim.api.nvim_list_wins()) do
        local wb = vim.api.nvim_win_get_buf(w)
        if vim.bo[wb].filetype ~= 'neo-tree' and not is_real_file_buf(wb) then
          win = w
          break
        end
      end
      pcall(vim.api.nvim_win_set_buf, win, target)
    end)
  end,
})
