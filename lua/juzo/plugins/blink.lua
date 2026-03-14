-- ~/.config/nvim/lua/juzo/plugins/blink.lua
return {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*", -- Ensure we track the stable v1 API
    dependencies = {
        "L3MON4D3/LuaSnip",
        version = "2.*",
    },
    opts = {
        keymap = { 
            preset = "super-tab" -- Use Tab to accept completions, just like Kickstart
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        snippets = { preset = "luasnip" },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = { enabled = true },
    },
}
