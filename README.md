# Neovim 0.12 IDE Config

Personal Neovim configuration built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), extended into a full IDE with LSP, linting, formatting, debugging, testing, git tools, and AI completion.

**Requires Neovim 0.12+** — uses built-in `vim.pack` plugin manager and native `vim.lsp.config`/`vim.lsp.enable` APIs.

## Quick Start

```sh
git clone https://github.com/<your-fork>/kickstart.nvim.git "$env:LOCALAPPDATA\nvim"   # Windows
git clone https://github.com/<your-fork>/kickstart.nvim.git ~/.config/nvim              # Linux/Mac
nvim
```

First launch installs all plugins via `vim.pack`. Mason auto-installs LSP servers, formatters, and linters. Restart once after initial install completes.

## Plugins

### Core UX

| Plugin | What |
| --- | --- |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Fuzzy picker, statusline, notifier, bigfile handler, indent guides, smooth scroll |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding helper (press any prefix to see available commands) |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | Sidebar file explorer with git status and diagnostics |
| [barbar.nvim](https://github.com/romgrk/barbar.nvim) | Buffer tabs with mouse/keyboard navigation |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight TODO, FIXME, HACK in comments |
| [guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) | Auto-detect indentation |
| [mini.nvim](https://github.com/nvim-mini/mini.nvim) | mini.ai (text objects), mini.surround, mini.icons |

### LSP, Completion & Diagnostics

| Plugin | What |
| --- | --- |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server management, auto-install |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Autocompletion engine (LSP, path, snippets) |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting (stylua, prettierd, ruff_format) |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Async linting (eslint, ruff, golangci-lint, shellcheck, stylelint, etc.) |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Pretty diagnostics/quickfix panel |
| [fidget.nvim](https://github.com/j-hui/fidget.nvim) | LSP progress notifications |

### Git

| Plugin | What |
| --- | --- |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Gutter signs, hunk staging/reset, blame |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Git diff/history UI |
| [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim) | Merge conflict resolution |

### Navigation & Editing

| Plugin | What |
| --- | --- |
| [flash.nvim](https://github.com/folke/flash.nvim) | Jump to any visible text with labels (`s`/`S`) |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets, quotes |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indentation guides |
| [rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim) | Colored brackets |

### Language & Tools

| Plugin | What |
| --- | --- |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting, folding, incremental selection |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Floating terminal (`<C-\>`) |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) + [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | Debug adapter protocol |
| [neotest](https://github.com/nvim-neotest/neotest) | Test runner framework |
| [markview.nvim](https://github.com/OXY2DEV/markview.nvim) | Live markdown preview |

### Session & AI

| Plugin | What |
| --- | --- |
| [auto-session](https://github.com/rmagatti/auto-session) | Auto save/restore workspace sessions |
| [supermaven-nvim](https://github.com/supermaven-inc/supermaven-nvim) | Free AI code completion |

## Keymaps

| Prefix | Group | Keys |
| --- | --- | --- |
| `<leader>s` | Search | `sf` files, `sg` grep, `sh` help, `sk` keymaps, `sd` diagnostics, `sr` resume, `s.` recent |
| `<leader>t` | Test | `tr` run nearest, `tf` run file, `tS` run suite, `ts` summary, `tl` run last |
| `<leader>T` | Terminal | `tt` float, `tT` horizontal |
| `<leader>h` | Git Hunk | `hs` stage, `hr` reset, `hp` preview, `hb` blame, `hd` diff |
| `<leader>g` | Git | `gd` diffview, `gh` diff history, `gf` file history |
| `<leader>x` | Trouble | `xx` diagnostics, `xX` workspace, `xq` quickfix, `xl` loclist |
| `<leader>w` | Workspace | `wr` restore, `ws` save, `wl` session lens, `wd` delete |
| `<leader>c` | Code | `cl` lint |
| `<leader>m` | Markdown | `mp` preview toggle |
| `<leader>f` | Format | `f` format buffer |
| `<leader>b` | Breakpoint | `b` toggle, `B` set conditional |
| `<leader>e` | Explorer | `e` toggle neo-tree |
| `gr` | LSP Goto | `grr` references, `grd` definition, `gri` implementation, `grt` type def, `grn` rename |
| `g` | Go/LSP | `gl` diagnostic float, `gR` LSP refs (trouble), `gO` doc symbols, `gW` workspace symbols |

Other useful keys:

- `<C-\>` — toggle floating terminal
- `<C-h/j/k/l>` — move between splits
- `s` / `S` — flash jump / treesitter jump
- `]c` / `[c` — next/prev git hunk
- `<leader>/` — search in current buffer
- `<leader><leader>` — buffer list

## Neovim 0.12 Features Used

- **`vim.pack`** — built-in plugin manager (no lazy.nvim needed)
- **`vim.lsp.config()` / `vim.lsp.enable()`** — native LSP setup
- **`vim.o.smoothscroll`** — native smooth scrolling
- **Treesitter incremental selection** — `vam`/`vim` in visual mode to expand/shrink selection by node
- **`vim.loader.enable()`** — bytecode caching for faster startup

## Platform Support

Works on Windows and Linux. Shell auto-detected: pwsh > zsh > bash > sh. Debugger (`nvim-dap-go`) auto-detaches on Windows. Clipboard uses `unnamedplus` on both platforms.

## Updating Plugins

```vim
:lua vim.pack.update()     " Fetch updates
:w                          " Apply updates
:q                          " Cancel
```

## Structure

```
init.lua                          # Main config (options, keymaps, LSP, completion, treesitter)
lua/
├── custom/plugins/
│   ├── init.lua                  # Auto-loader for all plugin files below
│   ├── barbar.lua                # Buffer tabs
│   ├── flash.lua                 # Jump navigation
│   ├── git-tools.lua             # Diffview + git-conflict
│   ├── linting.lua               # nvim-lint config
│   ├── markdown.lua              # Live preview
│   ├── rainbow.lua               # Bracket colors
│   ├── session.lua               # Workspace sessions
│   ├── snacks.lua                # Picker + statusline + extras
│   ├── supermaven.lua            # AI completion
│   ├── testing.lua               # Test runner
│   ├── toggleterm.lua            # Terminal
│   └── trouble.lua               # Diagnostics panel
└── kickstart/plugins/
    ├── autopairs.lua
    ├── debug.lua
    ├── gitsigns.lua
    ├── indent_line.lua
    └── neo-tree.lua
```
