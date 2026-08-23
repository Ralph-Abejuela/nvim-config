-- Editor options. Runs eagerly at startup (no plugins).

-- NOTE: netrw stays ENABLED on purpose — neo-tree hijacks it so `nvim .`
-- opens the tree instead of a stray '.' buffer (hijack_netrw_behavior in
-- neo-tree.lua). Disabling netrw entirely is what created that buffer.

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.showmode = false
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.inccommand = 'split'
opt.cursorline = true
opt.scrolloff = 8
opt.termguicolors = true
opt.laststatus = 3 -- global statusline (mini.statusline)

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Command-line completion: live popup while typing (:h vi shows matches as
-- you type via wildtrigger() — see :h cmdline-autocompletion), Tab cycles.
opt.wildmenu = true
opt.wildmode = 'noselect:lastused,full'
opt.wildoptions = 'pum'

-- NOTE: shell stays default (cmd) — pwsh shellcmdflag/shellredir break
-- vim.fn.system() string-form output capture on Windows (persistence branch
-- detection, etc.). pwsh is used inside toggleterm instead (see git.lua).
