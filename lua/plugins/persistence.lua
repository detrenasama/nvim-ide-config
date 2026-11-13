-- Сессии: сохраняются в ~/.local/state/nvim/sessions/ отдельно для каждой
-- директории и git-ветки. Восстанавливаются автоматически, если nvim
-- запущен без аргументов.
return {
    "folke/persistence.nvim",
    lazy = false, -- нужен сразу, чтобы успеть восстановить сессию на VimEnter
    opts = {
        branch = true,
    },
    config = function(_, opts)
        local persistence = require("persistence")
        persistence.setup(opts)

        local group = vim.api.nvim_create_augroup("user_persistence", { clear = true })

        -- Ввод из пайпа (`cmd | nvim`) — это не работа над проектом.
        local from_stdin = false
        vim.api.nvim_create_autocmd("StdinReadPre", {
            group = group,
            callback = function() from_stdin = true end,
        })

        vim.api.nvim_create_autocmd("VimEnter", {
            group = group,
            nested = true, -- чтобы для восстановленных буферов сработали FileType/treesitter/LSP
            callback = function()
                if vim.fn.argc() == 0 and not from_stdin then
                    persistence.load()
                else
                    -- `nvim file` (в т.ч. git commit/rebase в $EDITOR) не должен
                    -- перезаписывать сессию проекта.
                    persistence.stop()
                end
            end,
        })

        -- neo-tree в сессию не сохраняем.
        vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = "PersistenceSavePre",
            callback = function()
                pcall(vim.cmd, "Neotree close")
            end,
        })

        vim.keymap.set("n", "<leader>qs", persistence.load, { desc = "Restore session (cwd + branch)" })
        vim.keymap.set("n", "<leader>qS", persistence.select, { desc = "Select session" })
        vim.keymap.set("n", "<leader>qd", persistence.stop, { desc = "Don't save session on exit" })
    end,
}
