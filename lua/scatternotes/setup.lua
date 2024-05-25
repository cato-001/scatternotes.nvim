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
  local search_note = require('scatternotes.search').search_note
  local search = opts['search']
  if search ~= nil then
    local name = table.remove(search, 1)
    vim.keymap.set('n', name, search_note, search)
  end
end

local function setup(opts)
  opts = opts or {}
  setup_commands(opts['commands'])
  setup_keymaps(opts['keymaps'])
end

return setup
