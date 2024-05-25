local function commit_notes()
  vim.cmd('vertical terminal scatternotes --interactive commit')

  local window = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(window, vim.o.columns)
  vim.api.nvim_win_set_height(window, vim.o.lines)

  local buffer = vim.api.nvim_get_current_buf()
  vim.keymap.set('n', 'q', ':q<Cr>', { buffer = buffer })
  vim.keymap.set('n', '', ':q<Cr>', { buffer = buffer })
end

return {
  commit_notes = commit_notes
}
