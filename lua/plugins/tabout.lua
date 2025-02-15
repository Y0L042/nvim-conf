return {
  {
    'abecodes/tabout.nvim',
    config = function()
      require('tabout').setup {
        tabkey = '<A-t>', -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = '<A-S-t>', -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = false, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = '<Tab>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = '<S-Tab>', -- reverse shift default action,
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
        ignore_beginning = false,
        exclude = {} -- tabout will ignore these filetypes
      }
    end,
    dependencies = { -- These are optional
      "nvim-treesitter/nvim-treesitter",
    },
    opt = true,  -- Set this to true if the plugin is optional
    -- event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
    event = "VeryLazy",
    priority = 1000,
  },
}
