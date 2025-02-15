return {
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
	  "chentoast/marks.nvim",
	  event = "VeryLazy",
	  opts = {},
	},
}
