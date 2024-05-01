local create_centered_window = require('scatternotes.window').create_centered_window

local function generate_note_key()
end

local function generate_note_filename()
  return vim.fn.system('scatternotes generate')
end

local function get_priority_tag(opts)
  if opts["todo"] then
    return "#todo"
  end
  if opts["howto"] then
    return "#howto"
  end
  if opts["remind"] then
    return "#remind"
  end
  if opts["research"] then
    return "#research"
  end
  if opts["idea"] then
    return "#idea"
  end
  return nil
end

local function get_context_tag(opts)
  if opts["work"] or opts["daily"] then
    return "#work"
  end
  if opts["scouts"] then
    return "#scouts"
  end
  return "#personal"
end

local function get_time_tags(opts)
  local tags = {}

  if opts["date"] or opts["daily"] then
    table.insert(tags, '#date-' .. os.date('%Y-%m-%d'))
  end
  if opts["time"] and not opts["daily"] then
    table.insert(tags, '#time-' .. os.date('%H-%M'))
  end

  return tags
end

local function get_tags(opts)
  opts = opts or {}

  local tags = {}

  local priority_tag = get_priority_tag(opts)
  if priority_tag then
    table.insert(tags, priority_tag)
  end

  table.insert(tags, get_context_tag(opts))

  if opts["daily"] then
    table.insert(tags, '#daily')
  end

  for _, value in ipairs(opts) do
    table.insert(tags, '#' .. value)
  end

  for _, tag in ipairs(get_time_tags(opts)) do
    table.insert(tags, tag)
  end

  return tags
end

local function create_note(opts)
  local buffer = vim.api.nvim_create_buf(false, false)
  create_centered_window('| Write Your Note |', .8, .6, buffer)

  local filename = generate_note_filename()
  vim.api.nvim_buf_set_name(buffer, filename)

  vim.api.nvim_buf_set_option(buffer, 'modifiable', true)
  vim.api.nvim_buf_set_option(buffer, 'filetype', 'md')

  local keys = table.concat(get_tags(opts), ' ')
  local file_content = { keys, '', '' }

  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, file_content)
  vim.cmd.norm('G')
end

return {
  create_note = create_note
}
