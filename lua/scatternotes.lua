local create_note = require('scatternotes.create').create_note
local search_note = require('scatternotes.search').search_note
local setup = require('scatternotes.setup')

return {
  create_note = create_note,
  search_note = search_note,
  setup = setup,
}
