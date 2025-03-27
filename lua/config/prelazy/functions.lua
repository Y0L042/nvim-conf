-- Function to check if the current buffer is netrw
_G.is_netrw = function()
  return vim.bo.filetype == 'netrw'
end

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
