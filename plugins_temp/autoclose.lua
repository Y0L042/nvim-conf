return {
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

}
