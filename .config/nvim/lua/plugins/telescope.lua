return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader><space>",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.getcwd() })
      end,
      desc = "Find Files (current directory)",
    },
  },
}
