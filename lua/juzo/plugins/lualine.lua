-- ~/.config/nvim/lua/juzo/plugins/lualine.lua
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
        require("lualine").setup({
            options = {
                theme = "tokyonight", -- Automatically pulls colors from your active Tokyonight theme
                globalstatus = true,  -- Uses one continuous statusline at the bottom instead of one per split window
                component_separators = { left = "│", right = "│" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    { "filename", path = 1 } -- path = 1 shows the relative path, not just the file name
                },
                lualine_x = {
                    -- Custom modern component to show active LSPs
                    function()
                        -- Uses the modern Neovim 0.10+ API (vim.lsp.get_clients)
                        local clients = vim.lsp.get_clients({ bufnr = 0 })
                        if #clients == 0 then
                            return "No LSP"
                        end

                        local client_names = {}
                        for _, client in ipairs(clients) do
                            table.insert(client_names, client.name)
                        end
                        return "⚙ " .. table.concat(client_names, ", ")
                    end,
                    "encoding",
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { { "location", separator = { left = "", right = "" }, left_padding = 2 } },
            },
        })
    end,
}
