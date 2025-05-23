-- File-specific Settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cpp" },
    callback = function()
        -- Set settings for web-related files
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
    end,
})
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
    pattern = { "c", "cpp", "h", "hpp" },
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


vim.api.nvim_create_autocmd("FileType", {
    pattern = { "h", "hpp", "c", "cpp", "cxx" },
    callback = function()
        vim.opt_local.autoindent = true
        vim.opt_local.smartindent = false

        -- Function to switch between header and source files
        function switch_source_header()
            -- Update (save) the current file before switching
            vim.cmd('update')

            local filepath = vim.fn.expand('%:p')
            local filename = vim.fn.expand('%:t')
            local dir = vim.fn.expand('%:p:h')
            local base = vim.fn.expand('%:t:r')

            local header_extensions = { '.h', '.hpp' }
            local source_extensions = { '.c', '.cpp', '.cc', '.cxx' }

            local current_ext = vim.fn.expand('%:e')
            local target_files = {}

            -- Save the current position in a global table
            local file_pos = vim.g.file_positions or {}
            file_pos[filepath] = { line = vim.fn.line('.'), col = vim.fn.col('.') }
            vim.g.file_positions = file_pos

            if vim.tbl_contains(header_extensions, '.' .. current_ext) then
                for _, ext in ipairs(source_extensions) do
                    table.insert(target_files, dir .. '/' .. base .. ext)
                end
            elseif vim.tbl_contains(source_extensions, '.' .. current_ext) then
                for _, ext in ipairs(header_extensions) do
                    table.insert(target_files, dir .. '/' .. base .. ext)
                end
            else
                vim.notify("Not a recognized header/source file.", vim.log.levels.WARN)
                return
            end

            for _, file in ipairs(target_files) do
                if vim.fn.filereadable(file) == 1 then
                    -- vim.cmd('edit ' .. vim.fn.fnameescape(file))
                    vim.cmd('badd ' .. vim.fn.fnameescape(file))
                    vim.cmd('buffer ' .. vim.fn.fnameescape(file))
                    -- Restore cursor position in the target file
                    local target_pos = file_pos[file]
                    if target_pos then
                        vim.fn.cursor(target_pos.line, target_pos.col)
                    end
                    return
                end
            end

            vim.notify("Corresponding file not found.", vim.log.levels.INFO)
        end

        -- Function to switch files and set search
        function switch_and_search()
            -- Update (save) the current file before switching and searching
            vim.cmd('update')

            local mode = vim.fn.mode()
            if mode == 'v' or mode == 'V' or mode == '\22' then
                vim.cmd('noau normal! gv"zy')
                vim.fn.setreg('/', vim.fn.getreg('z'))
            else
                vim.fn.setreg('/', vim.fn.expand('<cword>'))
            end

            switch_source_header()

            -- Optional: Jump to the first search match
            if vim.fn.search(vim.fn.getreg('/'), 'n') == 0 then
                vim.notify("Search match not found.", vim.log.levels.INFO)
            else
                vim.cmd('normal! nzt')
            end
        end

        -- Key mappings for switching files

        -- F4: Switch between header and source
        vim.api.nvim_set_keymap('n', '<F4>', '<cmd>lua switch_source_header()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('i', '<F4>', '<Esc><cmd>lua switch_source_header()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('v', '<F4>', '<Esc><cmd>lua switch_source_header()<CR>', { noremap = true, silent = true })

        -- Shift+F4: Switch and search
        vim.api.nvim_set_keymap('n', '<S-F4>', '<cmd>lua switch_and_search()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('i', '<S-F4>', '<Esc><cmd>lua switch_and_search()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('v', '<S-F4>', '<Esc><cmd>lua switch_and_search()<CR>', { noremap = true, silent = true })



    end,
})
