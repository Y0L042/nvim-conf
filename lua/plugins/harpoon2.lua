return {
        {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        config = function()
            require("harpoon").setup({
                global_settings = {
                    save_on_toggle = false, -- Do not auto-save files on toggle
                    save_on_change = true, -- Save changes when switching files
                },
            })

            local harpoon = require("harpoon")

            -- REQUIRED
            harpoon:setup()
            -- REQUIRED

            local function add_file_with_message()
                mark.add_file()
                print("Mark added") -- Echo the message
            end

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() print("Page Harpooned") end)
            vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<leader>ho", function() harpoon:list():prev() print("previous harpooned page") end)
            vim.keymap.set("n", "<leader>hi", function() harpoon:list():next() print("next harpooned page") end)

            vim.keymap.set("n", "<leader>hr", function()
              require("harpoon.mark").rm_file()
            end, { desc = "Remove current file from Harpoon" })

        end,
    },
}
