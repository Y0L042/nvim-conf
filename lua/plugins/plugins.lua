-- plugins.lua

return { 
  -- [[ Color Schemes ]]
  -- Add Gruvbox color scheme
  {
    'morhetz/gruvbox',
    as = 'gruvbox',
    config = function()
      -- Uncomment to set Gruvbox as the default colorscheme
      -- vim.cmd('colorscheme gruvbox')
    end,
  },
  -- Add Dracula color scheme
  {
    'dracula/vim',
    as = 'dracula',
    config = function()
      -- Uncomment to set Dracula as the default colorscheme
      -- vim.cmd('colorscheme dracula')
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    as = 'nightfox',
    config = function()
      -- vim.cmd('colorscheme nightfox')
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      -- vim.cmd('colorscheme carbonfox')
    end,
  },
  {
    "ayu-theme/ayu-vim",
    as = 'ayu',
    config = function()
      -- Enable true colors support
      vim.o.termguicolors = true
  
      -- Set the ayucolor variable to choose the theme variant
      vim.g.ayucolor = "dark"  -- Options: "light", "mirage", "dark"
  
      -- Apply the colorscheme
      vim.cmd('colorscheme ayu')
    end,
  },


  -- [[ TreeSitter  ]]
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- Ensure these parsers are installed
        ensure_installed = { "c" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },




  -- [[ Telescope ]]
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
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






  -- Add ctrlsf.vim
  {
    'dyng/ctrlsf.vim',
    config = function()
      -- Configure ctrlsf.vim here
      vim.g.ctrlsf_backend = 'rg'
      vim.g.ctrlsf_backend_program = 'C:\\msys64\\ucrt64\\bin\\rg.exe'  -- Update this path to your rg.exe location
      vim.g.ctrlsf_default_root = 'project'
      vim.g.ctrlsf_auto_close = 1
      vim.g.ctrlsf_position = 'bottom'
      vim.g.ctrlsf_winsize = '40%'
      vim.g.ctrlsf_extra_root_markers = { '.git', '.hg', '.svn', 'Makefile', 'package.json' }
      vim.g.ctrlsf_auto_focus = { at = 'done', duration_less_than = 1000 }

      -- Ignore tags file
      vim.g.ctrlsf_ignore_file = { 'tags' }

      -- Key mappings for ctrlsf.vim
      vim.api.nvim_set_keymap('n', 'SF', ':CtrlSF ', { noremap = true, silent = false })
      vim.api.nvim_set_keymap('n', 'SO', ':CtrlSFOpen<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'SC', ':CtrlSFClose<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'ST', ':CtrlSFToggle<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'SR', ':CtrlSFRefresh<CR>', { noremap = true, silent = true })
    end
  },




  {
    "mg979/vim-visual-multi",
    branch = "master",
  },









--  -- Add cmp-nvim-lsp plugin
--  {
--    'hrsh7th/cmp-nvim-lsp',
--  },
--
--  -- Add nvim-cmp plugin and configure it
--  {
--    'hrsh7th/nvim-cmp',
--    config = function()
--      local cmp = require('cmp')
--      cmp.setup({
--        snippet = {
--          expand = function(args)
--            vim.fn["vsnip#anonymous"](args.body)
--          end,
--        },
--        sources = cmp.config.sources({
--          { name = 'nvim_lsp_signature_help' },
--        }),
--        mapping = {
--          ['<C-Space>'] = cmp.mapping.complete(), -- Keybinding to manually trigger completion
--        },
--      })
--    end,
--  },
--
--  -- Add nvim-lspconfig plugin to configure LSP servers
--  {
--    'neovim/nvim-lspconfig',
--    config = function()
--      local nvim_lsp = require('lspconfig')
--      local capabilities = require('cmp_nvim_lsp').default_capabilities()
--      local signature_help_enabled = true
--
--      -- Function to toggle signature help
--      function ToggleSignatureHelp()
--        signature_help_enabled = not signature_help_enabled
--        if signature_help_enabled then
--          print("Signature Help: Enabled")
--        else
--          print("Signature Help: Disabled")
--        end
--      end
--
--      -- Configure clangd LSP server
--      nvim_lsp.clangd.setup {
--        capabilities = capabilities,
--        on_attach = function(client, bufnr)
--          -- Enable signature help in insert mode if globally enabled
--          vim.api.nvim_create_autocmd("CursorHoldI", {
--            buffer = bufnr,
--            callback = function()
--              if signature_help_enabled then
--                vim.lsp.buf.signature_help()
--              end
--            end,
--          })
--
--          -- Map key to toggle signature help
--          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>th', '<cmd>lua ToggleSignatureHelp()<CR>', { noremap = true, silent = true })
--        end,
--      }
--
--      
--
--      -- Add more language servers as needed
--      -- nvim_lsp.tsserver.setup {
--      --   capabilities = capabilities,
--      -- }
--    end,
--  },








  -- [[ Mason ]]
  -- {
  --   "williamboman/mason.nvim",
  --   config = function()
  --     require("mason").setup {}
  --   end,
  -- },
  -- -- Add mason-lspconfig to automatically install LSP servers
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   config = function()
  --     require("mason-lspconfig").setup({
  --       ensure_installed = { "clangd" },
  --     })
  --   end,
  -- },


  

--   -- Add nvim-lspconfig
--   {
--     'neovim/nvim-lspconfig',
--     config = function()
--       require'lspconfig'.clangd.setup{
--         settings = {
--           clangd = {
--             InlayHints = {
--               Designators = true,
--               Enabled = true,
--               ParameterNames = true,
--               DeducedTypes = true,
--             },
--             fallbackFlags = { "-std=c++20" },
--           },
--         }
--       }
--     end
--   },

--  -- Add lsp_extensions.nvim
--   {
--     'nvim-lua/lsp_extensions.nvim',
--     opts = {
--       inlay_hints = { enabled = true },
--     },
--     config = function()
--     end,
--   },

  -- {
  --   "MysticalDevil/inlay-hints.nvim",
  --   event = "LspAttach",
  --   dependencies = { "neovim/nvim-lspconfig" },
  --   config = function()
  --       require("inlay-hints").setup({})
  --   end
  -- },


    -- -- Lazy function signature hints
    -- {
    --   "ray-x/lsp_signature.nvim",
    --   config = function() 
    --     require('lsp_signature').setup({
    --       bind = true,
    --       floating_window = true,
    --       toggle_key = "<M-m>",
    --       handler_opts = {
    --         border = "rounded"
    --       },
    --     }, bufnr) end,
    -- },


  -- -- Lazy function signature hints
  -- {
  --   'ray-x/lsp_signature.nvim',
  --   config = function()
  --     require "lsp_signature".setup({
  --       bind = true,
  --       floating_window = true,
  --       floating_window_above_cur_line = true,
  --       floating_window_off_x = 0,
  --       floating_window_off_y = 4,
  --       hint_enable = false,
  --       toggle_key = '<M-k>', -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
  --       -- toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
  --       -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
  --       -- may not popup when typing depends on floating_window setting
  --       transparency = 90,
  --       handler_opts = {
  --         border = "rounded",
  --       },
  --     }, bufnr)

  --     vim.keymap.set(
  --       { 'n' }, '<M-k>', function()
  --         require('lsp_signature').toggle_float_win()
  --       end, 
  --       { silent = true, noremap = true, desc = 'toggle signature' }
  --     )

  --   end
  -- },




  -- -- Add nvim-lspconfig to configure LSP servers
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     -- Automatically install LSPs and related tools to stdpath for Neovim
  --     { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
  --     'williamboman/mason-lspconfig.nvim',
  --     'WhoIsSethDaniel/mason-tool-installer.nvim',

  --     -- Useful status updates for LSP.
  --     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
  --     { 'j-hui/fidget.nvim', opts = {} },
  --   },
  --   config = function()
  --     local lspconfig = require("lspconfig")

  --     vim.api.nvim_create_autocmd('LspAttach', {
  --       group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  --       callback = function(event)
  --         -- NOTE: Remember that Lua is a real programming language, and as such it is possible
  --         -- to define small helper and utility functions so you don't have to repeat yourself.
  --         --
  --         -- In this case, we create a function that lets us more easily define mappings specific
  --         -- for LSP related items. It sets the mode, buffer and description for us each time.
  --         local map = function(keys, func, desc)
  --           vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  --         end

  --         -- Jump to the definition of the word under your cursor.
  --         --  This is where a variable was first declared, or where a function is defined, etc.
  --         --  To jump back, press <C-t>.
  --         map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  --         -- Find references for the word under your cursor.
  --         map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  --         -- Jump to the implementation of the word under your cursor.
  --         --  Useful when your language has ways of declaring types without an actual implementation.
  --         map('gY', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  --         -- Jump to the type of the word under your cursor.
  --         --  Useful when you're not sure what type a variable is and you want to see
  --         --  the definition of its *type*, not where it was *defined*.
  --         map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  --         -- Fuzzy find all the symbols in your current document.
  --         --  Symbols are things like variables, functions, types, etc.
  --         map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  --         -- Fuzzy find all the symbols in your current workspace.
  --         --  Similar to document symbols, except searches over your entire project.
  --         map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  --         -- Rename the variable under your cursor.
  --         --  Most Language Servers support renaming across files, etc.
  --         map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  --         -- Execute a code action, usually your cursor needs to be on top of an error
  --         -- or a suggestion from your LSP for this to activate.
  --         map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  --         -- WARN: This is not Goto Definition, this is Goto Declaration.
  --         --  For example, in C this would take you to the header.
  --         map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  --         -- The following two autocommands are used to highlight references of the
  --         -- word under your cursor when your cursor rests there for a little while.
  --         --    See `:help CursorHold` for information about when this is executed
  --         --
  --         -- When you move your cursor, the highlights will be cleared (the second autocommand).
  --         local client = vim.lsp.get_client_by_id(event.data.client_id)
  --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
  --           local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
  --           vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.document_highlight,
  --           })

  --           vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.clear_references,
  --           })

  --           vim.api.nvim_create_autocmd('LspDetach', {
  --             group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
  --             callback = function(event2)
  --               vim.lsp.buf.clear_references()
  --               vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
  --             end,
  --           })
  --         end

  --         -- The following code creates a keymap to toggle inlay hints in your
  --         -- code, if the language server you are using supports them
  --         --
  --         -- This may be unwanted, since they displace some of your code
  --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
  --           map('<leader>th', function()
  --             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
  --           end, '[T]oggle Inlay [H]ints')
  --         end
  --       end,
  --     })


  --     lspconfig.clangd.setup({
  --       on_attach = function(client, bufnr)
  --         -- Enable completion triggered by <c-x><c-o>
  --         vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  --         -- Mappings.
  --         local opts = { noremap=true, silent=true }  -- Define options for the key mappings: no remapping and silent execution

  --         -- Key mappings for LSP functions
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)  -- Go to the definition of the symbol under the cursor
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)  -- Go to the declaration of the symbol under the cursor
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)  -- Show hover information about the symbol under the cursor
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)  -- Go to the implementation of the symbol under the cursor
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)  -- Show signature help for the symbol under the cursor
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)  -- Add the current workspace folder
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)  -- Remove the current workspace folder
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'wl', '<cmd>lua vim.lsp.buf.list_workspace_folders()<CR>', opts)  -- List all workspace folders
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)  -- Go to the type definition of the symbol under the cursor
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)  -- Rename the symbol under the cursor
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)  -- List all references to the symbol under the cursor
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)  -- Show diagnostics for the current line
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)  -- Go to the previous diagnostic
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)  -- Go to the next diagnostic
  --         -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)  -- Set the location list with all diagnostics
  --         -- vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]  -- Create a command `:Format` to format the current buffer using LSP
          
  --       end,
  --       flags = {
  --         debounce_text_changes = 150,
  --       },
  --       cmd = { 
  --         "clangd", 
  --         "--clang-tidy" 
  --       },  -- Enable clang-tidy
  --       init_options = {
  --         clangdFileStatus = true,  -- Show file status
  --         -- Customize clangd arguments
  --         arguments = {
  --           "--std=c99",  -- Specify the C standard
  --         },
  --       },  
  --       settings = {
  --         clangd = {
  --           -- Adjust your clangd settings here
  --           diagnostics = {
  --             -- suppress = { '*' },
  --             severity = {
  --               -- Customize the severity of diagnostics
  --               ["error"] = "E",
  --               ["warning"] = "W",
  --               ["information"] = "I",
  --               ["hint"] = "H",
  --             },
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },

  -- [[ END ]]
}
