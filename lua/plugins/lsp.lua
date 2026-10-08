-- LSP: any language, lazily installed, warm, zero configuration.
--
-- How priority 1 + 3 + 4 are met:
--   * vim.lsp.config() (nvim 0.12 native) reads recipe defaults from
--     nvim-lspconfig's lsp/*.lua — no per-language settings here.
--   * mason.nvim owns the binaries. mason-lspconfig (v2) enables every
--     INSTALLED server automatically and enables servers again the moment
--     one finishes installing ("package:install:success" hook).
--   * On FileType we ask mason-lspconfig's filetype map which servers claim
--     the language. If a preferred one is installed we enable it (no-op when
--     already enabled); if the FIRST preferred one is missing we install it
--     in the background. Each filetype is memoized after its first hit, so
--     re-opening a file of the same language costs one table lookup (warm).
--   * nvim 0.12's vim.lsp.enable does NOT stop clients when their last
--     buffer closes (verified against `:h vim.lsp.enable` in 0.12.2): a
--     server keeps running for the whole session and a re-opened file of
--     the same language reuses the live process — no reload, no respawn.
--
-- Manual control stays available: :Mason (browse/install/remove),
-- :checkhealth mason / vim.lsp.

return (function()
  vim.pack.add {
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/williamboman/mason-lspconfig.nvim',
  }

  require('mason').setup {}

  -- ensure_installed stays EMPTY on purpose: installs are triggered by
  -- opening a file, never by a hardcoded list (priority 1).
  require('mason-lspconfig').setup {
    ensure_installed = {},
    -- every installed package with an lspconfig recipe auto-attaches
    automatic_enable = true,
  }

  -- blink.cmp must have been configured already (it loads earlier).
  -- One line of configuration for ALL servers — still zero per-language.
  vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
  })

  -- The single documented exception to "zero LSP configuration": lua_ls
  -- ships no default settings and must be told that `vim` is a known
  -- global and which runtime to index, otherwise every line of this config
  -- shows "Undefined global vim". Kept minimal (VIMRUNTIME + this config
  -- only): pointing it at get_runtime_file('', true) indexes every plugin
  -- and delayed first code_action by 30-60s (measured earlier).
  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = {
          library = { [vim.env.VIMRUNTIME] = true, [vim.fn.stdpath 'config'] = true },
          checkThirdParty = false,
        },
        diagnostics = { enable = true, globals = { 'vim' } },
      },
    },
  })

  -- ------------------------------------------------------------------
  -- Lazy install / enable engine
  -- ------------------------------------------------------------------

  local mappings = require 'mason-lspconfig.mappings'
  local registry
  local memo = {} -- filetype -> true once handled this session
  local installing = {} -- filetype -> true while an install is in flight

  -- Generic servers that would install on nearly every filetype and are
  -- never worth auto-installing on open. They remain one :Mason away.
  local GENERIC = {
    ast_grep = true,
    codebook = true,
    dprint = true,
    emmet_language_server = true,
    emmet_ls = true,
    eslint = true,
    harper_ls = true,
    htmx = true,
    ltex = true,
    ltex_plus = true,
    grammarly = true,
    oxfmt = true,
    oxlint = true,
    biome = true,
    snyk_ls = true,
    stylelint_lsp = true,
    symfony_lsp = true,
    tailwindcss = true,
    unocss = true,
    vale_ls = true,
    quick_lint_js = true,
    cssmodules_ls = true,
    css_variables = true,
    angularls = true,
    ember = true,
    glint = true,
    lwc_ls = true,
    denols = true,
    spectral = true,
    djls = true,
    pytest_language_server = true,
    ty = true,
    zuban = true,
    pyrefly = true,
    pylyzer = true,
    pyre = true,
  }

  -- The server this config prefers per filetype when the language has
  -- several. First entry installs first; later entries are enabled if
  -- already installed but never auto-downloaded. Everything NOT listed
  -- here still works: the fallback rule picks the first candidate left
  -- after the GENERIC filter (right for almost every language, which have
  -- exactly one canonical server).
  local PREFERRED = {
    lua = { 'lua_ls' },
    python = { 'pyright', 'ruff' }, -- pyright for types, ruff for lint/format
    javascript = { 'tsc' },
    typescript = { 'tsc' },
    typescriptreact = { 'tsc' },
    javascriptreact = { 'tsc' },
    json = { 'jsonls' },
    html = { 'html' },
    css = { 'cssls' },
    markdown = { 'marksman' },
    yaml = { 'yamlls' },
    go = { 'gopls' },
    rust = { 'rust_analyzer' },
    c = { 'clangd' },
    cpp = { 'clangd' },
    objc = { 'clangd' },
    bash = { 'bashls' },
    sh = { 'bashls' },
    java = { 'jdtls' },
    zig = { 'zls' },
    vue = { 'vue_ls' },
    svelte = { 'svelte' },
    toml = { 'taplo' },
    dart = { 'dartls' },
  }

  local function notify(msg, level) vim.notify(msg, level or vim.log.levels.INFO, { title = 'LSP auto-install' }) end

  local function lspconfig_to_package(server_name)
    local map = mappings.get_mason_map().lspconfig_to_package
    return map[server_name]
  end

  -- Server candidates for one filetype (GENERIC junk removed).
  local function candidates_for(ft)
    local map = mappings.get_filetype_map()
    local cands = {}
    for _, name in ipairs(map[ft] or {}) do
      if not GENERIC[name] and not vim.list_contains(cands, name) then cands[#cands + 1] = name end
    end
    return cands
  end

  local function ensure(ft, bufnr)
    vim.schedule(function()
      if type(ft) ~= 'string' or ft == '' or memo[ft] then return end
      memo[ft] = true

      if registry == nil then
        local ok, reg = pcall(require, 'mason-registry')
        if not ok then
          return -- mason not loaded yet; next FileType try again
        end
        registry = ok and reg
      end

      local cands = candidates_for(ft)
      local prefs = PREFERRED[ft] or {}
      -- Preferred entries first (they are recipe names too, but the generic
      -- map may not know them); then the heuristic fallback for languages
      -- not in PREFERRED.
      local ordered = {}
      for _, name in ipairs(prefs) do
        if vim.tbl_contains(cands, name) or lspconfig_to_package(name) then ordered[#ordered + 1] = name end
      end
      for _, name in ipairs(cands) do
        if not vim.tbl_contains(ordered, name) then ordered[#ordered + 1] = name end
      end
      if ordered[1] == nil then
        return -- no server for this language
      end

      -- Pass 1 — enable everything usable right now (warm: no-op when
      -- already enabled). Future buffers of this language attach
      -- automatically; nvim does not restart or stop the server.
      for _, name in ipairs(ordered) do
        if not vim.lsp.is_enabled(name) then
          local pkg_name = lspconfig_to_package(name)
          if pkg_name then
            local pkg = registry.get_package(pkg_name)
            if pkg and pkg:is_installed() then vim.lsp.enable(name) end
          end
        end
      end

      -- Pass 2 — lazy-install exactly ONE server for this language, in
      -- the background: the first preferred entry that is neither enabled
      -- nor installed; for languages without a preference, the first such
      -- candidate. mason-lspconfig enables it — and then every buffer of
      -- this filetype, open or future — on install success.
      local list = #prefs > 0 and prefs or ordered
      local pending = nil
      for _, name in ipairs(list) do
        if not vim.lsp.is_enabled(name) then
          local pkg_name = lspconfig_to_package(name)
          local pkg = pkg_name and registry.get_package(pkg_name)
          if pkg and not pkg:is_installed() then
            pending = { name = name, pkg = pkg }
            break
          end
        end
      end
      if pending and vim.api.nvim_buf_is_valid(bufnr) and not installing[ft] then
        installing[ft] = true
        local name = pending.name
        notify(('Installing %s (detected %s file %s)...'):format(name, ft, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')))
        local ok, err = pcall(function()
          -- The callback fires from a libuv (fast-event) context: wrap in
          -- vim.schedule_wrap so notify() + enable() are safe.
          pending.pkg:install(
            {},
            vim.schedule_wrap(function(success)
              installing[ft] = nil
              if success then
                notify(('%s installed — the %s server is live.'):format(name, ft))
                -- Enable is idempotent and wires every existing + future
                -- buffer of this filetype. Belt-and-braces: mason-lspconfig
                -- does this via its install-success hook too.
                if not vim.lsp.is_enabled(name) then vim.lsp.enable(name) end
              else
                notify(('Failed to install %s. Run :Mason, then :MasonLog for details.'):format(name), vim.log.levels.ERROR)
              end
            end)
          )
        end)
        if not ok then
          installing[ft] = nil
          notify(('Could not start installing %s (run :Mason manually): %s'):format(name, err), vim.log.levels.WARN)
        end
      end
    end)
  end

  -- FileType fires for nvim's startup arguments too, so files opened from
  -- the command line are covered by the same single autocmd.
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('UserLsp', { clear = true }),
    callback = function(args)
      if vim.b.bigfile then return end
      ensure(args.match, args.buf)
    end,
  })

  -- ------------------------------------------------------------------
  -- VSCode-parity polish
  -- ------------------------------------------------------------------

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if vim.b.bigfile or vim.g.inlay_hints_enabled == false then return end
      -- Inlay hints on by default for every attached server; <leader>ci toggles.
      if client and client:supports_method 'textDocument/inlayHint' then vim.lsp.inlay_hint.enable(true, { bufnr = args.buf }) end
      -- Upgrade folding to the LSP provider when the server offers
      -- foldingRange. Base provider is treesitter foldexpr
      -- (config/options.lua). Pattern straight from :h vim.lsp.foldexpr;
      -- folding is window-local, so every window showing this buffer is
      -- covered. Later windows fall back to the treesitter default.
      if client and client:supports_method 'textDocument/foldingRange' then
        for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
          vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end
      end
    end,
  })

  -- Diagnostics: inline virtual text, gutter signs, float on demand
  -- (<leader>cd), shows the source name. Matches VSCode's inline display.
  vim.diagnostic.config {
    virtual_text = { prefix = '●', spacing = 4, source = 'if_many' },
    signs = true,
    underline = true,
    update_in_insert = false,
    float = { border = 'rounded', source = true },
    severity_sort = true,
  }
end)()
