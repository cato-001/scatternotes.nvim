local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values

local function notes_search_picker(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'tags',
    finder = finders.new_table({
      results = { 'work', 'personal', 'daily' }
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
