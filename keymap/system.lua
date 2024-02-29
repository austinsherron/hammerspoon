local KeyCombo = require 'utils.api.keymap.keycombo'
local ReMapper = require 'utils.api.keymap.mapper'
local Volume = require 'utils.api.volume'

ReMapper.new()
  :with({
    { lhs = KeyCombo.new({ 'fn' }, '1'), rhs = Volume.toggle_mute },
    { lhs = KeyCombo.new({ 'fn' }, '2'), rhs = Volume.decrease },
    { lhs = KeyCombo.new({ 'fn' }, '3'), rhs = Volume.increase },
  })
  :bind()
