return {
    -- [[ Telescope Configuration ]]
    {
      -- Fuzzy Finder (files, lsp, etc)
      'nvim-telescope/telescope.nvim',
      event = 'VeryLazy',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { -- Telescope FZF Native for better sorting
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make', -- Only run `make` when installing/updating the plugin
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 
          'nvim-tree/nvim-web-devicons', 
          enabled = vim.g.have_nerd_font 
        }, -- Requires a Nerd Font for icons
      },
      config = function()
        -- Define patterns to ignore (exclude)
        local ignore_patterns = {
          "%.exe$", "%.dll$", "%.so$", "%.dylib$",
          "%.o$", "%.obj$", "%.log$", "%.pdb$",
          "%.cmake$", "%.sln$", "%.vcxproj$", "%.vcxproj%.user$",
          "%.git/", "%.svn/", "%.idea/", "%.vscode/",
          "build/", "bin/", "out/", "dist/",
          "%.tmp$", "%.bak$", "%.tlog", "%.idb", "%.sarif"
        }

        -- Define patterns to allow (include)
        local allow_patterns = {
          -- Source code files
          "*.lua", "*.py", "*.js", "*.ts", "*.html", "*.css", "*.scss",
          "*.cpp", "*.inl", "*.gd", "*.c", "*.h", "*.hpp",
          "*.java", "*.cs", "*.rb", "*.go", "*.rs", "*.sh",
          "*.bat", "*.php", "*.dart", "*.swift",

          -- Configuration files
          "*.json", "*.yaml", "*.yml", "*.toml", "*.ini",
          "*.cfg", "*.env",

          -- Documentation files
          "*.md", "*.txt", "*.rst", "*.adoc",

          -- Build files
          "Makefile", "*.mk", "*.cmake", "*.gradle", "*.pom",

          -- Version control and meta files
          ".gitignore", "*.gitattributes", "*.gitmodules",

          -- Miscellaneous
          "*.csv", "*.tsv", "*.xml", "*.sql", "*.log",
        }

        -- [[ Custom path_display Functions ]]
        local function normalize_path(path)
          return path:gsub("\\", "/")
        end

        local function normalize_cwd()
          return normalize_path(vim.loop.cwd()) .. "/"
        end

        local function is_subdirectory(cwd, path)
          return string.lower(path:sub(1, #cwd)) == string.lower(cwd)
        end

        local function split_filepath(path)
          local normalized_path = normalize_path(path)
          local normalized_cwd = normalize_cwd()
          local filename = normalized_path:match("[^/]+$")

          if is_subdirectory(normalized_cwd, normalized_path) then
            local stripped_path = normalized_path:sub(#normalized_cwd + 1, -(#filename + 1))
            return stripped_path, filename
          else
            local stripped_path = normalized_path:sub(1, -(#filename + 1))
            return stripped_path, filename
          end
        end

        local function path_display(_, path)
          local stripped_path, filename = split_filepath(path)
          if filename == stripped_path or stripped_path == "" then
            return filename
          end
          return string.format("%s\t | \t%s", filename, stripped_path)
        end

        -- [[ Configure Telescope ]]
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')

        require('telescope').setup {
          defaults = {
            prompt_prefix = "🔍 ",
            selection_caret = "➤ ",
            path_display = path_display, -- Use the custom path_display function
            file_ignore_patterns = ignore_patterns, -- Exclude unwanted files/directories

            mappings = {
              i = {}, -- Insert mode mappings
              n = {
                ["<A-v>"] = actions.file_vsplit, -- Open selected file in a vertical split
              },
            },
          },
          pickers = {
            find_files = {
              -- Optionally, you can customize specific pickers here
            },
            live_grep = {
              -- Optionally, you can customize specific pickers here
            },
          },
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown(),
            },
          },
        }

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- Shortcut to access Telescope's built-in functions
        local builtin = require 'telescope.builtin'

        -- Keymaps for various Telescope functions
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader><leader>', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = '[S]earch [J]umps' })
        vim.keymap.set('n', '<leader>s.', builtin.buffers, { desc = '[ ] Find existing buffers' })

        vim.keymap.set('n', '<leader>sD', builtin.lsp_definitions, { desc = '[S]earch LSP [D]efinitions' })
        vim.keymap.set('n', '<leader>sT', builtin.lsp_type_definitions, { desc = '[S]earch LSP [T]ype definitions' })
        vim.keymap.set('n', '<leader>sR', builtin.lsp_references, { desc = '[S]earch LSP [R]erferences' })
        vim.keymap.set('n', '<leader>sI', builtin.lsp_implementations, { desc = '[S]earch LSP [I]mplementations' })

        -- Keymap for searching files with allow-only patterns using `rg --files`
        vim.keymap.set('n', '<leader>sf', function()
          local find_command = { "rg", "--files", "--hidden", "--no-ignore" }
          for _, pattern in ipairs(allow_patterns) do
            table.insert(find_command, "--glob")
            table.insert(find_command, pattern)
          end
          require('telescope.builtin').find_files {
            find_command = find_command,
          }
        end, { desc = '[S]earch [F]iles (allow-only)' })

        -- Keymap for live grep with allow-only patterns using `rg`
        vim.keymap.set('n', '<leader>sg', function()
          local grep_args = { "--hidden", "--no-ignore" }
          for _, pattern in ipairs(allow_patterns) do
            table.insert(grep_args, "--glob")
            table.insert(grep_args, pattern)
          end
          require('telescope.builtin').live_grep {
            additional_args = function()
              return grep_args
            end,
          }
        end, { desc = '[S]earch by [G]rep (allow-only)' })

        -- Advanced example: Fuzzily search in the current buffer with a dropdown theme
        vim.keymap.set('n', '<leader>/', function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            -- winblend = 10,
            previewer = true,
          })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- Search within open files
        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end, { desc = '[S]earch [/] in Open Files' })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set('n', '<leader>sn', function()
          builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })
      end,
    },
}
