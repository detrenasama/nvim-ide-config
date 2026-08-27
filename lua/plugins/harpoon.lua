return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function ()
        require("harpoon").setup({
            mark_branch = true
        })
        local harpoonUi = require("harpoon.ui")
        local harpoonMark = require("harpoon.mark")
        vim.keymap.set("n", "<M-m>", harpoonMark.add_file, {})
        vim.keymap.set("n", "<M-h>m", harpoonUi.toggle_quick_menu, {})
        vim.keymap.set("n", "<M-j>", harpoonUi.nav_prev, {})
        vim.keymap.set("n", "<M-k>", harpoonUi.nav_next, {})
    end
}
