-- Editor options. Runs eagerly at startup (no plugins).

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.showmode = false -- mode already shown in the statusline
opt.breakindent = true
opt.undofile = true -- persistent undo across restarts
opt.swapfile = false -- undo is enough; no swap prompts / leftovers
opt.hidden = true -- switching buffers never loses changes (VSCode-like)
opt.clipboard = 'unnamedplus' -- yank goes to the system clipboard

-- Windows-only: pin the clipboard provider so nvim's auto-detection can't
-- pick AMD's lemonade.exe (LLM server on PATH) as the clipboard tool, which
-- made `yy` error with "error invoking 'lemonade'". Other systems keep
-- default detection (pbcopy/wl-copy/xclip/etc.).
if vim.fn.has 'win32' == 1 then
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
end

opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes' -- reserve space; no layout shift when diagnostics appear
opt.updatetime = 250 -- faster hover/diagnostic responses
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.inccommand = 'split' -- live preview of :s substitutions
opt.cursorline = true
opt.scrolloff = 8
opt.termguicolors = true

-- Folding, exactly as :h vim.lsp recommends:
--   expr-based evaluation with treesitter levels as the base provider —
--   works anywhere a parser exists (which treesitter installs lazily per
--   language); an LspAttach autocmd (plugins/lsp.lua) upgrades buffers
--   served by a foldingRange-capable server to vim.lsp.foldexpr().
-- Everything starts unfolded, like VSCode.
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99
opt.foldcolumn = 'auto:1'

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Skip the python/ruby/perl/tcl/node provider bridges entirely: no config
-- feature uses them, and opening a .py file otherwise pays a ~0.7s probe
-- of provider/python3.vim (measured via --startuptime).
-- Same effect: vim.g.loaded_python3_provider = 0 etc.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_tcl_provider = 0
vim.g.loaded_node_provider = 0

-- Command-line completion popup while typing in / and ? (nvim 0.12
-- wildtrigger). ':' completion is owned by blink.cmp instead.
opt.wildmenu = true
opt.wildmode = 'noselect:lastused,full'
opt.wildoptions = 'pum'

-- NOTE: shell stays default (cmd) — pwsh shellcmdflag/shellredir break
-- vim.fn.system() string-form output capture on Windows. Terminals opened
-- via <leader>t use pwsh directly (see config/keymaps.lua).
