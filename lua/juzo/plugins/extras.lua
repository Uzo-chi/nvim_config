-- ~/.config/nvim/lua/juzo/plugins/extras.lua
return {
    {
        -- 1. ToggleTerm: A painless floating terminal
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = "ToggleTerm",
        keys = {
            { "<leader><leader>", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
        },
        opts = {
            direction = "float",
            float_opts = {
                border = "curved",
            },
        },
    },
    {
        -- 2. UndoTree: A visual map of your undo history
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle [U]ndo Tree" },
        },
    },
    {
        -- 3. Colorizer: Highlights hex codes with their actual color
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {
            user_default_options = {
                names = false, -- Disables highlighting standard words like "Blue" to avoid text clutter
                mode = "background",
            },
        },
    },
}
