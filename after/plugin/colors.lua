require('gruvbox').setup {
    contrast = "hard",
}

vim.cmd('colorscheme gruvbox')

--[[
require('rose-pine').setup({
    disable_background = false
})

function SetColorTheme(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

    -- Transparent background for normal and floating buffers
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetColorTheme()
--]]
