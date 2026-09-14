-- AI: GitHub Copilot inline suggestions
return (function()
  -- must be set before copilot's plugin/ scripts are sourced by add()
  vim.g.copilot_no_tab_map = true -- Tab stays blink.cmp's
  vim.g.copilot_assume_mapped = true

  vim.pack.add({ 'https://github.com/github/copilot.vim' })

  vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept-word)')
  vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-next)')
end)()
