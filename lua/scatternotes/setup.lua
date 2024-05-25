local function setup_commands(opts)
  if opts == nil then
    return
  end
  local create_note = require('scatternotes.create').create_note
  for name, tags in pairs(opts) do
    vim.api.nvim_create_user_command(name, function() create_note(tags) end, {})
  end
end

return function(opts)
  opts = opts or {}
  setup_commands(opts['commands'])
end
