local create_note = require('scatternotes.create').create_note
local search_note = require('scatternotes.search').search_note
local commit_notes = require('scatternotes.commit').commit_notes
local setup = require('scatternotes.setup')

return {
  create_note = create_note,
  search_note = search_note,
  commit_notes = commit_notes,
  setup = setup,
}
