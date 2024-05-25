local create_centered_window = require('scatternotes.window').create_centered_window

---@return string
local function generate_note_filename()
  return vim.fn.trim(vim.fn.system('scatternotes generate'))
end

---@return string
local function get_tags(opts)
  if opts == nil then
    return ''
  end
  local tags = {}
  for _, value in ipairs(opts) do
    if value == 'date' then
      value = '#date-' .. os.date('%Y-%m-%d')
    elseif value == 'time' then
      value = '#time-' .. os.date('%H-%M')
    else
      value = '#' .. value
    end
    table.insert(tags, value)
  end
  return table.concat(tags, ' ')
end

local function create_note(opts)
  local buffer = vim.api.nvim_create_buf(false, false)
  create_centered_window('| Write Your Note |', .8, .6, buffer)

  vim.api.nvim_buf_set_name(buffer, generate_note_filename())

  vim.api.nvim_buf_set_option(buffer, 'modifiable', true)
  vim.api.nvim_buf_set_option(buffer, 'filetype', 'md')

  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { get_tags(opts), '', '' })
  vim.cmd.norm('G')
end

return {
  create_note = create_note
}
