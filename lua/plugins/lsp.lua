-- LSP: mason installs servers, lspconfig recipes + vim.lsp.enable attach them.
-- blink.cmp is already loaded (plugins/blink-cmp.lua runs earlier in init.lua).
return (function()
  vim.pack.add({
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/williamboman/mason-lspconfig.nvim',
  })

  require('mason').setup({})

  require('mason-lspconfig').setup({
    -- valid names: tsc = TypeScript 7 Go compiler ('tsgo' is a deprecated
    -- alias — mason marks the native-preview package deprecated)
    ensure_installed = { 'lua_ls', 'tsc', 'pyright' },
    automatic_installation = true,
    -- every installed package with an lspconfig recipe auto-attaches
    automatic_enable = true,
  })

  -- capabilities for every server (blink completion items)
  vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
  })

  -- lua_ls: know the nvim runtime + enable diagnostics (some builds
  -- publish nothing without this) and mark 'vim' as a known global
  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        checkThirdParty = false,
        diagnostics = {
          enable = true,
          globals = { 'vim' },
        },
      },
    },
  })

  -- TypeScript: use 'tsc' (the supported lspconfig name for the
  -- TypeScript 7 Go compiler; 'tsgo' is a deprecated alias). The tsc
  -- recipe handles binary resolution (node_modules/.bin/tsc or PATH,
  -- requires TS 7.0+ for --lsp), monorepo root detection and server
  -- settings. No custom recipe needed.
  vim.lsp.enable('tsc')

  vim.lsp.enable('basedpyright')
  vim.lsp.enable('ruff')

  vim.lsp.config('astro', {
    before_init = function(_, config)
      local util = require('lspconfig.util')
      -- TS 7 (Go) installs have no lib/typescript.js, which astro-ls
      -- requires — treat those as missing and fall back to pnpm global
      local tsdk = util.get_typescript_server_path(config.root_dir)
      if tsdk == '' or not vim.uv.fs_stat(tsdk .. '/typescript.js') then
        local npm_root = vim.fn.systemlist('pnpm root -g')
        if vim.v.shell_error == 0 and npm_root[1] then
          tsdk = npm_root[1] .. '/typescript/lib'
        end
      end
      config.init_options = config.init_options or {}
      config.init_options.typescript = config.init_options.typescript or {}
      config.init_options.typescript.tsdk = tsdk
    end,
  })

  -- inlay hints on by default for every attached server;
  -- `<leader>ci` toggles via vim.g.inlay_hints_enabled
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      if vim.b.bigfile or vim.g.inlay_hints_enabled == false then
        return
      end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client:supports_method('textDocument/inlayHint') then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end
    end,
  })

  -- Diagnostics: inline virtual text (disabled by default in nvim),
  -- gutter signs, float on hover (CursorHold in config/autocmds.lua)
  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      spacing = 4,
      source = 'if_many',
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    float = { border = 'rounded' },
  })
end)()
