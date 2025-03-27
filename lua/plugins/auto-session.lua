return {
    {
        "rmagatti/auto-session",
        event = "VeryLazy",
          ---enables autocomplete for opts
          ---@module "auto-session"
          ---@type AutoSession.Config
        config = function()
            require("auto-session").setup {
                suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
                session_lens = {
                    buftypes_to_ignore = {},
                    load_on_setup = true,
                    theme_conf = { border = true },
                    previewer = false,
                },
                auto_save = false,

            }

            vim.keymap.set("n", "<Leader>ls", require("auto-session.session-lens").search_session, {
                noremap = true,
            })

          vim.api.nvim_set_keymap('n', '<F3>', ':SessionSave<CR>', { noremap = true, silent = true })
          vim.api.nvim_set_keymap('i', '<F3>', '<Esc>:SessionSave<CR>i', { noremap = true, silent = true })
        vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end
    },
}

