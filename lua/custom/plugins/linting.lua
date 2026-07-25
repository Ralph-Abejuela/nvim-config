-- nvim-lint: Async linting engine with Mason integration
-- https://github.com/mfussenegger/nvim-lint
-- Linters are installed via Mason (mason-tool-installer in init.lua)

vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'

-- Map filetypes to linters
lint.linters_by_ft = {
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
  python = { 'ruff' },
  go = { 'golangci-lint' },
  rust = { 'clippy' },
  json = { 'jsonlint' },
  yaml = { 'yamllint' },
  markdown = { 'markdownlint' },
  dockerfile = { 'hadolint' },
  lua = { 'selene' },
  css = { 'stylelint' },
  scss = { 'stylelint' },
  html = { 'htmlhint' },
  sh = { 'shellcheck' },
  bash = { 'shellcheck' },
}

-- Create autocommand for linting on save/insert leave
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})

-- Keymap to manually trigger linting
vim.keymap.set('n', '<leader>cl', function() lint.try_lint() end, { desc = '[C]ode [L]int' })
