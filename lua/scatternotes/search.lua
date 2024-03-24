local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values

local function get_notes()
  local results = vim.fn.systemlist('rg --color never "#" ~/notes')

  local notes = {}

  for _, line in ipairs(results) do
    local note = {}
    for item in line:gmatch('[^:]+') do
      table.insert(note, item)
    end
    table.insert(notes, note)
  end

  return notes
end

local function notes_search_picker(opts)
  opts = opts or {}

  pickers.new(opts, {
    prompt_title = 'Note Tags',
    finder = finders.new_table({
      results = get_notes(),
      entry_maker = function(note)
        return {
          value = note,
          display = note[2],
          ordinal = note[2]
        }
      end,
    }),
    sorter = config.generic_sorter(opts),
  }):find()
end

local function search_note()
  notes_search_picker()
end

return {
  search_note = search_note
}
