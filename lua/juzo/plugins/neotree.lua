-- ~/.config/nvim/lua/juzo/plugins/neotree.lua
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    lazy = false,
    keys = {
        { "<leader>\\", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
    },
    opts = {
        git_status_async = true,

        sources = { "filesystem", "buffers", "git_status", "document_symbols" },

        source_selector = {
            winbar = true,
            sources = {
                { source = "filesystem" },
                { source = "buffers" },
                { source = "document_symbols" },
            },
        },
        filesystem = {
            aysnc_directory_scan = "always",

            follow_current_file = { enabled = true },
            hijack_netrw_behavior = "open_default",
            use_libuv_file_watcher = true,

            window = {
                mappings = {
                    ["o"] = "add",
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["y"] = "copy_to_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                },
            },
        },
        window = {
            mappings = {
                ["l"] = "open",
                ["h"] = "close_node",
                ["i"] = "open",
                ["<C-r>"] = "open",
                ["<C-n>"] = "close_window",
            },
            position = "left",
            width = 30,
        },
        buffers = {
            follow_current_file = { enabled = true },
            group_empty_dirs = true,

            commands = {
                safe_buffer_delete = function(state)
                    local node = state.tree:get_node()
                    local bufnr = node.extra.bufnr
                    if bufnr then
                        -- Check if the buffer is a terminal (ToggleTerm)
                        if vim.bo[bufnr].buftype == "terminal" then
                            -- Force kill the background job and refresh the UI
                            vim.api.nvim_buf_delete(bufnr, { force = true })
                            require("neo-tree.sources.manager").refresh("buffers")
                        else
                            -- Route regular files through the standard delete command
                            -- so you still get warnings if you forgot to save your work
                            require("neo-tree.sources.buffers.commands").buffer_delete(state)
                        end
                    end
                end,
            },
            window = {
                mappings = {
                    ["d"] = "safe_buffer_delete",
                },
            },
        },
        document_symbols = {
            follow_cursor = true,
            window = {
                mappings = {
                    ["o"] = "jump_to_symbol",
                    ["i"] = "jump_to_symbol",
                },
            },
        },
    },
}
