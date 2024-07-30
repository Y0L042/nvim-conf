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
      vim.cmd('colorscheme dracula')
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





  -- [[ END ]]
}