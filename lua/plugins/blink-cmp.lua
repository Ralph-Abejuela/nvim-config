-- Completion: blink.cmp + LuaSnip (snippets from friendly-snippets).
-- blink.cmp must load before lsp.lua, which asks it for LSP capabilities.
return (function()
  vim.pack.add({
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/rafamadriz/friendly-snippets',
    {
      src = 'https://github.com/saghen/blink.cmp',
      -- v2 on master needs separate blink.lib; v1 is stable + matches opts
      version = vim.version.range('1.*'),
    },
  })

  require('blink.cmp').setup({
    keymap = {
      -- 'super-tab': <Tab> accepts the completion (or jumps snippet
      -- placeholders), falls back to a literal Tab when nothing is open
      preset = 'super-tab',
      -- alternatives to <C-Space> (WT may not deliver it everywhere):
      -- <C-;> via kitty protocol, <C-g> byte-level (works in any terminal)
      ['<C-;>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-g>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    snippets = { preset = 'luasnip' },
    completion = {
      trigger = {
        show_on_keyword = true, -- auto-open while typing (default; explicit)
      },
      documentation = { auto_show = true },
    },
    signature = {
      enabled = true, -- auto-open param popup while typing call args
      window = { border = 'rounded' },
    },
    appearance = {
      use_nvim_cmp_as_default = false, -- v1 renamed from ..._matching
      nerd_font_variant = 'mono',
    },
    -- Cmdline completion is owned by blink (VSCode-style: menu pops up as
    -- you type a command, Tab cycles). The native wildtrigger live popup is
    -- disabled for ':' (see autocmds.lua) — the two systems fought over the
    -- popup and Tab cycling never worked.
    cmdline = {
      completion = {
        menu = {
          auto_show = function(_)
            return vim.fn.getcmdtype() == ':'
          end,
        },
      },
    },
  })

  -- Load friendly-snippets into LuaSnip (after blink's snippet preset is set)
  require('luasnip.loaders.from_vscode').lazy_load()
end)()
