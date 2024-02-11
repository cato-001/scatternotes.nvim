local state = {}

local function create_note()
	local buffer = vim.api.nvim_create_buf(false, false)

	local current_window = vim.api.nvim_get_current_win()
	local current_width = vim.api.nvim_win_get_width(current_window)
	local current_height = vim.api.nvim_win_get_height(current_window)

	local width = 40;
	local height = 30;
	local window = vim.api.nvim_open_win(buffer, true, {
		relative = 'editor',
		width = width,
		height = height,
		col = (current_width / 2) - (width / 2),
		row = (current_height / 2) - (height / 2),
		anchor = 'NW',
		style = 'minimal',
		title = '  Write Your Note  ',
		title_pos = 'center',
		footer = '  :q Quit / :w Write  ',
		border = 'rounded',
	})
end

return {
	create_note = create_note
}
