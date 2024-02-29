local KeyCombo = require 'utils.api.keymap.keycombo'
local KeyMapper = require 'utils.api.keymap.mapper'
local Swap = require 'utils.api.keymap.swap'

-- NOTE: for cross environmental consistency, I remapped l-ctrl to l-cmd in iterm; this
-- has the unfortunate side effect of clobbering many system wide cmd bindings; this
-- keymap mitigates that issue for most (all?) of the bindings that make the issue
-- noticeable

KeyMapper.new()
  :with_app('iTerm2')
  :with({
    { lhs = KeyCombo({ 'ctrl' }, 'w'), rhs = Swap('ctrl', 'cmd') },
    { lhs = KeyCombo({ 'ctrl' }, 'q'), rhs = Swap('ctrl', 'cmd') },
    { lhs = KeyCombo({ 'ctrl' }, ','), rhs = Swap('ctrl', 'cmd') },
    { lhs = KeyCombo({ 'ctrl' }, 'space'), rhs = Swap('ctrl', 'cmd') },
    { lhs = KeyCombo({ 'ctrl' }, 'tab'), rhs = Swap('ctrl', 'cmd') },
    { lhs = KeyCombo({ 'shift', 'ctrl' }, 'tab'), rhs = Swap('ctrl', 'cmd') },
  })
  :bind()
