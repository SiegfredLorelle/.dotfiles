return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  init = function()
      -- Auto-restore only on a bare `nvim`; `nvim file`, `git commit` and pipes are untouched.
      vim.api.nvim_create_autocmd("VimEnter", {
          nested = true,
          callback = function()
              if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
                  require("persistence").load()
              end
          end,
      })
      vim.api.nvim_create_autocmd("StdinReadPre", {
          callback = function()
              vim.g.started_with_stdin = true
          end,
      })
      -- Neo-tree windows can't be restored from a session and come back as empty buffers.
      vim.api.nvim_create_autocmd("User", {
          pattern = "PersistenceSavePre",
          callback = function()
              pcall(vim.cmd, "Neotree close")
          end,
      })
  end,
  keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session (cwd)" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save this session" },
  },
}
