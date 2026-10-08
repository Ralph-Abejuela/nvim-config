-- Command-first LSP interface: for people who'd rather type `:LspRename`
-- than learn `gd`/`gr` muscle memory. Every command works only while a
-- language server is running for the buffer, and is described in plain
-- English (:h command-desc keeps them in :command and which-key lists).

local function client_names(bufnr)
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    names[#names + 1] = client.name
  end
  return table.concat(names, ', ')
end

local commands = {
  { 'LspDef', vim.lsp.buf.definition, 'Go to where this symbol is defined' },
  { 'LspReferences', vim.lsp.buf.references, 'Find all places this symbol is used' },
  { 'LspImplementation', vim.lsp.buf.implementation, 'Go to implementation' },
  { 'LspHover', vim.lsp.buf.hover, 'Hover: show docs / type info' },
  { 'LspRename', vim.lsp.buf.rename, 'Rename the symbol under the cursor (project-wide)' },
  { 'LspCodeActions', vim.lsp.buf.code_action, 'Quick fixes and refactorings' },
  { 'LspFormat', function() vim.lsp.buf.format { async = true } end, 'Format this file with the language server' },
  {
    'LspDiagnostics',
    vim.diagnostic.open_float,
    'Show the full error/warning for the current line',
  },
  {
    'LspStatus',
    function() print('Attached language servers: ' .. (client_names(0) == '' and '(none yet)' or client_names(0))) end,
    'Show which language servers are warm for this buffer',
  },
}

for _, cmd in ipairs(commands) do
  vim.api.nvim_create_user_command(cmd[1], cmd[2], { desc = cmd[3] })
end
