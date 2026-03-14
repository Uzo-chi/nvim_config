return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make"
        },
        "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "ui-select")

        local map = vim.keymap.set
        map('n', '<leader>sh', builtin.help_tags, { desc = '[Search] [H]elp' })
        map("n", "<leader>sk", builtin.keymaps, { desc = "[Search] [K]eymaps" })
        map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        map("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
        map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
        map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
        map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
        map("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        map("n", "<leader>sb", builtin.buffers, { desc = "[ ] Find existing buffers" })

        map("n", "<leader>sn", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "[S]earch [N]eovim files" })
    end,
}
