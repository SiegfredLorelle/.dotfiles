return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 
          'nvim-lua/plenary.nvim',
      },
      config = function()
         local actions = require("telescope.actions")
         require('telescope').setup {
             -- You can put your default mappings / updates / etc. in here
             --  All the info you're looking for is in `:help telescope.setup()`
             defaults = {
                 mappings = {
                     i = {
                         ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
                         ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
                         --['<C-l>'] = require('telescope.actions').select_default, -- open file
				         ['<esc>'] = actions.close
                     },
                 },
             },
             pickers = {
                 find_files = {
                     file_ignore_patterns = { 'node_modules', '%.git', '%.venv' },
                     hidden = true,
                 },
                 live_grep = {
                     file_ignore_patterns = { 'node_modules', '%.git', '%.venv' },
                     additional_args = function(_)
                         return { '--hidden' }
                     end,
                 },
             },
             extensions = {
                 ['ui-select'] = {
                     require('telescope.themes').get_dropdown(),
                 },
             },
         }
         -- Enable Telescope extensions if they are installed
         pcall(require('telescope').load_extension, 'fzf')
         pcall(require('telescope').load_extension, 'ui-select')
         -- See `:help telescope.builtin`
         local builtin = require 'telescope.builtin'
         vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
         vim.keymap.set('n', '<leader>ps', function()
         builtin.grep_string({search = vim.fn.input('Grep >')}) 
        end,
        { }
     )
         vim.keymap.set('n', '<C-p>', builtin.git_files, { }) 
         vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
     end
 }
     
