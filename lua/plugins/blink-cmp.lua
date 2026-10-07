-- Completion: blink.cmp + LuaSnip (snippets from friendly-snippets).
-- Priorities 7 + 8 live here: snippets on every language, and a sort order
-- that puts the most USEFUL candidates first.
-- blink.cmp must load before plugins/lsp.lua, which asks for capabilities.
return (function()
  vim.pack.add {
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/rafamadriz/friendly-snippets',
    {
      src = 'https://github.com/saghen/blink.cmp',
      version = vim.version.range '1.*',
    },
  }

  -- Priority 8: useful sorting of completion items.
  -- blink applies `fuzzy.sorts` in order; each sort only decides when the
  -- previous one says the two items tie:
  --   1. 'exact'  — an exact match for what you typed always wins
  --   2. 'score'  — fuzzy score with frecency (things you used recently)
  --                 and proximity (words near the cursor) bonuses
  --   3. below    — items with the same score: more "valuable" kinds
  --                 (fields/variables/methods/functions) before filler
  --                 (keywords/text/properties from un-typed code)
  --   4. 'sort_text' — the server's own preference as last tie-break
  local KIND_RANK = {
    [5] = 1, -- Field
    [6] = 1, -- Variable
    [10] = 2, -- Property
    [2] = 3, -- Method
    [3] = 3, -- Function
    [4] = 3, -- Constructor
    [7] = 4, -- Class
    [13] = 4, -- Enum
    [22] = 4, -- Struct
    [8] = 5, -- Interface
    [9] = 5, -- Module
    [15] = 6, -- Snippet
    [19] = 7, -- Folder
    [21] = 7, -- Event
    [23] = 8, -- File
    [1] = 9, -- Text
    [12] = 10, -- Value
    [17] = 10, -- Color
    [25] = 11, -- Keyword
  }

  require('blink.cmp').setup {
    keymap = {
      -- 'super-tab': Tab accepts / jumps snippet placeholders / inserts a
      -- real Tab when no menu is open; Shift-Tab goes back in menu
      preset = 'super-tab',
      -- C-Space opens the menu; alternatives because some terminals eat it
      ['<C-;>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-g>'] = { 'show', 'show_documentation', 'hide_documentation' },
      -- Ctrl-arrow / Ctrl-J/K also navigate the menu when open
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
    },
    sources = {
      -- order is priority on equal fuzzy scores; path/snippets/buffer stay
      -- so editing works even before a language server exists
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = {
      sorts = {
        'exact',
        'score',
        function(a, b) -- tie: rank by completion-item kind (see table above)
          if a.kind == nil or b.kind == nil or a.kind == b.kind then return nil end
          return (KIND_RANK[a.kind] or 99) < (KIND_RANK[b.kind] or 99)
        end,
        'sort_text',
      },
    },
    completion = {
      trigger = { show_on_keyword = true },
      documentation = {
        auto_show = true, -- docs pane beside the menu, like VSCode IntelliSense
        window = { border = 'rounded' },
      },
      menu = { draw = { columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } } } },
    },
    signature = {
      enabled = true, -- parameter popup while typing call arguments
      window = { border = 'rounded' },
    },
    appearance = { nerd_font_variant = 'mono' },
    -- Cmdline completion is owned by blink (VSCode-style: menu pops as you
    -- type a command, Tab cycles). The native wildtrigger popup stays for
    -- / and ? only (see config/autocmds.lua) — the two systems fought over
    -- the popup otherwise and Tab cycling broke.
    cmdline = {
      keymap = {
        ['<Tab>'] = { 'show_and_insert_or_accept_single', 'select_next' },
        ['<S-Tab>'] = { 'show_and_insert_or_accept_single', 'select_prev' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<Right>'] = { 'select_next', 'fallback' },
        ['<Left>'] = { 'select_prev', 'fallback' },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },
      },
      completion = {
        menu = {
          auto_show = function(_) return vim.fn.getcmdtype() == ':' end,
        },
      },
    },
  }

  -- Load friendly-snippets into LuaSnip (after blink's snippet preset is
  -- set). Off the critical path: costs ~45ms and is not needed until the
  -- first completion, so it runs just after startup completes.
  vim.schedule(function() require('luasnip.loaders.from_vscode').lazy_load() end)
end)()
