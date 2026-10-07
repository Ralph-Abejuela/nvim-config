-- Treesitter: highlighting + indent, same lazy philosophy as LSP:
-- the parser for a language installs on the FIRST file of that language,
-- in the background, and is cached afterwards.
-- Uses the rewritten `main` branch (frozen `master` does not support 0.12).
-- Requires `tree-sitter` CLI and a C compiler in PATH (both present here).
return (function()
  vim.pack.add {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  }

  local ts = require 'nvim-treesitter'
  local pending = {} -- lang -> install already kicked off

  local function attach(bufnr)
    -- start() throws when no parser exists for the filetype, which also
    -- gates the indentexpr below.
    if pcall(vim.treesitter.start, bufnr) then vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local function ensure_parser(lang, bufnr)
    if pending[lang] then return end
    pending[lang] = true
    vim.notify('Installing treesitter parser for ' .. lang .. '…', vim.log.levels.INFO, { title = 'Parser' })
    -- install() is async: .await() registers a completion callback.
    ts.install({ lang }):await(function(err)
      vim.schedule(function()
        if err then
          vim.notify(('Parser for %s failed to install: %s (run :TSInstall %s to retry)'):format(lang, err, lang), vim.log.levels.WARN, { title = 'Parser' })
          pending[lang] = nil
          return
        end
        if vim.api.nvim_buf_is_valid(bufnr) then attach(bufnr) end
      end)
    end)
  end

  -- Startup buffers keep the same lazy path: nothing is pre-installed.
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
    callback = function(args)
      if vim.b.bigfile then return end
      local lang = vim.treesitter.language.get_lang(args.match) or args.match
      -- pcall: language.add() errors when the parser is not installed yet
      local ok = pcall(vim.treesitter.language.add, lang)
      if ok then
        attach(args.buf)
      else
        ensure_parser(lang, args.buf)
      end
    end,
  })
end)()
