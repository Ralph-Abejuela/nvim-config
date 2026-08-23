-- Formatting (conform) + linting (nvim-lint). Format on keybind only, never on save.
return {
  {
    'stevearc/conform.nvim',
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({ lsp_fallback = true })
        end,
        desc = 'Format',
      },
    },
    opts = {
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
    },
  },
  -- Ensures stylua / ruff / prettier binaries via mason
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    cmd = 'MasonToolsInstall',
    opts = {
      ensure_installed = { 'stylua', 'ruff', 'prettierd' },
      auto_update = false,
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- no setup() in nvim-lint; assign linters_by_ft directly
      require('lint').linters_by_ft = {
        python = { 'ruff' },
      }
    end,
  },
}
