local M = {}

M.check = function()
  vim.health.start('scatternotes')

  if vim.fn.executable('scatternotes') == 1 then
    vim.health.ok('scatternotes cli application installed')
  else
    vim.health.error('scatternotes cli application missing')
    vim.health.info('install scatternotes cli with cargo:\ncargo install --locked scatternotes')
  end
end

return M
