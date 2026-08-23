-- Completion: blink.cmp + LuaSnip (snippets from friendly-snippets)
return {
  {
    'saghen/blink.cmp',
    version = 'v1.*', -- v2 on master needs separate blink.lib; v1 is stable + matches opts
    event = 'InsertEnter',
    dependencies = {
      'L3MON4D3/LuaSnip',
      {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    opts = {
      keymap = {
        preset = 'default',
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
    },
  },
}
