return {
    {
    'ccaglak/phptools.nvim',
    cmd = "PhpTools",
    -- Отдельные команды Php* для меню pulse: оно показывает только имена команд,
    -- без подкоманд `:PhpTools <X>`. Создаются при старте (init), а сам плагин
    -- грузится лениво при первом вызове — lazy.nvim подгружает его на require.
    init = function()
      -- desc показывается справа в меню pulse (см. plugins/pulse.lua).
      local function cmd(name, desc, fn, opts)
        vim.api.nvim_create_user_command(name, fn, vim.tbl_extend("force", { desc = desc }, opts or {}))
      end
      local function tools(f) return function() require("phptools")[f]() end end
      local function ide(f) return function() require("phptools.ide_helper")[f]() end end
      local function test(f) return function() require("phptools.tests").test[f]() end end

      cmd("PhpSmart", "Создать метод или класс под курсором (определит сам)", tools("smart"))
      cmd("PhpMethod", "Создать несуществующий метод под курсором", tools("method"))
      cmd("PhpClass", "Создать несуществующий класс/трейт/интерфейс/enum под курсором + use", tools("class"))
      cmd("PhpNamespace", "Вставить namespace по пути файла (composer.json)", tools("namespace"))
      cmd("PhpGetSet", "Геттер/сеттер для свойства под курсором", tools("getset"))
      cmd("PhpPropertyHooks", "Property hooks PHP 8.4 для свойства под курсором", tools("propertyhooks"))
      cmd("PhpScripts", "Запустить скрипт из composer.json", tools("scripts"))
      cmd("PhpCreate", "Создать файл: класс/интерфейс/enum/трейт, шаблоны Laravel", tools("create"))
      cmd("PhpRefactor", "Обернуть выделение в if/for/try и т.п. (из visual)", tools("refactor"), { range = true })

      cmd("PhpIdeHelperAll", "Laravel IDE Helper: сгенерировать всё", ide("generate_all"))
      cmd("PhpIdeHelperModels", "Laravel IDE Helper: хелперы моделей", ide("generate_models"))
      cmd("PhpIdeHelperFacades", "Laravel IDE Helper: хелперы фасадов", ide("generate_facades"))
      cmd("PhpIdeHelperMeta", "Laravel IDE Helper: .phpstorm.meta.php", ide("generate_meta"))
      cmd("PhpIdeHelperInstall", "Laravel IDE Helper: установить пакет через composer", ide("install"))

      cmd("PhpTestAll", "Тесты: запустить все", test("all"))
      cmd("PhpTestFile", "Тесты: текущий файл", test("file"))
      cmd("PhpTestLine", "Тесты: ближайший к курсору тест", test("line"))
      cmd("PhpTestFilter", "Тесты: выбрать тест из списка", test("filter"))
      cmd("PhpTestParallel", "Тесты: все параллельно (--parallel)", test("parallel"))
      cmd("PhpTestRerun", "Тесты: повторить последний запуск", test("rerun"))
      cmd("PhpTestSelected", "Тесты: выбрать файл из tests/", test("selected"))
    end,
    keys = {
        { "<leader>ll", "<cmd>PhpTools Smart<cr>", desc = "Smart detect (method or class)" },
        { "<leader>lm", "<cmd>PhpTools Method<cr>", desc = "Generate method" },
        { "<leader>lc", "<cmd>PhpTools Class<cr>", desc = "Generate class" },
        { "<leader>ls", "<cmd>PhpTools Scripts<cr>", desc = "Run Composer scripts" },
        { "<leader>ln", "<cmd>PhpTools Namespace<cr>", desc = "Generate namespace" },
        { "<leader>lg", "<cmd>PhpTools GetSet<cr>", desc = "Generate getter/setter" },
        { "<leader>lp", "<cmd>PhpTools PropertyHooks<cr>", desc = "Generate property hooks" },
        { "<leader>lf", "<cmd>PhpTools Create<cr>", desc = "Create PHP entity" },
        { mode = "v", "<leader>lr", "<cmd>PhpTools Refactor<cr>", desc = "Refactor selection" },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require('phptools').setup({
        ui = {
          enable = true,      -- replace vim.ui.select, vim.ui.input, vim.notify with custom floating windows
          fzf = false,        -- use fzf for test filtering if available
        },
        custom_toggles = {
          enable = false,     -- enable <C-a>/<C-x> word/operator toggles
          -- Built-in word groups:
          --   { "public", "protected", "private" },
          --   { "self", "static" },
          --   { "true", "false" },
          --   { "require", "require_once", "include" },
          --   { "abstract", "final" },
          --   { "class", "interface", "trait", "enum" },
          --   { "string", "int", "float", "bool", "array" },
          -- Built-in operator pairs:
          --   == <-> ===, != <-> !==, > <-> >=, < <-> <=,
          --   && <-> ||, ++ <-> --, -> <-> =>
          -- Add custom word groups to extend defaults:
          -- custom_toggles = { { "yes", "no" }, { "on", "off" } },
        },
        gf = {
          enable = true,      -- smart gf navigation for PHP, Blade, Twig
          max_depth = 5,      -- max recursion depth for constant resolution
          project_root_markers = { ".git", "composer.json", ".env" },
          excluded_dirs = { "vendor", "node_modules", ".git" },
          custom_constants = {},  -- user-defined constants, e.g. { MY_CONST = "/path/to/dir" }
          keymaps = {         -- set any to false to disable
            gf = "gf",                          -- context-aware goto file
            browse_components = "<leader>gC",   -- list all Blade components
            browse_livewire = "<leader>gw",     -- list all Livewire components
            toggle_livewire = "<leader>gW",     -- switch between Livewire class and Blade view
            browse_routes = "<leader>gr",       -- list Laravel routes and jump to controller
            browse_logs = "<leader>gl",         -- list and open log files
            tail_logs = "<leader>gL",           -- tail -f laravel.log in a terminal tab
          },
        },
        property_hooks = {
          enable = true,      -- PHP 8.4 property hooks generation
        },
      })
      -- IDE Helper и тесты доступны командами PhpIdeHelper* / PhpTest* (см. init).
    end
}
}
