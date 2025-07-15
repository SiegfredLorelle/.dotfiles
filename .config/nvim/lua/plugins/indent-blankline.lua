return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},

    config = function()
        local highlight = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
            "IndentBlanklineIndent3",
            "IndentBlanklineIndent4",
            "IndentBlanklineIndent5",
            "IndentBlanklineIndent6",
        }

        -- Set your specified colors with varying transparency
        vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", {
            bg = "#282C34",
        })
        vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", {
            bg = "#2D313B",
        })
        vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", {
            bg = "#282C34",
        })
        vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", {
            bg = "#2D313B", -- Repeating the second color
        })
        vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", {
            bg = "#3F4451", -- Repeating the third color
        })
        vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", {
            bg = "#282C34", -- Repeating the first color
        })

        require("ibl").setup {
            indent = {
                char = "",
                highlight = highlight,
            },
            whitespace = {
                highlight = highlight,
                remove_blankline_trail = false,
            },
            scope = { enabled = false },
        }

        vim.opt.list = true
        vim.opt.listchars = {
            trail = "•",
            tab = "→ ",
        }
    end
}
