return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function ()
        local colors = {
            bg = "#1e1e2e",
            fg = "#cdd6f4",
            yellow = "#f9e2af",
            cyan = "#89dceb",
            darkblue = "#89b4fa",
            green = "#a6e3a1",
            orange = "#fab387",
            violet = "#f5c2e7",
            magenta = "#cba6f7",
            blue = "#74c7ec",
            red = "#f38ba8",
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
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.red,
        }

        local mode = {
            "mode",
            separator = { left = "", right = "" },
            right_padding = 2,
            color = function ()
               return { bg = mode_color[vim.fn.mode()], fg = colors.bg }
            end
        }

        local space = {
            "       ",
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
    color = { bg = colors.magenta, fg = colors.bg },
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
        lualine_c= {  'branch', 'diff', 'diagnostics'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
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
