# nvim-config — LSP-first (branch `lsp-first`)

A Neovim 0.12 configuration built around one idea: **open a file, get IDE features, configure nothing.** Uses Neovim's built-in `vim.pack` plugin manager and native `vim.lsp.config` / `vim.lsp.enable` — no plugin manager, no framework.

## The eight priorities and how each is met

| # | Priority | How |
| --- | --- | --- |
| 1 | LSP for any language, lazily installed | `lua/plugins/lsp.lua`: on `FileType`, the mason-lspconfig filetype map lists candidate servers; a strict `GENERIC` filter removes junk servers (spellcheck/security/emmet-style), a small curated `PREFERRED` table picks the canonical server for ~24 languages, and the first missing one is **installed in the background** while you keep typing. Languages not in `PREFERRED` fall back to the first remaining candidate. Every filetype is memoized after its first hit. |
| 2 | Every keybind understandable without vim experience | Every map has a plain-English `desc`; `which-key` ([folke/which-key.nvim](https://github.com/folke/which-key.nvim)) shows them live: press `<Space>` and pause to see the leader menu, `<leader>?` for the full cheat sheet, press `z` and pause for the fold keys. Every LSP action also exists as a typed command (`:LspDef`, `:LspRename`, …) — see the Typed commands section. Vanilla nvim keybinds are left intact. |
| 3 | Warm LSP | `vim.lsp.enable` clients in 0.12 are **not** stopped when their last buffer closes (verified against 0.12.2) — a server lives for the whole session, closing files never restarts it, and a re-opened file of the same language re-uses the running process. Detection results are cached per filetype, so re-open costs one table lookup. The statusline shows live server names as the indicator (`:LspStatus` prints the same list). |
| 4 | Zero LSP configuration | No per-language settings. Servers run on nvim-lspconfig recipe defaults. One documented exception: `lua_ls` needs its nvim-awareness block (runtime version + `vim` global) because editing *this config* is editing lua. `:Mason` remains for manual installs/removals. |
| 5 | Parity or better than VSCode LSP | Go-to-definition (`gd`), references, implementations, hover docs, rename, quick-fixes/code actions, inline diagnostics + hover detail, inlay hints on attach, LSP formatting, workspace-wide search, plus treesitter semantic highlighting. Every action also exists as a typed command (see the Typed commands section). |
| 6 | Fast | ~10 eager plugin files, measured: **~0.28 s** bare boot, **~0.41 s** with a real file (Windows warm, `--startuptime`; providers for python/ruby/perl/tcl/node disabled — a .py file otherwise costs ~0.7 s in provider probing). Parsers/servers install lazily on first use and are cached. |
| 7 | Snippets | [LuaSnip](https://github.com/L3MON4D3/LuaSnip) + [friendly-snippets](https://github.com/rafamadriz/friendly-snippets): Tab expands, Shift-Tab / C-J-K jump placeholders. |
| 8 | Useful autocomplete sorting | blink.cmp `fuzzy.sorts`: `exact` > `score` (frecency + proximity) > item-kind rank (fields/variables/methods/functions before keywords/text) > server `sort_text`. |

Verification: `taplo` (TOML) and `gopls`-style installs were exercised headless end-to-end: detect → background mason install → `vim.lsp.enable` → attach to the already-open buffer, with notifications. pyright + ruff attach warm with **zero** installs on any python file. Startup quoted above from `--startuptime`.

## Structure

```text
init.lua              leader, eager config, plugin load order
lua/config/options.lua    editor options (fast, provider bridges disabled)
lua/config/keymaps.lua    every custom map, plain-English descs
lua/config/autocmds.lua   big-file guard, yank flash, python indent, cmdline popup
lua/config/statusline.lua zero-plugin statusline (shows warm LSP clients)
lua/plugins/*.lua         one vim.pack.add() + setup() per plugin
```

## Plugins kept (rewritten)

- **LSP**: [mason.nvim](https://github.com/williamboman/mason.nvim) + [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) v2 + [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- **Completion**: [blink.cmp](https://github.com/saghen/blink.cmp) v1 + LuaSnip + friendly-snippets
- **Syntax**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main` branch, lazy parser install)
- **Files**: [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) (`nvim .` opens the tree) + [fzf-lua](https://github.com/ibhagwan/fzf-lua) (also `vim.ui.select` for code actions)
- **Git**: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) gutter
- **UX**: [which-key.nvim](https://github.com/folke/which-key.nvim), [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)

Dropped from the previous config: bufferline, harpoon, sessions (persistence), copilot, mini.pairs/surround/indentscope, nvim-ts-autotag, conform + nvim-lint + mason-tool-installer (formatting is LSP-only now), toggleterm + lazygit (terminal is native `<leader>t`).

## Keymaps (this is the whole list; press `<Space>` and pause for the live menu)

Leader = `<Space>`. All descriptions below are what which-key shows.

| Key | Mode | Action |
| --- | --- | --- |
| `<Esc>` | n | clear search highlighting |
| `<C-s>` | n, i | save file |
| `<leader>q` | n | quit this window |
| `<C-h/j/k/l>` | n | window left / down / up / right |
| `<leader>e` | n | toggle the file explorer |
| `<leader>ff` | n | find files by name |
| `<leader>fs` | n | search text across the project |
| `<leader>fr` | n | recently used files |
| `<leader>bb` | n | switch to an open file |
| `<leader>bd` | n | close this file |
| `]b` / `[b` | n | next / previous open file |
| `<leader>t` | n | open a terminal below (pwsh) |
| `<Esc><Esc>` | t | leave terminal, back to normal mode |
| `gd` | n | go to where this symbol is defined |
| `gr` | n | find all places this symbol is used |
| `gi` | n | go to implementation |
| `K` | n | hover: show docs / type info |
| `<leader>rn` | n | rename the symbol under the cursor |
| `<leader>ca` | n | quick fixes and refactorings |
| `<leader>cd` | n | show the full error/warning here |
| `[d` / `]d` | n | previous / next error or warning |
| `<leader>cf` | n | format this file (LSP) — or type `:LspFormat` |
| `<leader>ci` | n | toggle inline type/parameter hints |
| `<leader>gp` | n | preview this change |
| `<leader>hs` / `<leader>hr` | n, v | stage / undo this change |
| `]h` / `[h` | n | jump to next / previous change |
| `<`, `>` | v | indent, keep selection |
| `J`, `K` | v | move selection down / up |
| `<C-Up/Down>` | c | command history while completion popup is open |
| `: <Tab>` | c | blink.cmp command menu (cycles, accepts) |
| `/ <Tab>` | c | native search-term completion popup |

Blink completion: menu auto-opens while typing; `<Tab>`/`<S-Tab>` select, `<Tab>` accepts; `<C-Space>` (or `<C-;>`/`<C-g>`) forces the menu; auto documentation pane beside the menu; signature help while typing call arguments.

## Folding

`foldmethod=expr` with `vim.treesitter.foldexpr()` as the base provider — works in every language where the lazy parser is installed — and a per-window upgrade to `vim.lsp.foldexpr()` in `LspAttach` when the server advertises `textDocument/foldingRange` (pattern per `:h vim.lsp.foldexpr`). Files start fully unfolded, like VSCode.

| Key | Action (what which-key shows after `z`) |
| --- | --- |
| `zc` / `zo` | fold / unfold the block under the cursor |
| `za` | toggle fold under the cursor |
| `zM` / `zR` | fold everything / unfold everything |

Verified headless on a python file: real treesitter levels computed (`foldlevel` 2 inside function bodies), `zM` closes, `zR` restores.

## Typed commands (command-first alternative for every LSP action)

| Command | Action |
| --- | --- |
| `:LspDef` | go to definition |
| `:LspReferences` | find all usages |
| `:LspImplementation` | go to implementation |
| `:LspHover` | hover docs / type info |
| `:LspRename` | project-wide rename |
| `:LspCodeActions` | quick fixes and refactorings |
| `:LspFormat` | format this file |
| `:LspDiagnostics` | show the full error/warning for the line |
| `:LspStatus` | show which servers are warm for this buffer |

## How the lazy-install engine decides

On first encounter of a filetype `ft` (memoized afterwards):

1. Take every mason-lspconfig server claiming `ft`, minus the `GENERIC` never-auto-install list.
2. Order them with the curated `PREFERRED[ft]` first (falls back to candidate order for unlisted languages).
3. Enable every already-installed server (mason-lspconfig's `automatic_enable` also does this at startup and on its own install events).
4. If the preferred entry is not installed, install it in the background; on success, enable it — mason-lspconfig and the engine both ensure attach to open + future buffers.

So `PREFERRED` is only about *which* server a language gets when several exist; add/remove entries there (or use `:Mason`) if you disagree — everything else stays environment-driven.

## Environment notes (Windows)

- Treesitter parser installs need `tree-sitter-cli` ≥0.26 and a C compiler in PATH (both present).
- Mason installs to `%LOCALAPPDATA%\nvim-data\mason`; LSP servers/formatters installed there stay across config changes (reuse = warm).
- Clipboard provider is pinned to `win32yank.exe` to dodge AMD lemonade.exe auto-detection; other systems use nvim's default.
- Python: 4-space indent via autocmd. Toml: taplo installs on first `.toml` open (verified).

Run `:h <package>` (e.g. `:h blink-cmp-config-keymap`, `:h neo-tree-mappings`) for full docs. `:checkhealth` covers mason / vim.lsp / nvim-treesitter / which-key state.
