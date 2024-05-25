local create_centered_window = require('scatternotes.window').create_centered_window

local function generate_note_filename()
  return vim.fn.system('scatternotes generate'):gsub('[\t\n ]+$', '')
end

local function get_tags(opts)
  opts = opts or {}

  local tags = {}

  for _, value in ipairs(opts) do
    if value == 'date' then
      value = value .. os.date('%Y-%m-%d')
    end
    if value == 'time' then
      value = value .. os.date('%H-%M')
    end
    table.insert(tags, '#' .. value)
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
