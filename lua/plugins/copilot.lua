-- AI: GitHub Copilot inline suggestions
return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      vim.g.copilot_no_tab_map = true -- Tab stays blink.cmp's
      vim.g.copilot_assume_mapped = true
      vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept-word)')
      vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-next)')
    end,
  },
}
