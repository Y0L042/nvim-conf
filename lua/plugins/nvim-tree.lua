return {

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
      -- Custom file name formatter
      local function custom_name_formatter(name)
        local max_len = 20 -- Set the max length for file names
        if #name <= max_len then
          return name
        end
        local ext_index = name:find("%.[^%.]*$") or #name + 1
        local prefix = name:sub(1, math.floor(max_len / 2) - 3)          -- Beginning part
        local suffix = name:sub(ext_index - (math.floor(max_len / 2) - 3)) -- End part + extension
        return prefix .. "..." .. suffix
      end

      local function label(path)
        path = path:gsub(os.getenv 'HOME', '~', 1)
        return path:gsub('([a-zA-Z])[a-z0-9]+', '%1') ..
            (path:match '[a-zA-Z]([a-z0-9]*)$' or '')
      end
      local api = require 'nvim-tree.api'

      require("nvim-tree").setup {
        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
        },
        experimental = {
          use_libuv_file_watcher = true,
        },
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
          highlight_opened_files = "name",
          highlight_git = true,
        },
        view = {
          adaptive_size = true,
          width = {
            min = 30,
            max = 75,
          },
          side = "left",
          number = true,
          relativenumber = true,
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- Custom mappings
          vim.keymap.set("n", "<A-v>", api.node.open.vertical, { buffer = bufnr, noremap = true, silent = true })
          vim.keymap.set("n", "<A-s>", api.node.open.horizontal, { buffer = bufnr, noremap = true, silent = true })

          -- Update status line with hovered file name
          local function update_statusline()
            local node = api.tree.get_node_under_cursor()
            if node and node.name then
              vim.cmd("echo '" .. node.name .. "'")
            else
              vim.cmd("echo ''")
            end
          end

          -- Hook into cursor movement
          -- vim.api.nvim_create_autocmd("CursorMoved", {
          --   buffer = bufnr,
          --   callback = update_statusline,
          -- })
        end,
      }

      vim.api.nvim_set_keymap("n", "<A-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = 'NvimTree*',
        callback = function()
          local api = require('nvim-tree.api')
          local view = require('nvim-tree.view')

          if not view.is_visible() then
            api.tree.open()
          end
        end,
      })


      vim.api.nvim_create_autocmd("SessionLoadPost", {
        callback = function()
          vim.defer_fn(function()                             -- Defer to allow nvim-tree to initialize properly
            local first_buf = vim.fn.bufname(vim.fn.bufnr("%")) -- Get the name of the current (first) buffer
            if first_buf ~= "" then                           -- If there is a file open
              vim.cmd("NvimTreeFindFile")                     -- Run NvimTreeFindFile to highlight the file in nvim-tree
            end
          end, 500)                                           -- Adjust delay if necessary
        end,
      })
    end,
  },
}
