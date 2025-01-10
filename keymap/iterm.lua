local KeyCombo = require 'utils.api.keymap.keycombo'
local KeyMapper = require 'utils.api.keymap.mapper'
local Swap = require 'utils.api.keymap.swap'

-- NOTE: for cross environmental consistency, I remapped l-ctrl to l-cmd in iterm; this
-- has the unfortunate side effect of clobbering many system wide cmd bindings; this
-- keymap mitigates that issue for most (all?) of the bindings that make the issue
-- noticeable

KeyMapper.new('iTerm2')
  :with_app('iTerm2')
  :with({
    -- misc
    -- { lhs = KeyCombo({ 'ctrl' }, ','), rhs = Swap('ctrl', 'cmd') }, -- settings
    { lhs = KeyCombo({ 'ctrl' }, 'q'), rhs = Swap('ctrl', 'cmd') }, -- quit
    { lhs = KeyCombo({ 'ctrl' }, 'w'), rhs = Swap('ctrl', 'cmd') }, -- close
    { lhs = KeyCombo({ 'ctrl' }, 'space'), rhs = Swap('ctrl', 'cmd') }, -- search
    -- window state
    { lhs = KeyCombo({ 'ctrl' }, 'm'), rhs = Swap('ctrl', 'cmd') }, -- minimize
    { lhs = KeyCombo({ 'shift', 'ctrl' }, 'm'), rhs = Swap('ctrl', 'cmd') }, -- maximize
    -- app cycling
    { lhs = KeyCombo({ 'ctrl' }, 'tab'), rhs = Swap('ctrl', 'cmd') }, -- forward
    { lhs = KeyCombo({ 'shift', 'ctrl' }, 'tab'), rhs = Swap('ctrl', 'cmd') }, -- backward
    -- cursor
    -- FIXME: 'fn' seems to be causing problems
    -- { lhs = KeyCombo({ 'fn,', 'ctrl' }, 'h'), rhs = Swap('ctrl', 'cmd') }, -- home
    -- { lhs = KeyCombo({ 'fn', 'ctrl' }, 'l'), rhs = Swap('ctrl', 'cmd') }, -- end
  })
  :bind()
