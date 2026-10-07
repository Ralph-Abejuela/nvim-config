-- Zero-plugin statusline. Shows, left to right:
--   mode · file (modified/readonly flags) · diagnostics · LSP server names
-- The LSP section doubles as the "warm LSP" indicator: the server name
-- appears the first time a server attaches and stays afterwards.

local function status()
  local mode = vim.api.nvim_get_mode().mode
  local mode_names = {
    n = 'NORMAL',
    i = 'INSERT',
    v = 'VISUAL',
    V = 'V-LINE',
    ['\22'] = 'V-BLOCK',
    c = 'COMMAND',
    t = 'TERM',
    R = 'REPLACE',
    s = 'SELECT',
  }

  local counts = vim.diagnostic.count(0) -- severity-number → count
  local e, w = counts[1] or 0, counts[2] or 0
  local diag = e + w > 0 and (' [E%d W%d]'):format(e, w) or ''

  local clients = vim.lsp.get_clients { bufnr = 0 }
  local names = {}
  for _, client in ipairs(clients) do
    names[#names + 1] = client.name
  end
  local lsp = #names > 0 and (' [%s]'):format(table.concat(names, ', ')) or ''

  local flags = ((vim.bo.modified and '+') or '') .. ((not vim.bo.modifiable and vim.bo.readonly and 'RO') or '')
  local name = vim.fn.expand '%:t'
  if name == '' then name = '[No Name]' end

  -- %l/%L are statusline tokens (line / total-lines), appended after the
  -- string.format() so :format doesn't see them as invalid specifiers.
  return ('%s %s%s%s%s'):format(mode_names[mode] or mode, name, flags, diag, lsp) .. ' %l:%L '
end

vim.o.statusline = '%!v:lua.status()'
_G.status = status
