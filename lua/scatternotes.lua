local M = {}

M.create_note = require('scatternotes.create').create_note
M.search_note = require('scatternotes.search').search_note
M.commit_notes = require('scatternotes.commit').commit_notes
M.health = require('scatternotes.health')
M.setup = require('scatternotes.setup')

return M
