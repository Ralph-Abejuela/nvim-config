-- Treesitter: highlight + indent for project languages
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.config', -- master renamed configs.lua -> config.lua
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      ensure_installed = {
        'lua', 'vim', 'vimdoc',
        'javascript', 'typescript', 'tsx',
        'python',
        'html', 'css', 'json', 'markdown', 'yaml', 'bash',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
