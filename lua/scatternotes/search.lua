local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values

local function notes_search_picker(opts)
  opts = opts or {}

  pickers.new(opts, {
    prompt_title = 'Note Tags',
    finder = finders.new_job(
      function(prompt)
        if prompt == nil or prompt == "" then
          return { "scatternotes", "list", "--show-tags" }
        end

        local command = { "scatternotes", "search" }
        print(prompt)
        for tag in prompt:gmatch("%S+") do
          print(tag)
          table.insert(command, tag)
        end
        table.insert(command, "--show-tags")
        return command
      end,
      function(line)
        local note = {}

        for _, match in line:gmatch('[^|]+') do
          table.insert(note, match)
        end

        return {
          value = line,
          display = note[2],
          ordinal = note[2]
        }
      end
    ),
    sorter = config.generic_sorter(opts),
  }):find()
end

local function search_note()
  notes_search_picker()
end

return {
  search_note = search_note
}
