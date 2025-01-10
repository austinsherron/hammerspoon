local KeyCombo = require 'utils.api.keymap.keycombo'
local KeyMapper = require 'utils.api.keymap.mapper'
local Vol = require 'utils.api.volume'

-- volume interactions ---------------------------------------------------------

KeyMapper.new('power')
  :with({
    -- lock screen
    { lhs = KeyCombo({ 'ctrl', 'cmd' }, 'q'), rhs = KeyCombo({ 'F4' }) },
  })
  :bind()

KeyMapper.new('volume')
  :with({
    { lhs = KeyCombo({ 'fn' }, '`'), rhs = { name = 'vol: ➖', fn = Vol.decrease } },
    { lhs = KeyCombo({ 'fn' }, '1'), rhs = { name = 'vol: ➕', fn = Vol.increase } },
    { lhs = KeyCombo({ 'fn' }, '2'), rhs = { name = 'vol: 🔇', fn = Vol.toggle_mute } },
  })
  :bind()
