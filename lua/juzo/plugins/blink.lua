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

            -- THE FIX: Deduplicator intercept added here
            providers = {
                lsp = {
                    transform_items = function(_, items)
                        local seen = {}
                        -- Uses modern Neovim 0.10+ iterators to filter the list
                        return vim.iter(items):filter(function(item)
                            if seen[item.label] then
                                return false -- Drop the duplicate
                            end
                            seen[item.label] = true
                            return true -- Keep the first instance
                        end):totable()
                    end,
                },
            },
        },
        snippets = { preset = "luasnip" },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = { enabled = true },
    },
}
