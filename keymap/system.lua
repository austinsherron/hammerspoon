local KeyCombo = require 'utils.api.keymap.keycombo'
local KeyMapper = require 'utils.api.keymap.mapper'
local Volume = require 'utils.api.volume'

-- volume interactions ---------------------------------------------------------

KeyMapper.new('volume interaction')
  :with({
    {
      lhs = KeyCombo({ 'fn' }, '2'),
      rhs = { name = 'vol: mute', fn = Volume.toggle_mute },
    },
    { lhs = KeyCombo({ 'fn' }, '`'), rhs = { name = 'vol: -', fn = Volume.decrease } },
    { lhs = KeyCombo({ 'fn' }, '1'), rhs = { name = 'vol: +', fn = Volume.increase } },
  })
  :bind()
