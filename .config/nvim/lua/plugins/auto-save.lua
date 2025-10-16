return {
  -- The maintained fork of auto-save.nvim
  "okuuva/auto-save.nvim",

  -- The plugin is enabled by default when loaded.
  -- You can use 'lazy = false' or specify events/commands for lazy loading.
  -- Since auto-save is a core utility, loading it early is fine.
  lazy = false,

  -- Use the 'opts' table for configuration
  opts = {
    -- Start auto-save when the plugin is loaded
    enabled = true,

    -- Events that trigger an immediate save (e.g., leaving the buffer/window)
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
      -- Events that trigger a deferred save (with debounce_delay)
      -- defer_save = { "InsertLeave", "TextChanged" },
      defer_save = {},
    },

    -- Saves the file at most every 500 milliseconds (to prevent excessive writes)
    debounce_delay = 500,

    -- Disable the execution message if you find it annoying
    -- execution_message = {
    --   enabled = false, -- Set to true to see messages on save
    -- },
    

    -- The condition function determines whether a buffer should be saved.
    -- This default will typically prevent saving for special buffers (like netrw or git-rebase).
    condition = function(buf)
      local fn = vim.fn

      -- 1. Check if the buffer is modifiable (required for saving)
      if fn.getbufvar(buf, "&modifiable") ~= 1 then
        return false
      end

      -- 2. Define the list of filetypes you want to *exclude* from auto-save
      local excluded_filetypes = {
        "TelescopePrompt",
        "gitcommit",
        "NvimTree",
        "alpha",
        "log",
      }
      local filetype = fn.getbufvar(buf, "&filetype")

      -- 3. Check if the current filetype is in the excluded list
      if vim.list_contains(excluded_filetypes, filetype) then
        return false -- Do NOT save for excluded filetypes
      end

      -- 4. Also exclude non-file buffers (like terminal buffers)
      if fn.getbufvar(buf, "&buftype") ~= "" then
        return false
      end

      -- If all checks pass, it's okay to save
      return true
    end,

    -- Write all buffers when the current one meets `condition`
    write_all_buffers = false,
  },

  -- Add a keymap to easily toggle auto-save on/off
  keys = {
    { "<leader>u<leader>a", "<cmd>ASToggle<CR>", desc = "Toggle AutoSave" },
    -- LazyVim typically uses <leader>u for utility/toggles, adjust as you like
  },
}
