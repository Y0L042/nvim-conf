_G.is_env_laptop_win = os.getenv("COMPUTER_ID") == 01
_G.is_env_laptop_wsl2 = os.getenv("COMPUTER_ID") == 11
_G.is_env_narga = os.getenv("COMPUTER_ID") == 101

-- Enable loading of local configuration files (.nvim.lua, .nvimrc, etc.)
vim.o.exrc = true        -- Enable reading of local config files (like .nvim.lua)
vim.o.secure = true      -- Ensure safe mode for untrusted configs

-- disable netrw at the very start of your init.lua FOR NVIM-TREE PLUGIN
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set UTF-8 encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
-- vim.opt.termencoding = "utf-8"

-- Disable vi compatibility (emulation of old bugs)
vim.opt.compatible = false

-- Use indentation of previous line
vim.opt.autoindent = true 

-- Use intelligent indentation for C
vim.opt.smartindent = true
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Configure tab width and insert spaces instead of tabs
vim.opt.tabstop = 4       -- Tab width is 4 spaces
vim.opt.shiftwidth = 4    -- Indent also with 4 spaces
vim.opt.softtabstop = 4    
vim.opt.expandtab = true  -- Expand tabs to spaces

-- Wrap lines at 120 chars. 80 is somewhat antiquated with nowadays displays.
vim.opt.textwidth = 80

-- Turn syntax highlighting on
vim.cmd('syntax on')

-- Use ctag generated tags
vim.opt.tags = './.tags;/'

-- Turn line numbers on
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight matching braces
vim.opt.showmatch = true

-- Intelligent comments
vim.cmd('set comments=sl:/*,mb:\\ *,elx:\\ */')

-- Disable word wrap by default
vim.opt.wrap = false

-- Do not let cursor scroll below or above N number of lines when scrolling.
vim.opt.scrolloff = 10

-- Highlight searched terms
vim.opt.hlsearch = true

-- Highlight matches as you type
vim.opt.incsearch = true

-- Enable auto completion menu after pressing TAB
vim.opt.wildmenu = true

-- Make wildmenu behave like similar to Bash completion
vim.opt.wildmode = { 'list', 'longest' }

-- Ignore certain file types in wildmenu
vim.opt.wildignore = { '*.docx', '*.jpg', '*.png', '*.gif', '*.pdf', '*.pyc', '*.exe', '*.flv', '*.img', '*.xlsx' }

-- Toggle word wrap with F9
vim.api.nvim_set_keymap('n', '<F9>', ':set wrap!<CR>', { noremap = true, silent = true })

-- Set cursor shape
-- vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50'

-- Highlight cursor line underneath the cursor horizontally
vim.opt.cursorline = true

-- Reset the cursor on start (for older versions of vim, usually not required)
-- vim.cmd([[
--   augroup myCmds
--     au!
--     autocmd VimEnter * silent !echo -ne "\e[2 q"
--   augroup END
-- ]])

-- Enhanced keyboard mappings

-- In normal mode F2 will save the file
vim.api.nvim_set_keymap('n', '<F2>', ':update<CR>', { noremap = true, silent = true })

-- In insert mode F2 will exit insert, save, and enter insert mode again
vim.api.nvim_set_keymap('i', '<F2>', '<ESC>:update<CR>', { noremap = true, silent = true })

-- Switch between header/source with F4 (change between .c & .cpp)
vim.api.nvim_set_keymap('n', '<F4>', ':update<CR>:e %:p:s,.h$,.X123X,:s,\\.c$,\\.h,:s,.X123X$,.c,<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<F4>', '<ESC>:update<CR>:e %:p:s,.h$,.X123X,:s,\\.c$,\\.h,:s,.X123X$,.c,<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F4>', '<ESC>:update<CR>:e %:p:s,.h$,.X123X,:s,\\.c$,\\.h,:s,.X123X$,.c,<CR>', { noremap = true, silent = true })

