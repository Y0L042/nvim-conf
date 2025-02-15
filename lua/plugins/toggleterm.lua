return {
      {
          'akinsho/toggleterm.nvim',
          event = "VeryLazy",
          version = "*",
          config = function()
              require("toggleterm").setup{
                  direction = "float",
                  autochdir = true,
              }

            vim.keymap.set({ 'n', 't' }, "<C-\\>", function ()
                local shellflag = vim.o.shellcmdflag
                vim.o.shellcmdflag = '-s'
                vim.cmd.ToggleTerm()
                vim.o.shellcmdflag = shellflag
            end)
          end
      }
}

-- return {
--     {
--         'akinsho/toggleterm.nvim',
--         version = "*",
--         config = function ()
--             local toggleterm = require 'toggleterm'
--             toggleterm.setup {}
--
--             vim.keymap.set({ 'n', 't' }, "<C-\\>", function ()
--                 vim.o.shellcmdflag = '-s'
--                 vim.cmd.ToggleTerm()
--                 vim.o.shellcmdflag = '-c'
--             end)
--         end
--     }
-- }
