-- ~/.config/nvim/lua/juzo/plugins/lsp.lua
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        require("mason").setup()

        local servers = {
            "clangd", "rust_analyzer", "jdtls", "pyright", "ts_ls", "bashls", "lua_ls",
        }

        require("mason-lspconfig").setup({
            ensure_installed = servers,
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- 1. Apply capabilities to all servers natively
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- 2. Bash specific setup (Native API)
        vim.lsp.config("bashls", {
            filetypes = { "sh", "bash", "inc", "command", "zsh" },
            settings = {
                bashIde = { globPattern = "**/*" },
            },
        })

        -- 3. Lua specific setup (Native API, safely handling missing workspaces)
        vim.lsp.config("lua_ls", {
            on_init = function(client)
                -- If a workspace folder exists, check for a project-specific config
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
                        return
                    end
                end

                -- Inject the Neovim API globals
                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                    runtime = {
                        version = "LuaJIT",
                        path = { "lua/?.lua", "lua/?/init.lua" },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                })
            end,
            settings = { Lua = {} },
        })

        -- 4. Turn them all on natively
        for _, server in ipairs(servers) do
            vim.lsp.enable(server)
        end

        -- 5. The Timing Fix: Retroactively attach to files like init.lua
        -- (This will no longer crash because we removed the bad root_dir override)
        vim.schedule(function()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype ~= "" and vim.bo[bufnr].buftype == "" then
                    vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr, modeline = false })
                end
            end
        end)

        -- 6. Keybindings
        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "LSP Keybindings",
            callback = function(event)
                local opts = { buffer = event.buf }
                local map = vim.keymap.set

                map("n", "K", vim.lsp.buf.hover, opts)
                map("n", "gd", vim.lsp.buf.definition, opts)
                map("n", "gr", vim.lsp.buf.references, opts)
                map("n", "gD", vim.lsp.buf.declaration, opts)
                map("n", "<leader>rn", vim.lsp.buf.rename, opts)
                map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
        })
    end,
}
