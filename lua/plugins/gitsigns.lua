return {
    {
        "tpope/vim-fugitive",
        config = function ()
            vim.keymap.set("n", "<Leader>G", ":Git<CR>")
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function ()
            local gs = require("gitsigns")

            gs.setup({
                numhl = true,
                current_line_blame = true,
            })

            vim.keymap.set("n", "<Leader>hp", gs.preview_hunk, {})
            vim.keymap.set("n", "]h", gs.next_hunk, {})
            vim.keymap.set("n", "[h", gs.prev_hunk, {})
            vim.keymap.set("n", "ghs", gs.stage_hunk, {})
            vim.keymap.set("n", "ghu", gs.undo_stage_hunk, {})
            vim.keymap.set("n", "ghr", gs.reset_hunk, {})
            vim.keymap.set("v", "ghs", gs.stage_hunk, {})
            vim.keymap.set("v", "ghu", gs.undo_stage_hunk, {})

        end
    }
}
