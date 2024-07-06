return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

   {
  "christoomey/vim-tmux-navigator",
    lazy = false,
},
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "prettierd",
        "tailwindcss-language-server",
        "typescript-language-server",
        "prisma-language-server",
        "css-lsp"
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "configs.null-ls"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
{
    "nvim-tree/nvim-web-devicons",
    event = { "VeryLazy" },
    dependencies = {
        "Allianaab2m/nvim-material-icon-v3",
    },
    config = function()
        require("nvim-web-devicons").setup({
            override = require("nvim-material-icon").get_icons()
        })
    end
}
}
