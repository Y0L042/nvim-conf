-- -- C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64
--
-- -- 2) Define a toggle function that:
-- --    • Reuses a buffer named "MSYS2_UCRT64" if it exists
-- --    • Opens it (or creates it) in a horizontal split
-- --    • Runs Bash as a login + interactive shell
-- local function toggle_msys2()
--   -- Look for a buffer named exactly "MSYS2_UCRT64"
--   for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--     if vim.api.nvim_buf_get_name(buf) == "MSYS2_UCRT64" then
--       local win = vim.fn.bufwinnr(buf)
--       if win ~= -1 then
--         -- If it’s already visible, close that window
--         return vim.api.nvim_command(win .. "wincmd c")
--       else
--         -- If it exists but is hidden, open it in a split
--         return vim.api.nvim_command("sbuffer " .. buf)
--       end
--     end
--   end
--
--   -- Otherwise, create a new terminal buffer and name it
--   vim.api.nvim_command("belowright split")                 -- horizontal split
--   vim.api.nvim_command("terminal C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64")
--   vim.api.nvim_command("file MSYS2_UCRT64")                 -- mark the buffer
--   
--   -- Enter insert mode in the terminal
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), 'n', true)
-- end
--
-- -- 3) Map it to <Leader>mt (or whatever you like)
-- vim.keymap.set("n", "<Leader>mt", toggle_msys2, { desc = " Toggle MSYS2 UCRT64 Bash" })

-- top of init.lua, not inside any conditional
vim.opt.hidden      = true
vim.opt.shell       = "C:/msys64/usr/bin/bash.exe"
vim.opt.shellcmdflag= "-c"
vim.opt.shellquote  = ""
vim.opt.shellxquote = ""
vim.opt.shellslash  = true

-- These two make :!echo a actually invoke bash -c 'echo a' correctly:
vim.opt.shellredir  = ">%s 2>&1"
vim.opt.shellpipe   = "2>&1| tee %s"
