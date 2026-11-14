local get_intelephense_license = function()
    local f = assert(io.open(os.getenv("HOME") .. "/intelephense/license.txt", "rb"))
    local content = f:read("*a")
    f:close()
    return string.gsub(content, "%s+", "")
end

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            vim.lsp.config('clangd', {
                capabilities = capabilities
            })
            vim.lsp.enable('clangd')
            vim.lsp.config('tsserver', {
                capabilities = capabilities
            })
            vim.lsp.enable('tsserver')
            vim.lsp.config('html', {
                capabilities = capabilities
            })
            vim.lsp.enable('html')
            vim.lsp.config('lua_ls', {
                capabilities = capabilities
            })
            vim.lsp.enable('lua_ls')
            vim.lsp.config('pylsp', {
                capabilities = capabilities,
                env = {
                    PYTHONPATH = vim.fn.getcwd() .. "/src",
                },
                settings = {
                    pylsp = {
                        plugins = {
                            rope_autoimport = {
                                enabled = true,
                                completions = {
                                    enabled = true,
                                },
                                code_actions = {
                                    enabled = true,
                                }

                            }
                        }
                    }
                }
            })
            vim.lsp.enable('pylsp')
            vim.lsp.config('intelephense', {
                capabilities = capabilities,
                init_options = {
                    licenceKey = get_intelephense_license(),
                    rename = {
                        namespaceMode = "all"
                    }
                }
            })
            vim.lsp.enable('intelephense')

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            -- Определения/использования через Telescope вместо quickfix.
            -- В пикере: <CR> — здесь, <C-t> — новый таб, <C-v> — vsplit, <C-x> — split.
            vim.keymap.set("n", "gd", function()
                require("telescope.builtin").lsp_definitions({ jump_type = "tab drop" })
            end, { desc = "LSP: definition" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "gr", function()
                require("telescope.builtin").lsp_references({
                    include_declaration = false, jump_type = "tab drop",
                })
            end, { desc = "LSP: references" })
            vim.keymap.set("n", "<C-M-l>", vim.lsp.buf.format, {})
            vim.keymap.set("n", "<Leader>cf", vim.lsp.buf.format, {})
            vim.keymap.set("v", "<C-M-l>", vim.lsp.buf.format, {})
            vim.keymap.set("v", "<Leader>cf", vim.lsp.buf.format, {})
            vim.keymap.set("n", "<Leader>cr", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<C-M-r>", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<C-Space>", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<M-]>", vim.diagnostic.goto_next, {})
            vim.keymap.set("n", "<M-[>", vim.diagnostic.goto_prev, {})
        end,
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-neo-tree/neo-tree.nvim",
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
}
