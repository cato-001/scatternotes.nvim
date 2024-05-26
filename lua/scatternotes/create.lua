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
  vim.cmd('vertical edit ' .. generate_note_filename())

  local window = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(window, vim.o.columns)
  vim.api.nvim_win_set_height(window, vim.o.lines)

  local buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { get_tags(opts), '', '' })
  vim.cmd.norm('G')
end

return {
  create_note = create_note
}
