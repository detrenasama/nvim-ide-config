return { 
	"catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false,
	config = function ()
		vim.cmd.colorscheme "catppuccin"
		-- подсветка для __() в tsx/jsx — яркий розовый жирный курсив
		vim.api.nvim_set_hl(0, "@string.special.translation", { fg = "#f38ba8", bold = true, italic = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "catppuccin*",
			callback = function()
				vim.api.nvim_set_hl(0, "@string.special.translation", { fg = "#f38ba8", bold = true, italic = true })
			end,
		})
	end
}
