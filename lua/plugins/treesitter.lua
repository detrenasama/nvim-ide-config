-- Парсеры, которые ставим при старте (main-ветка не подтягивает requires сама).
-- Список = прежний набор парсеров + phpdoc + зависимости:
-- php -> php_only, tsx -> ecma/jsx/typescript, vue -> html_tags -> dtd,
-- markdown -> markdown_inline.
local ensure = {
  "bash", "c_sharp", "css", "desktop", "dockerfile", "dtd", "ecma", "gitcommit",
  "gitignore", "go", "groovy", "html", "html_tags", "http", "java", "javascript",
  "json", "jsx", "just", "lua", "make", "markdown", "markdown_inline", "nginx",
  "odin", "php", "php_only", "phpdoc", "properties", "query", "scheme", "sql",
  "tsx", "typescript", "vim", "vimdoc", "vue", "xml", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- main переписан под Neovim 0.12+; master заморожен под 0.11 и ломает
    -- инъекции (PHP heredoc/nowdoc, markdown-фенсы) на 0.12.
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})
      -- в main нет парсера jsonc -- подсвечиваем json-парсером
      vim.treesitter.language.register("json", "jsonc")

      -- no-op, если уже установлено
      require("nvim-treesitter").install(ensure)

      -- main не включает фичи сам: подсветка/отступ включаются на FileType.
      -- Отступ отключён для тех же языков, что и раньше в indent.disable
      -- (сравниваем по языку: typescriptreact -> tsx, javascriptreact -> javascript).
      local no_ts_indent = { javascript = true, jsx = true, typescript = true, tsx = true }
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang or not pcall(vim.treesitter.language.add, lang) then
            return
          end
          vim.treesitter.start(ev.buf)
          if not no_ts_indent[lang] then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
