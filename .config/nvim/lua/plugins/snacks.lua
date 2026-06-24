return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
        },

        -- multi = { "buffers", "recent", "files" },
        -- format = "file", -- use `file` format for all sources
        -- matcher = {
        --   cwd_bonus = true, -- boost cwd matches
        --   frecency = true, -- use frecency boosting
        --   sort_empty = true, -- sort even when the filter is empty
        -- },
        -- transform = "unique_file",
      },
    },
    keys = {
      { "<leader><leader>", LazyVim.pick("files", { root = false }), desc = "Find Files" },
      { "<leader>/", LazyVim.pick("grep", { root = false }), desc = "Grep " },
    },
  },
}
