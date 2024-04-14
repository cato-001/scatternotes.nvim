local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local config = require('telescope.config').values

local function notes_search_picker(opts)
  opts = opts or {}

  local finder = finders.new_job(
    function(prompt)
      if prompt == nil or prompt == "" then
        return { "scatternotes", "list", "--show-tags" }
      end

      local command = { "scatternotes", "search" }
      for tag in prompt:gmatch("%S+") do
        table.insert(command, tag)
      end
      table.insert(command, "--show-tags")

      return command
    end,
    function(entry)
      local file = nil
      local tags = ""

      for item in entry:gmatch('[^|]+') do
        if not file then
          file = item
        else
          tags = item
        end
      end

      return {
        value = file,
        display = tags,
        ordinal = tags,
        path = file
      }
    end
  )
  local sorter = config.generic_sorter(opts)
  local previewer = previewers.new_termopen_previewer({
    get_command = function(entry)
      return { 'cat', entry.path }
    end
  })

  pickers.new(opts, {
    prompt_title = 'Note Tags',
    finder = finder,
    sorter = sorter,
    previewer = previewer
  }):find()
end

local function search_note()
  notes_search_picker()
end

return {
  search_note = search_note
}
