-- Sessions: auto save/restore per project dir
return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
  },
}
