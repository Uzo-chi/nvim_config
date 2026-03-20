-- ~/.config/nvim/lua/juzo/plugins/lsp.lua
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "mfussenegger/nvim-jdtls",
    },
    config = function()
        require("mason").setup()

        local servers = {
            "clangd", "rust_analyzer", "pyright", "ts_ls", "bashls", "lua_ls",
        }

        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd", "rust_analyzer", "jdtls", "pyright", "ts_ls", "bashls", "lua_ls"
            },
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        vim.lsp.config("bashls", {
            filetypes = { "sh", "bash", "inc", "command", "zsh" },
            settings = {
                bashIde = { globPattern = "**/*" },
            },
        })

        vim.lsp.config("lua_ls", {
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
                        return
                    end
                end

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

        for _, server in ipairs(servers) do
            vim.lsp.enable(server)
        end

        -- ====================================================================
        -- JDTLS Setup (nvim-jdtls)
        -- ====================================================================
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            desc = "Start nvim-jdtls for Java files",
            callback = function()
                local jdtls = require("jdtls")

                local root_markers = { ".git", "mvnw", "gradlew", "build.gradle", "pom.xml" }
                local root_dir = vim.fs.root(0, root_markers)

                -- Safe fallback for lone Java files
                if not root_dir then
                    root_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
                end

                local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
                local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

                local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

                local config = {
                    cmd = {
                        jdtls_bin,
                        "-data", workspace_dir,
                    },
                    root_dir = root_dir,
                    capabilities = capabilities,
                    settings = {
                        java = {
                            -- THIS forces your project to compile/lint with Java 17
                            configuration = {
                                runtimes = {
                                    {
                                        name = "JavaSE-17",
                                        path = "/usr/lib/jvm/java-17-openjdk-amd64",
                                        default = true,
                                    },
                                }
                            },
                            eclipse = { downloadSources = true },
                            maven = { downloadSources = true },
                            implementationsCodeLens = { enabled = true },
                            referencesCodeLens = { enabled = true },
                            references = { includeDecompiledSources = true },
                            signatureHelp = { enabled = true },
                        }
                    },
                }

                jdtls.start_or_attach(config)
            end,
        })

        vim.schedule(function()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype ~= "" and vim.bo[bufnr].buftype == "" then
                    vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr, modeline = false })
                end
            end
        end)

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
