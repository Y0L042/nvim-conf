-- plugins.lua

local function install_cascadia_mono()
  -- Check if Cascadia Mono is installed
  local font_installed = os.execute("fc-list | grep -i 'Cascadia Mono' > /dev/null 2>&1")
  
  if font_installed ~= 0 then
    -- Cascadia Mono is not installed, so install it
    print("Cascadia Mono font not found. Installing...")

    os.execute([[
      wget -q https://github.com/microsoft/cascadia-code/releases/download/v2306.17/CascadiaCode-2306.17.zip -O /tmp/CascadiaCode.zip
      unzip -q /tmp/CascadiaCode.zip -d /tmp/CascadiaCode
      mkdir -p ~/.local/share/fonts
      cp /tmp/CascadiaCode/ttf/*.ttf ~/.local/share/fonts/
      fc-cache -fv ~/.local/share/fonts
      rm -rf /tmp/CascadiaCode.zip /tmp/CascadiaCode
    ]])
    
    print("Cascadia Mono font installed successfully.")
  else
    print("Cascadia Mono font is already installed.")
  end
end

-- Call the function to check and install Cascadia Mono
--install_cascadia_mono()


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

		-- cindent prevents textwidth from working. treesitter#indent does not
		vim.opt.cindent = false
		vim.opt.indentexpr = 'nvim_treesitter#indent()'
		  vim.opt.foldmethod = "expr"
		  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		  vim.opt.foldcolumn = "0"
		  vim.opt.foldtext = ""
		  vim.opt.foldlevel = 99
		  vim.opt.foldnestmax = 3

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
        local actions = require('telescope.actions')
        require('telescope').setup {
          -- You can put your default mappings / updates / etc. in here
          -- All the info you're looking for is in `:help telescope.setup()`
          defaults = {
            -- Default configuration options
            prompt_prefix = "🔍 ",
            selection_caret = "➤ ",
            path_display = { "smart" },
            mappings = {
              -- Mappings for insert mode
              i = {
                -- You can add more custom mappings here
              },
              -- Mappings for normal mode
              n = {
                ["<A-v>"] = actions.file_vsplit,   -- Open in vertical split
              },
            },
          },
          -- Move `extensions` outside of `defaults`
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
		lazy = true,
    config = function()
      -- Configure ctrlsf.vim here
      if is_env_laptop_win or is_env_laptop_wsl2 then
        vim.g.ctrlsf_backend = 'rg'
        vim.g.ctrlsf_backend_program = 'C:\\msys64\\ucrt64\\bin\\rg.exe'  -- Update this path to your rg.exe location
      end
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




--  {
--    "mg979/vim-visual-multi",
--    branch = "master",
--  },






  {
    "wfxr/minimap.vim",
		lazy = true,
    cmd = {
		"Minimap", 
		"MinimapClose", 
		"MinimapToggle", 
		"MinimapRefresh", 
		"MinimapUpdateHighlight"
	},
	  keys = {
		{ "<A-m>", ":MinimapToggle<CR>", mode = "n", noremap = true, silent = true }
	  },
    config = function()
	  vim.g.minimap_left = 0
      vim.g.minimap_width = 10
      vim.g.minimap_auto_start = 1
      vim.g.minimap_auto_start_win_enter = 1
	  vim.g.minimap_block_filetypes = {'NvimTree_1', 'nvimtree', 'netrw', 'lazy', 'NvimTree'}
	  vim.g.minimap_close_filetypes = {'NvimTree_1', 'nvimtree', 'netrw', 'lazy', 'NvimTree'}
	  vim.g.minimap_block_bufftypes = {'NvimTree_1', 'nofile'}
	  vim.g.minimap_close_bufftypes = {'NvimTree_1', 'nofile'}
    end
  },



  {
    "nvim-tree/nvim-web-devicons"
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        filters = {
          dotfiles = false,
		  custom = {},
        },
        git = {
          enable = true,
		  ignore = false,
        },
        renderer = {
          icons = {
            show = {
            git = true,
            file = true,
            folder = true,
            folder_arrow = true,
          },
        },
      },
      view = {
        width = 30,
        side = 'left',
		number = true,
		relativenumber = true,
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Custom mappings
        vim.keymap.set('n', '<A-v>', api.node.open.vertical, { buffer = bufnr, noremap = true, silent = true })
        vim.keymap.set('n', '<A-s>', api.node.open.horizontal, { buffer = bufnr, noremap = true, silent = true })
      end,
    }

      vim.api.nvim_set_keymap('n', '<A-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

    end,
  },

	{
		'tpope/vim-surround',
		config = function()
			-- Optional: Add any custom configuration for vim-surround here
		end,
	},




	{
		"numToStr/Comment.nvim",
		config = function()
			require('Comment').setup({
				opts = {
					-- add any options here
				},
				lazy = false,
			})
		end,
	},

	{ 
		"folke/flash.nvim"
	},

	{
    "lewis6991/gitsigns.nvim"
	},



	{
	  'MeanderingProgrammer/render-markdown.nvim',
	  opts = {},
	  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons

	  -- Lazy load the plugin only when a Markdown file is opened
	  ft = "markdown",
	  
	  config = function()
		-- Set up the keybinding to toggle reader mode
		vim.api.nvim_set_keymap('n', '<leader>rm', ':RenderMarkdown toggle<CR>', { noremap = true, silent = true })
	  end,
	},




	{
		'm4xshen/autoclose.nvim',
		config = function()
			require("autoclose").setup({
			   keys = {
			   },
			})        
			--vim.api.nvim_set_keymap('i', '/*', '/*  */<Left><Left><Left>', { noremap = true, silent = true })

		end,
	},





	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup({
				options = {
					theme = 'ayu_dark'
				},
			})
		end,
	},




	{
	  "chentoast/marks.nvim",
	  event = "VeryLazy",
	  opts = {},
	},

  {
    'abecodes/tabout.nvim',
    lazy = false,
    config = function()
      require('tabout').setup {
        tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = '<C-d>', -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = false, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = '`', close = '`' },
          { open = '(', close = ')' },
          { open = '[', close = ']' },
          { open = '{', close = '}' }
        },
        ignore_beginning = false, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {} -- tabout will ignore these filetypes
      }
    end,
    dependencies = { -- These are optional
      "nvim-treesitter/nvim-treesitter",
    },
    opt = true,  -- Set this to true if the plugin is optional
    event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
  },

    { 
        'Bekaboo/deadcolumn.nvim',
        config = function()
            local opts = {
                scope = 'buffer', ---@type string|fun(): integer
                ---@type string[]|fun(mode: string): boolean
                modes = function(mode)
                    return mode:find('^[nictRss\x13]') ~= nil
                end,
                blending = {
                    threshold = 0.1,
                    colorcode = '#000000',
                    hlgroup = { 'Normal', 'bg' } -- { 'Normal', 'bg' },
                },
                warning = {
                    alpha = 0.4,
                    offset = 0,
                    colorcode = '#FF0000',
                    hlgroup = { 'Error', 'bg' },
                },
                extra = {
                    ---@type string?
                    follow_tw = nil,
                },
            }
            require('deadcolumn').setup(opts) -- Call the setup function
        end,
    },























  -- [[ Mason ]]
 {
   "williamboman/mason.nvim",
   config = function()
     require("mason").setup {}
   end,
 },
 -- Add mason-lspconfig to automatically install LSP servers
 {
   "williamboman/mason-lspconfig.nvim",
		lazy = true,
   config = function()
     require("mason-lspconfig").setup({
       ensure_installed = { "clangd" },
     })
   end,
 },


  -- Add nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    config = function()
      require'lspconfig'.clangd.setup{
		cmd = { "clangd", '--background-index', '--clang-tidy' },
        settings = {
          clangd = {
            InlayHints = {
              Designators = true,
              Enabled = true,
              ParameterNames = true,
              DeducedTypes = true,
            },
            fallbackFlags = { "-std=c99" },
          },
        },
		  root_dir = require('lspconfig').util.root_pattern('compile_commands.json', '.git', '.clangd', '.clang-format'),
      }
	  
	  require("lspconfig").matlab_ls.setup({
		  single_file_support = true,
			settings = {
				matlab = {
					installPath = '/path/to/MATLAB',  -- Example: '/Applications/MATLAB_R2023b.app'
					telemetry = false,
				},
			},
	  })


      local gdscript_config = {
          capabilities = capabilities,
          settings = {},
      }
      if vim.fn.has 'win32' == 1 then
          gdscript_config['cmd'] = { 'ncat', 'localhost', os.getenv 'GDScript_Port' or '6005' }
      end
    require('lspconfig').gdscript.setup(gdscript_config)

    -- Key mappings for diagnostics
    local diagnostics_enabled = true
    vim.keymap.set('n', '<leader>td', function()
      if diagnostics_enabled then
        vim.diagnostic.disable()  -- Disable diagnostics
      else
        vim.diagnostic.enable()   -- Enable diagnostics
      end
      diagnostics_enabled = not diagnostics_enabled
    end, { silent = false, noremap = true })
    -- Additional diagnostics config if needed
    vim.diagnostic.config({
      virtual_text = true,
      signs = false,
      update_in_insert = false,
      underline = true,
	  severity_sort = true,
    })

    vim.keymap.set('i', '<C-A>', vim.lsp.buf.signature_help, { silent = false, noremap = true })

	-- Go to definition (function definition in C)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true, noremap = true })

    -- Go to definition (redundant with 'gd', but provided as per request)
    vim.keymap.set('n', '<leader>gdd', vim.lsp.buf.definition, { silent = true, noremap = true })

    -- Go to definition in horizontal split below
    vim.keymap.set('n', '<leader>gds', function()
      vim.cmd('split')  -- Open a horizontal split
      vim.lsp.buf.definition()
    end, { silent = true, noremap = true })

    -- Go to definition in vertical split to the right
    vim.keymap.set('n', '<leader>gdv', function()
      vim.cmd('vsplit')  -- Open a vertical split
      vim.lsp.buf.definition()
    end, { silent = true, noremap = true })

	vim.keymap.set("n", "]ge", vim.diagnostic.goto_next)
	vim.keymap.set("n", "[ge", vim.diagnostic.goto_prev)

    -- Key mappings for manual formatting and style checking
    vim.api.nvim_set_keymap("n", "<leader>cf", ":lua vim.lsp.buf.format()<CR>", { noremap = true, silent = false })  -- Manual format

    -- Function to populate the location list with diagnostics
    local function PopulateLocationList()
        vim.diagnostic.setloclist({ open = true })
        vim.cmd("botright 10lopen")
        vim.cmd("wincmd J")
    end
    -- Map <leader>l to populate and open the location list
    vim.keymap.set('n', '<leader>l', PopulateLocationList, { noremap = true, silent = true })

       -- ==== Basic Rename Function Start ====
        -- Basic Rename Function with Confirmation
        local function RenameWithConfirmation()
            -- Prompt the user for the new name
            vim.ui.input({ prompt = "Rename to: " }, function(new_name)
                -- Check if the user provided a non-empty name
                if new_name and new_name ~= "" then
                    -- Perform the rename using LSP
                    vim.lsp.buf.rename(new_name)
                else
                    -- Notify the user that the rename was cancelled
                    vim.notify("Rename cancelled.", vim.log.levels.WARN)
                end
            end)
        end

        -- Map the Rename function to a keybinding
        vim.keymap.set('n', '<leader>rn', RenameWithConfirmation, {
            noremap = true,
            silent = true,
            desc = "Rename Symbol with Confirmation",
        })
        -- ==== Basic Rename Function End ====

    end
  },


  -- Add nvim-cmp and its dependencies
  {
    "hrsh7th/nvim-cmp", -- Completion plugin
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer", -- Buffer completion source
      "hrsh7th/cmp-path", -- Path completion source
      "hrsh7th/cmp-cmdline", -- Command line completion source
      "hrsh7th/cmp-vsnip", -- Snippet completion source
      "hrsh7th/vim-vsnip", -- Snippet engine
    },
    config = function()
      -- Set up nvim-cmp
      local cmp = require'cmp'
      
      cmp.setup({
        completion = {
            autocomplete = false,
        },
        snippet = {
          expand = function(args)
            require('vsnip').expand(args.body) -- For vsnip users.
          end,
        },
        mapping = {
          ['<C-N>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-k>'] = cmp.mapping.select_prev_item(), -- Navigate to previous completion item
          ['<C-j>'] = cmp.mapping.select_next_item(), -- Navigate to next completion item
          ['<C-e>'] = cmp.mapping.close(), -- Close completion window
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm completion
        },
        sources = {
          { name = 'nvim_lsp' }, -- LSP completion
          { name = 'buffer' }, -- Buffer completion
          { name = 'path' }, -- Path completion
        },
      })

      -- Configure command line completion
      cmp.setup.cmdline(':', {
        sources = {
          { name = 'cmdline' }
        }
      })
    end,
  },
































}
