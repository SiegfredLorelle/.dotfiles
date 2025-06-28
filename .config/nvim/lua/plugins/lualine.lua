return {
'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function ()
        local colors = {
            bg = "#282C34",
            lbg = "#3F4451",
            fg = "#cdd6f4",
            lfg = "#abb2bf",
            yellow = "#e5c07b",
            cyan = "#56b6c2",
            green = "#98c379",
            magenta = "#c678dd",
            violet = "#cba6f7",
            blue = "#61afef",
            red = "#e06c75",
        }
        local theme = {
            normal = {
                a = { bg = "None", gui = "bold" },
                b = { bg = "None", gui = "bold" },
                c = { bg = "None", gui = "bold" },
                x = { bg = "None", gui = "bold" },
                y = { bg = "None", gui = "bold" },
                z = { bg = "None", gui = "bold" },
            },
            insert = {
                a = { bg = "None", gui = "bold" },
                b = { bg = "None", gui = "bold" },
                c = { bg = "None", gui = "bold" },
                x = { bg = "None", gui = "bold" },
                y = { bg = "None", gui = "bold" },
                z = { bg = "None", gui = "bold" },
            },
            visual = {
                a = { bg = "None", gui = "bold" },
                b = { bg = "None", gui = "bold" },
                c = { bg = "None", gui = "bold" },
                x = { bg = "None", gui = "bold" },
                y = { bg = "None", gui = "bold" },
                z = { bg = "None", gui = "bold" },
            },
            replace = {
                a = { bg = "None", gui = "bold" },
                b = { bg = "None", gui = "bold" },
                c = { bg = "None", gui = "bold" },
                x = { bg = "None", gui = "bold" },
                y = { bg = "None", gui = "bold" },
                z = { bg = "None", gui = "bold" },
            },
            command = {
                a = { bg = "None", gui = "bold" },
                b = { bg = "None", gui = "bold" },
                c = { bg = "None", gui = "bold" },
                x = { bg = "None", gui = "bold" },
                y = { bg = "None", gui = "bold" },
                z = { bg = "None", gui = "bold" },
            },
            inactive = {
                a = { bg = "None", gui = "bold" },
                b = { bg = "None", gui = "bold" },
                c = { bg = "None", gui = "bold" },
                x = { bg = "None", gui = "bold" },
                y = { bg = "None", gui = "bold" },
                z = { bg = "None", gui = "bold" },
            },
        }

        local mode_color = {
            n = colors.magenta,
            i = colors.red,
            v = colors.green,
            [""] = colors.green,
            V = colors.green,
            c = colors.blue,
            no = colors.magenta,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.magenta,
            ce = colors.magenta,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.magenta,
            t = colors.magenta,
        }

        local mode = {
            "mode",
            icon = {""},
            separator = { left = "", right = "" },
            right_padding = 2,
            color = function ()
             return { bg = mode_color[vim.fn.mode()], fg = colors.bg, gui = "bold"}
          end,
      }

      local branch = {
          "branch",
          icon = {""},
      }

    local filename_with_icon = {
        function()
            local devicons = require('nvim-web-devicons')
            local fname = vim.fn.expand('%:t')
            if fname == '' or fname == '[no name]' then
                return ""
            end
            local icon, _ = devicons.get_icon(fname)
            local icon_part = icon and icon or ""
            local filepath = vim.fn.expand('%:.')

            return icon_part .. " " .. filepath
        end,
        separator = { right = "" },
        color = { bg = colors.lbg, fg = colors.lfg, gui = "bold" },
    }
    
    local lsp_status = {
        "lsp_status",
        icons_enabled = false,
    }

    local location = {
        "location",
        color = { bg = colors.lbg, fg = colors.lfg, gui = "bold" },
        separator = { left = "", right = "" },
        padding = { left = 2, right = 1 } 
    }
    
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = theme,
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
          refresh_time = 16, -- ~60fps
          events = {
            'winenter',
            'bufenter',
            'bufwritepost',
            'sessionloadpost',
            'filechangedshellpost',
            'vimresized',
            'filetype',
            'cursormoved',
            'cursormovedi',
            'modechanged',
          },
        }
      },
  sections = {
        lualine_a = { mode },
        lualine_b = { filename_with_icon },
        lualine_c= {  branch, 'diff', },
        lualine_x = { 'diagnostics' },
        lualine_y = { lsp_status },
        lualine_z = { location }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
end
}
