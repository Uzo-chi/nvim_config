-- ~/.config/nvim/lua/juzo/plugins/treesitter.lua
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- Explicitly track the new API branch
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")

        -- 1. Install parsers directly via the new install function
        local languages = {
            "c", "cpp", "rust", "lua", "vim", "vimdoc", "bash", "markdown", "java", "python", "javascript", "typescript",
            "tsx", "markdown_inline"
        }
        ts.install(languages)

        -- 2. Enable native Neovim treesitter highlighting and indentation
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function(event)
                -- Start syntax highlighting safely
                pcall(vim.treesitter.start, event.buf)

                -- Enable treesitter-based indentation
                vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
