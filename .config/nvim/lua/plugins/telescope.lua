return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-file-browser.nvim', 
    },
    config = function()
        local actions = require("telescope.actions")
        files_to_ignore_patterns = { 'node_modules', '%.git', '%.venv' }
        require('telescope').setup {
            -- You can put your default mappings / updates / etc. in here
            --  All the info you're looking for is in `:help telescope.setup()`
            defaults = {
                mappings = {
                    i = {
                        ['<C-k>'] = actions.move_selection_previous, -- move to prev result
                        ['<C-j>'] = actions.move_selection_next, -- move to next result
                        ['<esc>'] = actions.close
                    },
                },
            },
            pickers = {
                find_files = {
                    file_ignore_patterns = files_to_ignore_patterns, 
                    hidden = true,
                },
                live_grep = {
                    file_ignore_patterns = files_to_ignore_patterns, 
                    additional_args = function(_)
                        return { '--hidden' }
                    end,
                },
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
                file_browser = {
                    theme = "ivy",
                    -- disables netrw and use telescope-file-browser in its place
                    hijack_netrw = true,
                    -- Show hidden files by default
                    hidden = { file_browser = true, folder_browser = true },
                    -- Hide .git, venv, and node_modules directories
                    file_ignore_patterns = files_to_ignore_patterns, 
                    mappings = {
                        ["i"] = {
                            -- your custom insert mode mappings
                        },
                        ["n"] = {
                            -- your custom normal mode mappings
                        },
                    },
                },
            },
        }
        -- Enable Telescope extensions if they are installed
        -- pcall(require('telescope').load_extension, 'fzf')
        -- pcall(require('telescope').load_extension, 'ui-select')
        pcall(require('telescope').load_extension, 'file_browser')
        -- See `:help telescope.builtin`
        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({
                search = vim.fn.input('Grep >'),
                additional_args = function(_)
                    return { '--hidden' }
                end,
            })
        end, {})

        vim.keymap.set('n', '<leader>e', ':Telescope file_browser<CR>', { desc = 'File explorer' }) 
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Git files' }) 
        vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
    end
}    
