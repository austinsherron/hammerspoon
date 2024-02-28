local KeyCombo = require 'utils.api.keymap.keycombo'
local ReMapper = require 'utils.api.keymap.mapper'

ReMapper.new()
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
