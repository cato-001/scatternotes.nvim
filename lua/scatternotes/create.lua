local create_centered_window = require('scatternotes.window').create_centered_window

local function generate_note_key()
  local function char_offset(char, offset)
    local byte = string.byte(char)
    return string.char(byte + offset)
  end
  local function random_char()
    local random = math.random(36)
    if (random < 26) then
      return char_offset('A', random)
    end
    return char_offset('0', random - 26)
  end
  local key = {}
  for i = 1, 20 do
    key[i] = random_char()
  end
  return table.concat(key)
end

local function generate_note_filename()
  local key = generate_note_key()
  local filepath = vim.fn.expand('~') .. '/notes/'
  local filename = filepath .. key .. '.md'

  while vim.fn.filereadable(filename) == 1 do
    key = generate_note_key()
    filename = filepath .. key .. '.md'
  end

  return filename
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
  tags = {}

  if opts["date"] or opts["daily"] then
    tags[#tags + 1] = '#date-' .. os.date('%Y-%m-%d')
  end
  if opts["time"] and not opts["daily"] then
    tags[#tags + 1] = '#time-' .. os.date('%H-%M')
  end

  return tags
end

local function get_tags(opts)
  opts = opts or {}

  local tags = { get_context_tag(opts) }

  if opts["daily"] then
    tags[#tags + 1] = '#daily'
  end

  for _, tag in ipairs(get_time_tags(opts)) do
    tags[#tags + 1] = tag
  end

  for _, value in ipairs(opts) do
    tags[#tags + 1] = '#' + value
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
