-- Quick file pinning (harpoon-style). Mappings live in config/keymaps.lua.
return (function()
  vim.pack.add({
    { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
  })

  require('harpoon').setup()
end)()
