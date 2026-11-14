-- PulseActive — активный таб: фон blue из палитры catppuccin, тёмный текст.
-- PulseCommandDesc — описания команд. Не LineNr (как у pulse по умолчанию):
-- в catppuccin его цвет совпадает с фоном выделения Visual, и на активной
-- строке описание пропадает. Задаём только fg, фон выделения сохраняется.
local function set_hl()
    local ok, palettes = pcall(require, "catppuccin.palettes")
    if ok then
        local c = palettes.get_palette()
        vim.api.nvim_set_hl(0, "PulseActive", { bg = c.blue, fg = c.base, bold = true })
        vim.api.nvim_set_hl(0, "PulseCommandDesc", { fg = c.subtext0, italic = true })
    else
        vim.api.nvim_set_hl(0, "PulseActive", { link = "PmenuSel" })
        vim.api.nvim_set_hl(0, "PulseCommandDesc", { link = "Comment" })
    end
end

-- Pulse показывает команды без описаний. Дописываем справа `desc`
-- пользовательских команд (nvim_create_user_command(..., { desc = ... })).
-- Вызывается на каждую строку при каждой перерисовке, поэтому описания
-- кэшируются и обновляются при каждом открытии таба Commands.
local function add_command_descriptions()
    local display = require("pulse.display")
    local commands = require("pulse.navigators.commands")
    local descs = {}

    local function reload()
        descs = {}
        for name, def in pairs(vim.api.nvim_get_commands({})) do
            -- У Lua-команд desc лежит в definition; у Vimscript-команд там
            -- код (`call netrw#...`), его не показываем.
            if def.callback ~= nil then
                -- nvim хранит definition как последовательность клавиш: байт 0x80
                -- (есть в кириллице, напр. «р») экранирован в 0x80 0xFE 'X'.
                descs[name] = def.definition:gsub("\128\254X", "\128")
            end
        end
    end

    local orig_init = commands.init
    commands.init = function(...)
        reload()
        return orig_init(...)
    end

    local orig_to_display = display.to_display
    -- Обрезать строку до ширины (в экранных колонках) с «…» на конце.
    local function truncate(s, width)
        if vim.fn.strdisplaywidth(s) <= width then
            return s
        end
        local n = vim.fn.strchars(s)
        while n > 0 and vim.fn.strdisplaywidth(vim.fn.strcharpart(s, 0, n)) > width - 1 do
            n = n - 1
        end
        return vim.fn.strcharpart(s, 0, n) .. "…"
    end

    -- width — ширина строки списка, pulse передаёт её вторым аргументом.
    display.to_display = function(item, width)
        local row = orig_to_display(item, width)
        if item.kind == "command" and (row.right or "") == "" then
            local d = descs[vim.trim(item.command or ""):match("^:?(%S+)")]
            if d and d ~= "" then
                -- Pulse отдаёт правой колонке всю ширину и сжимает имя команды,
                -- поэтому описание обрезаем сами, оставляя место под имя.
                local room = (width or 0) - vim.fn.strdisplaywidth(row.left) - 3
                if room >= 10 then
                    row.right = truncate(d, room)
                    row.right_group = "PulseCommandDesc"
                end
            end
        end
        return row
    end
end

return {
    {
        "willyelm/pulse.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("pulse").setup({
                cmdline = false, -- Enable experimental ':' cmdline replacement
                position = "top",
                width = 0.70,
                height = 0.90,
                border = "rounded",
                workspace_label = false, -- Show workspace dir in main input
                -- Только эти табы и в этом порядке.
                navigators = { "commands", "diagnostics", "marks" },
            })

            add_command_descriptions()
            set_hl()
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("user_pulse_hl", { clear = true }),
                callback = set_hl,
            })

            -- Без таба Files пустой запрос открывать некуда, поэтому сразу в Commands.
            vim.keymap.set("n", "<Leader>p", "<cmd>Pulse commands<CR>", { desc = "Pulse: commands" })
        end,
    }
}
