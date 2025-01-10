local KeyCombo = require 'utils.api.keymap.keycombo'
local KeyMapper = require 'utils.api.keymap.mapper'

-- browser interactions --------------------------------------------------------

KeyMapper.new('browsers')
  :with_app('Brave Browser', 'Google Chrome')
  :with({
    -- back
    { lhs = KeyCombo({ 'fn', 'ctrl' }, 'h'), rhs = KeyCombo({ 'cmd' }, '[') },
    { lhs = KeyCombo({ 'fn' }, 'a'), rhs = KeyCombo({ 'cmd' }, '[') },
    -- forward
    { lhs = KeyCombo({ 'fn', 'ctrl' }, 'l'), rhs = KeyCombo({ 'cmd' }, ']') },
    { lhs = KeyCombo({ 'fn' }, 's'), rhs = KeyCombo({ 'cmd' }, ']') },
  })
  :bind()

-- cursor interactions ---------------------------------------------------------

KeyMapper.new('cursor')
  :with({
    -- home (move to "beginning")
    { lhs = KeyCombo({ 'fn', 'cmd' }, 'h'), rhs = KeyCombo({ 'cmd' }, 'left') },
    -- end (move to "end")
    { lhs = KeyCombo({ 'fn', 'cmd' }, 'l'), rhs = KeyCombo({ 'cmd' }, 'right') },
    -- move forward by word
    { lhs = KeyCombo({ 'fn', 'alt' }, 'h'), rhs = KeyCombo({ 'alt' }, 'left') },
    -- move backward by word
    { lhs = KeyCombo({ 'fn', 'alt' }, 'l'), rhs = KeyCombo({ 'alt' }, 'right') },
  })
  :bind()
