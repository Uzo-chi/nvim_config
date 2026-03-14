-- ~/.config/nvim/lua/juzo/core/diagnostics.lua

-- See :help vim.diagnostic.config
vim.diagnostic.config({
    -- Don't update errors while you are actively typing in insert mode (too distracting)
    update_in_insert = false,
    
    -- Always put the most severe errors at the top of the list
    severity_sort = true,
    
    -- Configure the floating window that pops up when you hover over an error
    float = { 
        border = "rounded", 
        source = "if_many" 
    },
    
    -- Only put squiggly underlines under actual errors, not minor warnings
    underline = { severity = vim.diagnostic.severity.ERROR },
    
    -- Show the error message text on the right side of the screen at the end of the line
    virtual_text = true, 
    
    -- Auto open the floating window when jumping between errors
    jump = { float = true },
})
