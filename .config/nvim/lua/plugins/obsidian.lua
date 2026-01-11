return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ft = "markdown",
  keys = {
      { "<leader>op", ":Obsidian paste_img<CR>", desc = "Paste image from clipboard" },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    attachments = {
      img_folder = "attachments",  -- default location for images
    },
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/arch-obsidian",
      },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      -- },
    },
  },
}

