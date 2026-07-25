-- Neo-tree: Sidebar file explorer with git status, icons, filtering
-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- Press <leader>e to toggle, \ to reveal current file

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

-- ponytail: workaround for neo-tree #1931 — :q! on modified buffer blocks close
-- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1931#issuecomment-2748292018
local neotree_utils = require('neo-tree.utils')
local _force_quitting_buf = nil
vim.api.nvim_create_autocmd('CmdlineLeave', {
  callback = function()
    if vim.fn.getcmdtype() ~= ':' then
      return
    end
    if vim.fn.getcmdline():match('^%s*q!$') then
      _force_quitting_buf = vim.api.nvim_get_current_buf()
      vim.schedule(function()
        _force_quitting_buf = nil
      end)
    end
  end,
})
local orig_get_opened_buffers = neotree_utils.get_opened_buffers
neotree_utils.get_opened_buffers = function()
  if _force_quitting_buf == nil then
    return orig_get_opened_buffers()
  end
  local bufs = orig_get_opened_buffers()
  local buf_name = vim.api.nvim_buf_get_name(_force_quitting_buf)
  if buf_name == nil or buf_name == '' then
    buf_name = '[No Name]#' .. _force_quitting_buf
  end
  bufs[buf_name] = nil
  return bufs
end

require('neo-tree').setup {
  close_if_last_window = true,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        '.git',
        'node_modules',
      },
      never_show = {},
    },
    window = {
      mappings = {
        ['\\'] = 'close_window',
        ['<leader>e'] = 'close_window',
      },
    },
  },
  default_component_configs = {
    indent = { with_markers = false },
    icon = { folder_closed = '', folder_open = '', folder_empty = '' },
  },
}

-- Toggle neo-tree
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = '[E]xplore toggle (Neo-tree)' })

-- Reveal current file in neo-tree
vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'Neo-tree: reveal current file' })
