-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- move selection up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- save file
-- vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
-- vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
-- vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
-- vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>','<C-d>zz', opts)
vim.keymap.set('n', '<C-u>','<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
-- vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
-- vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
-- vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
-- vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
-- vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
-- vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
-- vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
-- vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
-- vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
-- vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
-- vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
-- vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Indent current line (normal mode)
vim.keymap.set('n', '<C-,>', '<<', opts)  -- unindent (< shape)
vim.keymap.set('n', '<C-.>', '>>', opts)  -- indent (> shape)
vim.keymap.set('v', '<C-,>', '<gv', opts) -- unindent and reselect
vim.keymap.set('v', '<C-.>', '>gv', opts) -- indent and reselect


-- True delete keymaps (don't yank to clipboard/registers)
-- Character deletion
vim.keymap.set('n', '<leader>x', '"_x', opts)    -- delete char under cursor
vim.keymap.set('n', '<leader>X', '"_X', opts)    -- delete char before cursor
-- Word deletion
vim.keymap.set('n', '<leader>dw', '"_dw', opts)  -- delete from cursor to end of word
vim.keymap.set('n', '<leader>db', '"_db', opts)  -- delete from cursor to beginning of word
vim.keymap.set('n', '<leader>dW', '"_dW', opts)  -- delete from cursor to end of WORD (whitespace-separated)
vim.keymap.set('n', '<leader>dB', '"_dB', opts)  -- delete from cursor to beginning of WORD
-- Line deletion
vim.keymap.set('n', '<leader>dd', '"_dd', opts)  -- delete entire line
vim.keymap.set('n', '<leader>d$', '"_d$', opts)  -- delete from cursor to end of line
vim.keymap.set('n', '<leader>D', '"_D', opts)    -- delete from cursor to end of line (alternative)
vim.keymap.set('n', '<leader>d0', '"_d0', opts)  -- delete from cursor to beginning of line
vim.keymap.set('n', '<leader>d^', '"_d^', opts)  -- delete from cursor to first non-blank char
-- File range deletion
vim.keymap.set('n', '<leader>dG', '"_dG', opts)  -- delete from cursor to end of file
vim.keymap.set('n', '<leader>dgg', '"_dgg', opts) -- delete from cursor to beginning of file
-- Visual mode deletion
vim.keymap.set('v', '<leader>d', '"_d', opts)    -- delete selection
vim.keymap.set('v', '<leader>x', '"_x', opts)    -- delete selection (alternative)

-- Tabs
-- vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
-- vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
-- vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
-- vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab
-- 
-- -- Toggle line wrapping
-- vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)
-- 
-- -- Stay in indent mode
-- vim.keymap.set('v', '<', '<gv', opts)
-- vim.keymap.set('v', '>', '>gv', opts)
-- 
-- -- Keep last yanked when pasting
-- -- vim.keymap.set('v', 'p', '"_dP', opts)
-- 
-- -- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
