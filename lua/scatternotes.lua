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

local function read_array(file)
  local arr    = {}
  local handle = assert(io.open(file, "r"))
  local value  = handle:read("*number")
  while value do
    table.insert(arr, value)
    value = handle:read("*number")
  end
  handle:close()
  return arr
end

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

  vim.api.nvim_buf_set_option(state.buffer, 'modifiable', true)
  vim.api.nvim_buf_set_option(state.buffer, 'filetype', 'md')

  filename = "/home/cato/notes/LDPLKUJ5NDFNSMGNYAEN.md"

  local file_content = read_array(filename)

  vim.api.nvim_buf_set_lines(state.buffer, 0, -1, false, file_content)
end

return {
  create_note = create_note
}
