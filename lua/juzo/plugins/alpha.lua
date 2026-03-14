-- ~/.config/nvim/lua/juzo/plugins/alpha.lua
return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- 1. A sleek ASCII logo (You can easily swap this out later)
        dashboard.section.header.val = {
            "                                                     ",
            "  ███╗   ██╗███████╗██████╗ ██╗   ██╗██╗███╗   ███╗  ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            "                                                     ",
        }

        -- 2. Define the quick-link buttons
        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
            dashboard.button("e", "  New file", "<cmd>ene <BAR> startinsert<CR>"),
            dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
            dashboard.button("s", "  Settings", "<cmd>Telescope find_files cwd=~/.config/nvim<CR>"),
            dashboard.button("q", "󰅚  Quit Neovim", "<cmd>qa<CR>"),
        }

        -- 3. Set aesthetic spacing
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"
        dashboard.config.layout = {
            { type = "padding", val = 8 },
            dashboard.section.header,
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 1 },
            dashboard.section.footer,
        }

        alpha.setup(dashboard.opts)

        -- 4. Automatically close Alpha if you open a real file or tree
        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            callback = function()
                vim.opt.cmdheight = 0
                vim.opt.laststatus = 0
            end,
        })
        vim.api.nvim_create_autocmd("BufUnload", {
            buffer = 0,
            callback = function()
                vim.opt.cmdheight = 1
                vim.opt.laststatus = 3 -- Restores your Lualine
            end,
        })
    end,
}
