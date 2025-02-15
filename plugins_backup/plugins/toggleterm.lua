return {
    {
      {
          'akinsho/toggleterm.nvim', version = "*",
          opts = {
          },
          config = function()
              require("toggleterm").setup{
                  open_mapping = [[<c-\>]],
              }
          end
      }
    }
}
