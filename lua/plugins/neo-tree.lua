return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            default_component_configs = {
                git_status = {
                    symbols = {
                        added = "",
                        modified = "",
                        deleted = "",
                        renamed = "",

                        untracked = "",
                        ignored = "",
                        unstaged = "",
                        staged = "",
                        conflict = "",
                    }
                },
                filesystem = {
                    filtered_items = {
                        hide_gitignored = false,
                        hide_dotfiles = false,
                        hide_by_name = {
                            ".idea",
                            ".git"
                        }
                    }

                },
            }
        })

        vim.cmd("hi Directory guifg=floralwhite")

        vim.cmd("hi NeoTreeGitAdded guifg=forestgreen")
        vim.cmd("hi NeoTreeGitModified guifg=dodgerblue")
        vim.cmd("hi NeoTreeGitConflict guibg=red guifg=black")
        vim.cmd("hi NeoTreeGitDeleted guifg=grey")
        vim.cmd("hi NeoTreeGitIgnored guifg=dimgrey")
        vim.cmd("hi NeoTreeGitUntracked guifg=orangered")

        vim.keymap.set("n", "<C-p>", ":Neotree filesystem reveal left<CR>", {})
        vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
    end,
}
