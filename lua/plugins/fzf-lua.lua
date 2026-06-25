return {
    --[[
        Hotkey	            Telescope	                fzf-lua
        -------------------------------------------------------
        <leader>sh	        help_tags	                helptags
        <leader>sk	        keymaps	                    keymaps
        <leader>ss	        builtin	                    builtin
        <leader>sw	        grep_string	                grep_cword
        <leader>sd	        diagnostics	                diagnostics_workspace
        <leader>sr	        resume	                    resume
        <leader><leader>	oldfiles	                oldfiles
        <leader>sj	        jumplist	                jumps
        <leader>s.	        buffers	                    buffers
        <leader>sD	        lsp_definitions	            lsp_definitions
        <leader>sT	        lsp_type_definitions	    lsp_typedefs
        <leader>sR	        lsp_references (no decl)	lsp_references({ includeDeclaration = false })
        <leader>sI	        lsp_implementations	        lsp_implementations
        <leader>sf	        find_files	                files
        <leader>sg	        live_grep	                live_grep
        <leader>/	        current_buffer_fuzzy_find	blines
        <leader>sn	        nvim config files	        files cwd=config
        <leader>sp	        solution-wide files	        files at solution root
        <leader>sP	        pick project then search	vim.ui.select + files
    ]]

  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      -- Filename-first display (matches the old Telescope path_display).
      defaults = {
        formatter = "path.filename_first",
      },
      winopts = {
        -- Previewer disabled by default for performance (matches Telescope).
        preview = { hidden = true },
      },
      files = {
        actions = {
          -- <A-v> to open in a vertical split (matches the old Telescope mapping).
          ["alt-v"] = fzf.actions.file_vsplit,
        },
      },
    })

    -- Helper: find the solution root for the *p mappings (walks up for a marker).
    local function normalize_path(path)
      return path:gsub("\\", "/")
    end

    local function find_solution_root()
      if vim.g.solution_root then
        return normalize_path(vim.g.solution_root)
      end
      local markers = { "*.sln", ".git", "CMakeLists.txt" }
      local dir = vim.fn.expand("%:p:h")
      for _ = 1, 10 do
        for _, marker in ipairs(markers) do
          if #vim.fn.glob(dir .. "/" .. marker) > 0 then
            return normalize_path(dir)
          end
        end
        local parent = vim.fn.fnamemodify(dir, ":h")
        if parent == dir then break end
        dir = parent
      end
      return normalize_path(vim.loop.cwd())
    end

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    -- [[ Keymaps — matching the previous Telescope bindings ]]
    map("<leader>sh", fzf.helptags, "[S]earch [H]elp")
    map("<leader>sk", fzf.keymaps, "[S]earch [K]eymaps")
    map("<leader>ss", fzf.builtin, "[S]earch [S]elect FzfLua")
    map("<leader>sw", fzf.grep_cword, "[S]earch current [W]ord")
    map("<leader>sd", fzf.diagnostics_workspace, "[S]earch [D]iagnostics")
    map("<leader>sr", fzf.resume, "[S]earch [R]esume")
    map("<leader><leader>", fzf.oldfiles, "[S]earch Recent Files")
    map("<leader>sj", fzf.jumps, "[S]earch [J]umps")
    map("<leader>s.", fzf.buffers, "[ ] Find existing buffers")

    map("<leader>sD", fzf.lsp_definitions, "[S]earch LSP [D]efinitions")
    map("<leader>sT", fzf.lsp_typedefs, "[S]earch LSP [T]ype definitions")
    map("<leader>sR", function()
      fzf.lsp_references({ includeDeclaration = false })
    end, "[S]earch LSP [R]eferences")
    map("<leader>sI", fzf.lsp_implementations, "[S]earch LSP [I]mplementations")

    -- File search / live grep
    map("<leader>sf", fzf.files, "[S]earch [F]iles")
    map("<leader>sg", fzf.live_grep, "[S]earch by [G]rep")

    -- Fuzzily search in the current buffer
    map("<leader>/", fzf.blines, "[/] Fuzzily search in current buffer")

    -- Search Neovim config files
    map("<leader>sn", function()
      fzf.files({ cwd = vim.fn.stdpath("config") })
    end, "[S]earch [N]eovim files")

    -- Solution-wide file search
    map("<leader>sp", function()
      fzf.files({ prompt = "Solution Files❯ ", cwd = find_solution_root() })
    end, "[S]earch [P]roject (solution-wide)")

    -- Pick a top-level project dir, then search files scoped to it
    map("<leader>sP", function()
      local root = find_solution_root()
      local dirs = vim.fn.glob(root .. "/*/", false, true)
      local projects = {}
      for _, d in ipairs(dirs) do
        local name = vim.fn.fnamemodify(d:gsub("/$", ""), ":t")
        table.insert(projects, { name = name, dir = normalize_path(d:gsub("/$", "")) })
      end
      if #projects == 0 then
        vim.notify("No project directories found under " .. root, vim.log.levels.WARN)
        return
      end
      vim.ui.select(projects, {
        prompt = "Select project:",
        format_item = function(item) return item.name end,
      }, function(choice)
        if not choice then return end
        fzf.files({ prompt = "Files: " .. choice.name .. "❯ ", cwd = choice.dir })
      end)
    end, "[S]earch in [P]roject (pick first)")
  end,
}
