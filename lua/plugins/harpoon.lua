-- Quick file pinning (harpoon-style)
return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    keys = {
      {
        '<leader>a',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Harpoon add',
      },
      {
        '<leader>h',
        function()
          require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
        end,
        desc = 'Harpoon menu',
      },
    },
    config = function()
      require('harpoon').setup()
    end,
  },
}
