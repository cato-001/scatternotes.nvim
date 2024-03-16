local function current_window_dimensions()
  local current_window = vim.api.nvim_get_current_win()
  local current_width = vim.api.nvim_win_get_width(current_window)
  local current_height = vim.api.nvim_win_get_height(current_window)
  return { width = current_width, height = current_height }
end

local function create_centered_window(title, width_scalar, height_scalar, buffer)
  print(title, width_scalar, height_scalar)
  local dimensions = current_window_dimensions();
  print(dimensions);

  local width = math.floor(dimensions.width * width_scalar);
  local height = math.floor(dimensions.height * height_scalar);

  print(width);
  print(height);

  return vim.api.nvim_open_win(buffer, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (dimensions.width / 2) - (width / 2),
    row = (dimensions.height / 2) - (height / 2),
    anchor = 'NW',
    style = 'minimal',
    title = title,
    title_pos = 'center',
    border = 'rounded',
  })
end

local state = {
  buffer = nil,
  create_note_window = nil
}

local function create_note()
  if state.create_note_window ~= nil then
    return
  end

  print("hello")
  local filename = vim.fn.system({
    "scatternotes",
    "create",
    "--daily",
  })
  print(filename)
  state.buffer = vim.cmd.edit(filename)

  print(state.buffer)
  state.create_note_window = create_centered_window('Write Your Note', .8, .6, state.buffer)
end

return {
  create_note = create_note
}
