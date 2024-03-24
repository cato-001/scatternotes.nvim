local function create_centered_window(title, width_scalar, height_scalar, buffer)
  local window_width = vim.api.nvim_get_option('columns')
  local window_height = vim.api.nvim_get_option('lines')

  local width = math.floor(window_width * width_scalar)
  local height = math.floor(window_height * height_scalar)

  return vim.api.nvim_open_win(buffer, true, {
    relative  = 'editor',
    width     = width,
    height    = height,
    col       = (window_width / 2) - (width / 2),
    row       = (window_height / 2) - (height / 2),
    anchor    = 'NW',
    style     = 'minimal',
    title     = title,
    title_pos = 'center',
    border    = 'rounded',
  })
end

return {
  create_centered_window = create_centered_window
}
