local KeyCombo = require 'utils.api.keymap.keycombo'
local KeyMapper = require 'utils.api.keymap.mapper'

-- NOTE: for cross environmental consistency, I remapped l-ctrl to l-cmd in iterm; this
-- has the unfortunate side effect of clobbering many system wide cmd bindings; this
-- keymap mitigates that issue for most (all?) of the bindings that make the issue
-- noticeable

KeyMapper.new()
  :with_app('iTerm2')
  :with({
    { lhs = KeyCombo.new({ 'ctrl' }, 'w'), swap = { ctrl = 'cmd' } },
    { lhs = KeyCombo.new({ 'ctrl' }, 'q'), swap = { ctrl = 'cmd' } },
    { lhs = KeyCombo.new({ 'ctrl' }, ','), swap = { ctrl = 'cmd' } },
    { lhs = KeyCombo.new({ 'ctrl' }, 'space'), swap = { ctrl = 'cmd' } },
    { lhs = KeyCombo.new({ 'ctrl' }, 'tab'), swap = { ctrl = 'cmd' } },
    { lhs = KeyCombo.new({ 'shift', 'ctrl' }, 'tab'), swap = { ctrl = 'cmd' } },
  })
  :bind()
