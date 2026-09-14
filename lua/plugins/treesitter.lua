-- Treesitter: highlight + indent for project languages.
-- Pinned to the legacy `master` branch: the rewritten `main` branch dropped
-- ensure_installed/opts-style setup and would need a full config rewrite.
return (function()
  vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
  })

  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'lua', 'vim', 'vimdoc',
      'javascript', 'typescript', 'tsx',
      'python',
      'html', 'css', 'json', 'markdown', 'yaml', 'bash',
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  })
end)()
