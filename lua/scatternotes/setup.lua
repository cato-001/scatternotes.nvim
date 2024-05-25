local function setup_commands(opts)
  if opts == nil then
    return
  end
  local create_note = require('scatternotes.create').create_note
  for name, tags in pairs(opts) do
    vim.api.nvim_create_user_command(name, function() create_note(tags) end, {})
  end
end

local function setup_keymaps(opts)
  if opts == nil then
    return
  end
  local search = opts['search']
  if search ~= nil then
    local keys = table.remove(search, 1)
    local search_note = require('scatternotes.search').search_note
    vim.keymap.set('n', keys, search_note, search)
  end
  local commit = opts['commit']
  if commit ~= nil then
    local keys = table.remove(commit, 1)
    local commit_notes = require('scatternotes.commit').commit_notes
    vim.keymap.set('n', keys, commit_notes, commit)
  end
end

local function setup(opts)
  opts = opts or {}
  setup_commands(opts['commands'])
  setup_keymaps(opts['keymaps'])
end

return setup
