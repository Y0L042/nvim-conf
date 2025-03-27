-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`


-- Define a custom command `E` that maps to `Explore`
vim.api.nvim_create_user_command('E', 'Explore', {})
