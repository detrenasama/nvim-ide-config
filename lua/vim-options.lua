vim.opt.updatetime=100
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.shiftwidth = 4     -- Number of spaces for each step of indent
vim.opt.tabstop = 4        -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4    -- Number of spaces that a <Tab> counts for while editing
vim.opt.autoindent = true  -- Copy indent from current line when starting a new line
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.scrolloff = 8
vim.opt.clipboard = "unnamedplus"
vim.opt.writebackup = false
vim.g.mapleader = " "

vim.keymap.set('n', '<c-s>', ':wa<CR>')

-- Navigate vim panes better navi
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Move between tabs with Shift + h/l
vim.keymap.set('n', '<M-Left>', 'gT', { desc = 'Previous tab' })
vim.keymap.set('n', '<M-Right>', 'gt', { desc = 'Next tab' })

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true
vim.keymap.set('n', '<Leader>r', ':source $MYVIMRC<CR>', { silent = true })

