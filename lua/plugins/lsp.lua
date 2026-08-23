-- LSP: mason installs servers, lspconfig recipes + vim.lsp.enable attach them
return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {},
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      -- valid names: tsc = TypeScript 7 Go compiler ('tsgo' is a deprecated
      -- alias — mason marks the native-preview package deprecated)
      ensure_installed = { 'lua_ls', 'tsc', 'pyright' },
      automatic_installation = true,
      -- only vim.lsp.enable() in the config below attaches servers; without
      -- this, every installed package with a recipe auto-attaches (leftover
      -- ts_ls/vtsls/tsgo packages from older configs would all start)
      automatic_enable = false,
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- blink must load first so get_lsp_capabilities() exists
      'saghen/blink.cmp',
    },
    config = function()
      -- capabilities for every server (blink completion items)
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      -- lua_ls: know the nvim runtime
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },
            checkThirdParty = false,
          },
        },
      })

      -- TypeScript: use 'tsc' (the supported lspconfig name for the
      -- TypeScript 7 Go compiler; 'tsgo' is a deprecated alias). The tsc
      -- recipe handles binary resolution (node_modules/.bin/tsc or PATH,
      -- requires TS 7.0+ for --lsp), monorepo root detection and server
      -- settings. No custom recipe needed.

      -- install via mason, attach via vim.lsp.enable (0.11+ framework).
      -- Server options live in the mason-lspconfig spec opts above.
      vim.lsp.enable({ 'lua_ls', 'tsc', 'pyright' })

      -- inlay hints always on for every attached server
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          if vim.b.bigfile then
            return
          end
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method('textDocument/inlayHint') then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })

      -- diagnostics: signs in gutter, float on hover (CursorHold in config/autocmds.lua)
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        float = { border = 'rounded' },
      })
    end,
  },
}
