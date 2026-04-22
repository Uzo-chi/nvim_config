-- ===========================================
-- LEADER KEY (Load globally)
-- ===========================================
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ===========================================
-- GENERAL OPTIONS (Shared environment)
-- ===========================================
vim.opt.clipboard    = "unnamedplus"
vim.opt.ignorecase   = true
vim.opt.hlsearch     = true
vim.opt.incsearch    = true

-- VSCode mostly handles indentation, but it's safe to keep these global
vim.opt.expandtab    = true
vim.opt.tabstop      = 4
vim.opt.shiftwidth   = 4
vim.opt.softtabstop  = 4

if vim.g.vscode then
    -- ===========================================
    -- VSCODE-SPECIFIC CONFIGURATION
    -- ===========================================
    local vscode = require('vscode')

    vim.notify("Neovim Config Successfully Loaded in VSCode!", vim.log.levels.INFO)

    -- Route your file explorer bind to VSCode's native sidebar
    vim.keymap.set('n', '<C-b>', function()
        vscode.action('workbench.view.explorer')
    end, { desc = 'Open VSCode explorer' })

    -- Route saves and quits to VSCode actions
    vim.keymap.set('n', '<leader>w', function()
        vscode.action('workbench.action.files.save')
    end, { desc = "Save file" })

    vim.keymap.set('n', '<leader>q', function()
        vscode.action('workbench.action.closeActiveEditor')
    end, { desc = "Close editor" })

    -- NOTE: If your `juzo.core.keymaps` contains purely text-manipulation binds
    -- (like moving lines or centering the screen), you can require it here.
    -- If it contains plugin mappings (like Telescope), keep it in the 'else' block.
else
    -- ===========================================
    -- TERMINAL NEOVIM CONFIGURATION
    -- ===========================================

    -- UI Options (VSCode handles these on its end)
    vim.opt.number     = true
    vim.opt.signcolumn = "yes"
    vim.opt.cursorline = true

    vim.cmd("syntax enable")
    vim.cmd("filetype plugin indent on")

    -- Core configuration and diagnostics
    require("juzo.core.keymaps")
    require("juzo.core.diagnostics")

    -- Terminal Keymaps
    vim.keymap.set('n', '<C-b>', ':Explore<CR>', { desc = 'Open file explorer' })
    vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = "Save file" })
    vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = "Quit" })

    -- ===========================================
    -- BOOTSTRAP PLUGIN MANAGER (lazy.nvim)
    -- ===========================================
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

    -- Utilizing modern vim.uv (avoiding the deprecated vim.loop alias)
    if not vim.uv.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    -- ===========================================
    -- LOAD PLUGINS
    -- ===========================================
    require("lazy").setup({
        { import = "juzo.plugins" },
    })

    -- Highlight yank (VSCode handles highlighting natively, so we keep this terminal-only)
    vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Briefly highlight yanked text",
        group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
        callback = function()
            vim.highlight.on_yank({
                higroup = "IncSearch",
                timeout = 200,
            })
        end,
    })
end
