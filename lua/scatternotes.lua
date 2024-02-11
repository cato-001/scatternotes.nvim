local state = {}

local function create_note()
	local buffer = vim.api.nvim_create_buf(false, false)

	local terminal_width = vim.o.winwidth
	local terminal_height = vim.o.winheight

	local width = 40;
	local height = 30;
	local window = vim.api.nvim_open_win(buffer, true, {
		relative = 'editor',
		width = width,
		height = height,
		col = (terminal_width / 2) - (width / 2),
		row = (terminal_height / 2) - (height / 2),
		anchor = 'NW',
		style = 'minimal',
	})
end

return {
	create_note = create_note
}
