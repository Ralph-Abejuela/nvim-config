-- Formatting (conform) + linting (nvim-lint). Format on keybind only
-- (<leader>cf, defined in config/keymaps.lua), never on save.
return (function()
  vim.pack.add({
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim', -- needs mason (lsp.lua)
    'https://github.com/mfussenegger/nvim-lint',
  })

  require('conform').setup({
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      markdown = { 'prettierd' },
      yaml = { 'prettierd' },
    },
  })

  -- Ensures stylua / ruff / prettier binaries via mason
  require('mason-tool-installer').setup({
    ensure_installed = { 'stylua', 'ruff', 'prettierd' },
    auto_update = false,
  })

  -- no setup() in nvim-lint; assign linters_by_ft directly
  require('lint').linters_by_ft = {
    python = { 'ruff' },
  }
end)()
