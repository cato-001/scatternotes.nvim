local function current_window_dimensions()
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  return { width = width, height = height }
end

local function create_centered_window(title, width_scalar, height_scalar, buffer)
  local dimensions = current_window_dimensions();

  local width = math.floor(dimensions.width * width_scalar);
  local height = math.floor(dimensions.height * height_scalar);

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

  state.buffer = vim.api.nvim_create_buf(false, false)
  state.create_note_window = create_centered_window('Write Your Note', .8, .6, state.buffer)

  local filename = vim.fn.system({
    "scatternotes",
    "create",
    "--daily",
  })

  vim.fn.wait(1000, function()
    return true
  end)

  vim.api.nvim_buf_set_option(state.buffer, 'modifiable', true)
  vim.api.nvim_buf_set_option(state.buffer, 'filetype', 'md')

  local file_content = {}
  for line in io.lines(filename) do
    table.insert(file_content, line)
  end

  vim.api.nvim_buf_set_lines(state.buffer, 0, -1, false, file_content)
end

return {
  create_note = create_note
}
