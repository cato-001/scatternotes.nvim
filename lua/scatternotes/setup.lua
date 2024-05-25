local function commands(opts)
  if opts == nil then
    return
  end
  local create_note = require('scatternotes.create').create_note
  for _, value in ipairs(opts) do
    local name = value[1]
    local tags = value['tags']

    vim.api.nvim_create_user_command(name, function() create_note(tags) end, {})
  end
end

return {
  commands = commands
}
