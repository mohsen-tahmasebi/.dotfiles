return {
  "inhesrom/remote-ssh.nvim",
  branch = "master",
  dependencies = {
    "inhesrom/telescope-remote-buffer",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
    "rcarriga/nvim-notify",
  },
  config = function()
    -- FIX: You cannot leave this empty or commented out.
    -- The plugin requires these strings to avoid passing 'nil' to the keymapper.
    require("telescope-remote-buffer").setup({
      fzf = "<leader>fz",
      match = "<leader>gb",
      oldfiles = "<leader>rb",
    })

    -- Dynamically resolve capabilities for LazyVim (Blink or CMP)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if pcall(require, "blink.cmp") then
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    elseif pcall(require, "cmp_nvim_lsp") then
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    end

    -- Setup Remote SSH
    require("remote-ssh").setup({
      on_attach = function(client, bufnr)
        -- LazyVim automatically applies keymaps (like 'gd' or 'K') when an LSP attaches.
      end,

      capabilities = capabilities,

      -- Define which language servers to run remotely based on filetype.
      -- (Make sure these binaries are installed on your remote server!)
      filetype_to_server = {
        python = { "pylsp" },
        c = { "clangd" },
        cpp = { "clangd" },
        rust = { "rust-analyzer" },
        lua = { "lua-language-server" },
      },
    })
  end,
}
