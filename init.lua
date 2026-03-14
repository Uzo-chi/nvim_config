vim.opt.number      = true
vim.opt.clipboard   = "unnamedplus"
vim.opt.ignorecase  = true
vim.opt.hlsearch    = true
vim.opt.incsearch   = true
vim.opt.signcolumn  = "yes"

vim.opt.expandtab   = true
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.cursorline  = true

require("juzo.core.keymaps")
require("juzo.core.diagnostics")

-- ===========================================
-- LEADER KEY
-- ===========================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- ===========================================
-- BASIC KEYMAPS
-- ===========================================
local map = vim.keymap.set

map('n', '<C-b>', ':Explore<CR>', { desc = 'Open file explorer' })

map('n', '<leader>w', '<cmd>w<CR>', { desc = "Save file" })
map('n', '<leader>q', '<cmd>q<CR>', { desc = "Quit" })


-- ===========================================
-- BOOTSTRAP PLUGIN MANAGER (lazy.nvim)
-- ===========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
