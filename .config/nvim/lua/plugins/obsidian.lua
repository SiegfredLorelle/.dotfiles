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
  config = function(_, opts)
    -- Set conceallevel before the plugin initializes
    vim.opt.conceallevel = 2
    require("obsidian").setup(opts)
  end,
}

