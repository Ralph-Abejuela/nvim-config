# nvim-config

A fast, modular [Neovim 0.12](https://neovim.io/) configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim) — ~80 ms startup, LSP-driven development, and a curated buffer/tab-close workflow that plays nice with [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim).

**Highlights:** blink.cmp completion · treesitter · Mason-managed LSP (lua_ls, tsc, pyright) · inline diagnostics · tokyonight theme · bufferline tabs · gitsigns + lazygit · which-key · Copilot · Windows-first (pwsh terminals, netrw hijack so `nvim .` opens the file tree).

## Structure

```text
init.lua              lazy bootstrap, leader, eager config
lua/config/           options · keymaps · autocmds
lua/plugins/*.lua     one lazy.nvim spec per plugin
```

## Plugins

blink.cmp · fzf-lua · neo-tree · mason + nvim-lspconfig (lua_ls, tsc, pyright) · conform + nvim-lint · gitsigns · toggleterm · tokyonight · mini.statusline / mini.pairs / mini.surround / mini.indentscope · bufferline · harpoon · persistence · which-key · copilot.vim · LuaSnip · treesitter

Run `:h <package>` (e.g. `:h blink-cmp-config-keymap`, `:h neo-tree-mappings`) for full docs — this README doubles as the curated keymap reference.

---

## Custom keymaps (`lua/config/keymaps.lua`)

Leader = `<Space>`.

| Key | Mode | Action |
| --- | --- | --- |
| `<Esc>` | n | clear search highlight |
| `<C-s>` | n, i | save file |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | n | window left / down / up / right |
| `<Esc><Esc>` | t | exit terminal mode |
| `<` `>` | v | indent, keep selection |
| `J` `K` | v | move selection down / up |
| `<Up>` `<Down>` | c | history nav while completion popup is open (`wildmenumode()` guard) |
| `<leader>ff` | n | fzf-lua: find files |
| `<leader>fg` | n | fzf-lua: live grep |
| `<leader>fb` | n | fzf-lua: buffers |
| `<leader>fr` | n | fzf-lua: recent files |
| `<leader>e` | n | neo-tree toggle |
| `<leader>ca` | n | LSP code action |
| `<leader>cd` | n | full diagnostics float for current line |
| `<leader>ci` | n | toggle inlay hints (inline type/param annotations) |
| `<leader>rn` | n | LSP rename |
| `gd` | n | LSP go to definition |
| `gr` | n | LSP references |
| `gi` | n | LSP implementation |
| `K` | n | LSP hover |
| `<leader>cf` | n | conform format (keybind only, never on save) |
| `<leader>g` | n | lazygit (floating) |
| `<leader>a` | n | harpoon: mark file |
| `<leader>h` | n | harpoon: menu |
| `<leader>t` | n | toggle terminal (pwsh) |
| `<leader>qs` | n | persistence: save session |
| `<leader>ql` | n | persistence: load session |

Cmdline: `wildmenu` + `wildmode=noselect:lastused,full` + `wildoptions=pum`; `CmdlineChanged` → `wildtrigger()` shows the completion popup **live as you type** in `:` `/` `?` (nvim 0.12 `:h cmdline-autocompletion`).

---

## Plugin default keymaps

### blink.cmp — completion

`default` preset (`:h blink-cmp-config-keymap`):

| Key | Action |
| --- | --- |
| `<C-space>` | show / show documentation |
| `<C-;>` `<C-g>` | show (this config's alternatives — WT may eat Ctrl+Space) |
| `<C-e>` | hide |
| `<C-y>` | select & accept |
| `<Up>` `<Down>` | select prev / next |
| `<C-p>` `<C-n>` | select prev / next |
| `<C-b>` `<C-f>` | scroll documentation up / down |
| `<Tab>` `<S-Tab>` | snippet forward / backward |
| `<C-k>` | show / hide signature |

This config overrides `<C-k>`/`<C-j>` → select prev / next (fallback). Auto-shows while typing (`show_on_keyword`). `<CR>` accepts via the preset's completion menu behavior.

### fzf-lua — fuzzy finder

Actions while the picker is open (fzf window):

| Key | Action |
| --- | --- |
| `<Enter>` | open / edit |
| `<C-s>` | open in split |
| `<C-v>` | open in vertical split |
| `<C-t>` | open in tab |
| `<Alt-q>` | send selection to quickfix |
| `<Alt-a>` | toggle select all |
| `<M-Esc>` | hide picker |
| `<F1>` | toggle help |
| `<F2>` | toggle fullscreen |
| `<F3>`–`<F9>` | preview toggles (wrap, preview, ts-ctx…) |
| `<S-Up>` `<S-Down>` | scroll preview up / down |
| `<C-a>` `<C-e>` | beginning / end of line |
| `<C-u>` | discard line |
| `<C-f>` `<C-b>` | half-page down / up |
| `<Alt-g>` `<Alt-G>` | first / last item |

Commands: `:FzfLua files` · `live_grep` · `buffers` · `oldfiles` · `help_tags` … (mapped to `<leader>ff/fg/fb/fr`).

### neo-tree — file tree (`:h neo-tree-mappings`)

| Key | Action |
| --- | --- |
| `<CR>` `<2-LeftMouse>` `<space>` | open / expand / collapse node |
| `S` | open in horizontal split |
| `s` | open in vertical split |
| `t` | open in new tab |
| `C` | close node (or parent) |
| `z` | close all nodes |
| `P` | toggle preview mode |
| `l` `<C-f>` `<C-b>` | focus / scroll preview |
| `<bs>` | navigate up a directory |
| `.` | set root to targeted directory |
| `<C-s>` | quick jump (label mode) |
| `[g` `]g` | prev / next git-modified file |
| `a` | add file (trailing `/` = dir) |
| `A` | add directory |
| `d` | delete |
| `T` | trash |
| `u` `U` | undo / restore from trash |
| `r` | rename |
| `b` | rename basename |
| `i` | show file details |
| `y` `x` `p` | copy / cut / paste to clipboard |
| `<C-r>` | clear clipboard |
| `c` `m` | copy / move (prompt for destination) |
| `H` | toggle hidden files |
| `R` | refresh |
| `o` + `o?` | sort by (c=created, d=diagnostics, g=git, m=modified, n=name, s=size, t=type) |
| `/` | fuzzy finder |
| `D` | fuzzy finder (directories only) |
| `#` | fuzzy sorter |
| `f` | filter on submit |
| `<C-x>` | clear filter |
| `q` | close tree window |
| `?` | show all mappings (popup) |
| `<` `>` | previous / next source |
| `<Tab>` | tag selection |
| `<C-S-i>` | invert selection |

### mini.surround (`:h mini-surround`)

| Key | Action |
| --- | --- |
| `sa<motion><surr>` | add surrounding (e.g. `saiw)` — inner word in parens) |
| `sd<surr>` | delete surrounding (e.g. `sd(`) |
| `sr<old><new>` | replace surrounding (e.g. `sr)'`) |
| `sf<surr>` | find surrounding to the right |
| `sF<surr>` | find surrounding to the left |
| `sh<surr>` | highlight surrounding |
| `s` (visual) | add surrounding around selection (this config) |
| `n` / `l` suffix | extended: next / last occurrence (e.g. `sdnf`) |

### mini.pairs / mini.indentscope

No keymaps — pairs auto-close brackets/quotes while typing; indentscope draws the indent guide.

### toggleterm (`:h toggleterm`)

- Default `<C-\>` toggle is **disabled** (`open_mapping = false`); use `<leader>t`.
- Terminal shell: **pwsh** (toggleterm `shell` option; nvim's global shell stays cmd — pwsh shellredir breaks `system()` capture on Windows).
- `:Lazygit` command → lazygit in a floating terminal (`<leader>g`).

### gitsigns (`:h gitsigns`)

No default keymaps. `:Gitsigns <subcmd>` — e.g. `:Gitsigns stage_hunk` · `:Gitsigns diffthis HEAD~1` · `:Gitsigns blame_line` · `:Gitsigns toggle_current_line_blame` · `:Gitsigns reset_buffer`.

### harpoon

| Key | Action |
| --- | --- |
| `<leader>a` | mark current file |
| `<leader>h` | quick menu (pick with j/k + `<CR>`) |

### copilot.vim (`:h copilot`)

- Default `<Tab>` accept is **disabled** (`copilot_no_tab_map = true`) so Tab stays blink's.
- `<C-l>` — accept word (this config)
- `<C-\>` — next suggestion (this config)
- `:Copilot setup` (auth) · `:Copilot status` · `:Copilot disable` / `:Copilot enable` · `:Copilot panel`

### bufferline (`:h bufferline`)

No default keymaps. Commands: `:BufferLineCloseRight` · `:BufferLineCloseLeft` · `:BufferLineCloseOthers` · `:BufferLineGoToBuffer N` (or `require("bufferline").go_to(N)`).

### persistence (`:h persistence.nvim`)

`:PersistenceSave` (mapped `<leader>qs`) · `:PersistenceLoad` (mapped `<leader>ql`). Auto-saves on exit, restores on enter.

### conform / nvim-lint

conform: no default keymaps; `:Format` / `<leader>cf` (stylua, ruff, prettierd by filetype). nvim-lint: no keymaps; lints on save (ruff for python).

### which-key

No keymaps of its own — shows existing mappings as you type a prefix.

---

## Startup note

Plugins are lazy except catppuccin and neo-tree (`lazy = false` — required for the netrw hijack on `nvim .`). Big files >2MB disable treesitter/LSP/folding automatically. Inlay hints: on for all servers (tsc included). TypeScript LSP: `tsc` (TypeScript 7 Go compiler, npm `typescript@7`; `tsgo` is deprecated).

---

## FAQ

Real answers to problems this config solves — each solution is self-contained and works in any Neovim 0.11+ setup.

### Why does closing a buffer expand neo-tree to full width?

Neovim's `:bd` displays the most recent entry in the jump list after deleting the current buffer — which is often the file explorer buffer itself. Fix: switch to a real file buffer *before* deleting. This config does it in bufferline's `close_command`, so closing a tab always lands on another code buffer and never on the tree.

### Why does `:q` not exit Neovim when a file tree sidebar is open?

`:q` closes only the current window; the sidebar window keeps Neovim alive. Fix: a `WinClosed` autocmd — when the last remaining window is the tree, run `:qa` so quitting always exits.

### Why do files opened from neo-tree disappear from the tab bar?

neo-tree opens files with `bufadd()`, which creates **unlisted** buffers (and does not fire `BufAdd`). Unlisted buffers are invisible to bufferline and can be silently dropped by `:bd`. Fix: mark buffers listed in a `BufEnter`/`BufWinEnter`/`BufReadPost` autocmd.

### Why doesn't my colorscheme apply when loaded by lazy.nvim?

lazy.nvim loads and runs `setup()` but never calls `vim.cmd.colorscheme()` — the theme must be applied explicitly in the plugin's `config`.

### How do I get live command-line completion while typing?

Neovim 0.12 has native autocompletion: an autocmd on `CmdlineChanged` calling `wildtrigger()`, plus `set wildmode=noselect:lastused,full` and `set wildoptions=pum`. See `:h cmdline-autocompletion`.

### Why is `mason-lspconfig` starting servers I didn't enable?

`automatic_enable` defaults to true — mason-lspconfig auto-enables every installed package that has an lspconfig recipe. Set `automatic_enable = false` and call `vim.lsp.enable()` with your own list.