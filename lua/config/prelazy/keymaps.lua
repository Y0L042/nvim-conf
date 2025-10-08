-- Toggle word wrap with F9
vim.api.nvim_set_keymap('n', '<F9>', ':set wrap!<CR>', { noremap = true, silent = true })

-- In normal mode F2 will save the file
vim.api.nvim_set_keymap('n', '<F2>', ':update<CR>', { noremap = true, silent = true })

-- In insert mode F2 will exit insert, save, and enter insert mode again
vim.api.nvim_set_keymap('i', '<F2>', '<ESC>:update<CR>', { noremap = true, silent = true })

-- Go to definition with F12
vim.api.nvim_set_keymap('n', '<F12>', '<C-]>', { noremap = true, silent = true })

-- Add empty lines before and after cursor line
vim.keymap.set('n', '<leader>gj', "<Cmd>call append(line('.'),      repeat([''], v:count1))<CR>",
    { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gk', "<Cmd>call append(line('.') - 1,  repeat([''], v:count1))<CR>",
    { noremap = true, silent = true })

-- Insert current time and date
vim.api.nvim_set_keymap('n', '<leader>dt', [[a @<C-R>=strftime("%H:%M %a, %d %b %Y")<CR><Esc>]],
    { noremap = true, silent = true })
