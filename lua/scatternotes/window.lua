local function create_window(opts)
  opts = opts or {}

  local buffer = opts['buffer']
  if buffer == nil then
    error('cannot create window without buffer')
  end

  local vim_width = vim.o.columns
  local vim_height = vim.o.lines

  local width = math.floor((opts['width'] or vim_width) * (opts['width_scalar'] or 1))
  local height = math.floor((opts['height'] or vim_height) * (opts['height_scalar'] or 1))

  local column = opts['column'] or 0
  local row = opts['row'] or 0

  if opts['center'] then
    column = (vim_width / 2) - (width / 2)
    row = (vim_height / 2) - (height / 2)
  end
  if opts['bottom'] then
    row = vim_height - height
  end
  if opts['top'] then
    row = 0
  end
  if opts['right'] then
    column = vim_width - width
  end
  if opts['left'] then
    column = 0
  end

  return vim.api.nvim_open_win(buffer, true, {
    relative  = 'editor',
    width     = width,
    height    = height,
    col       = column,
    row       = row,
    anchor    = 'NW',
    style     = 'minimal',
    title     = opts['title'] or 'window title',
    title_pos = 'center',
    border    = 'rounded',
  })
end

local function create_centered_window(title, width_scalar, height_scalar, buffer)
  local window_width = vim.opt.columns
  local window_height = vim.opt.lines

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
  create_centered_window = create_centered_window,
  create_window = create_window,
}