-- Switch between header/source and search for selected text/text under cursor with Shift+F4
vim.api.nvim_set_keymap('n', '<S-F4>', ":let @/ = expand('<cword>')<CR>:update<CR>:e %:p:s,.h$,.X123X,:s,\\.c$,\\.h,:s,.X123X$,.c,<CR>ggnzt", { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-F4>', "<ESC>:let @/ = expand('<cword>')<CR>:update<CR>:e %:p:s,.h$,.X123X,:s,\\.c$,\\.h,:s,.X123X$,.c,<CR>ggnzt", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-F4>', [[y:let @/ = @0<CR>:update<CR>:e %:p:s,.h$,.X123X,:s,\\.c$,\\.h,:s,.X123X$,.c,<CR>ggnzt]], { noremap = true, silent = true })

-- Function to check if the current buffer is netrw
_G.is_netrw = function()
  return vim.bo.filetype == 'netrw'
end

-- Define the key mapping to save changes, close the buffer, and open netrw but only if the current buffer is not netrw
vim.cmd([[
  augroup NetrwMappings
    autocmd!
    autocmd FileType * if luaeval("is_netrw()") == 0 | nnoremap <buffer> <F1> :update<bar>bd<bar>Explore<CR> | inoremap <buffer> <F1> <ESC>:update<bar>bd<bar>Explore<CR> | endif
    autocmd FileType netrw nnoremap <buffer> <F1> <Nop>
  augroup END
]])

-- Go to definition with F12
vim.api.nvim_set_keymap('n', '<F12>', '<C-]>', { noremap = true, silent = true })

-- Define the save_all_tabs function globally
_G.save_all_tabs = function()
  local current_tab = vim.fn.tabpagenr()
  local current_win = vim.fn.winnr()
  local current_buf = vim.fn.bufnr('%')

  -- Enable 'hidden' option
  vim.opt.hidden = true

  -- Save all modified buffers
  vim.cmd('tabdo windo if &modified | update | endif')

  -- Revert to 'nohidden' option
  vim.opt.hidden = false

  -- Restore the original tab
  vim.cmd('tabnext ' .. current_tab)

  -- Restore the original window within the tab
  vim.cmd(current_win .. 'wincmd w')

  -- Restore the original buffer within the window
  if vim.fn.bufnr('%') ~= current_buf then
    vim.cmd('buffer ' .. current_buf)
  end
end

-- Map F5 to call the save_all_tabs function
vim.api.nvim_set_keymap('n', '<F5>', ':lua _G.save_all_tabs()<CR>', { noremap = true, silent = true })


-- Key mappings for tag navigation
-- vim.api.nvim_set_keymap('n', 'gd', '<C-]>', { noremap = true, silent = true })      -- Go to definition
-- vim.api.nvim_set_keymap('n', 'gD', '<C-t>', { noremap = true, silent = true })      -- Go back
-- vim.api.nvim_set_keymap('n', 'gT', ':tselect<CR>', { noremap = true, silent = true })  -- Tag selection if multiple matches
-- vim.api.nvim_set_keymap('n', 'gr', ':tjump<CR>', { noremap = true, silent = true })    -- Jump to the tag (all matches)


-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set the timeout length for leader key sequences
vim.opt.timeoutlen = 1500  -- Adjust this value as needed, 1000 ms = 1 second

-- Add empty lines before and after cursor line
vim.keymap.set('n', '<leader>gj', "<Cmd>call append(line('.'),      repeat([''], v:count1))<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gk', "<Cmd>call append(line('.') - 1,  repeat([''], v:count1))<CR>", { noremap = true, silent = true })
  








vim.api.nvim_create_user_command("DiagnosticToggle", function()
	local config = vim.diagnostic.config
	local vt = config().virtual_text
	config {
		virtual_text = not vt,
		underline = not vt,
		signs = not vt,
	}
end, { desc = "toggle diagnostic" })







if (is_env_laptop_win) then 
  ---- Set shell to MSYS2 bash.exe
  vim.opt.shell = "C:/msys64/usr/bin/bash"
  vim.opt.shellcmdflag = '-c'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''

  ---- Ensure shellslash is not set
  vim.opt.shellslash = false

  ---- Add ripgrep to the PATH
  vim.env.PATH = vim.env.PATH .. ';C:\\msys64\\ucrt64\\bin'

  vim.env.PATH = "/ucrt64/bin:" .. vim.env.PATH
end



local function clear_shada_files()
    -- Get the shada files' paths
    local shada_files = vim.fn.glob(vim.fn.stdpath('data') .. '/*.*', 1, 1)

    -- Delete each shada file
    for _, file in ipairs(shada_files) do
        vim.fn.delete(file)
    end

    -- Reload Neovim
    vim.cmd('silent! wa')  -- Save all files
    vim.cmd('silent! qall!')  -- Quit all windows
    vim.cmd('silent! edit')  -- Reopen the current file
end

-- Map the function to a command for easy use
vim.api.nvim_create_user_command('ClearShada', clear_shada_files, {})

-- Insert current time and date
vim.api.nvim_set_keymap('n', '<leader>dt', [[a @<C-R>=strftime("%H:%M %a, %d %b %Y")<CR><Esc>]], { noremap = true, silent = true })













-- Kickstart.nvim configs



-- Ensure lazy.nvim is loaded
require("config.lazy")

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)

-- vim.opt.formatexpr = nil
vim.opt.formatoptions = vim.opt.formatoptions + 't'
vim.opt.formatoptions = vim.opt.formatoptions - 'l'
vim.opt.formatoptions = vim.opt.formatoptions - 'o'
-- vim.opt.cindent = false

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

-- Define a custom command `E` that maps to `Explore`
vim.api.nvim_create_user_command('E', 'Explore', {})



-- File-specific Settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "nasm", "asm" },
    callback = function()
        -- Set settings for web-related files
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c" },
    callback = function()
        -- Set settings for web-related files
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gd", "tres", "tscn" },
    callback = function()
        -- Set settings for web-related files
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = false
    end,
})
