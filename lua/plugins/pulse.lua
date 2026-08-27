return {
    {
        "willyelm/pulse.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        config = function()
            require("pulse").setup({
                cmdline = false, -- Enable experimental ':' cmdline replacement
                position = "top",
                width = 0.70,
                height = 0.90,
                border = "rounded",
                workspace_label = false, -- Show workspace dir in main input
            })

            -- vim.keymap.set("n", "<Leader>p", ":Pulse<CR>", {})
        end,
    }
}
