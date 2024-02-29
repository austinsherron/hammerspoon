local Hotkey = require 'utils.ctrl.hotkey'
local KeyCombo = require 'utils.api.keymap.keycombo'
local KeyMapper = require 'utils.api.keymap.mapper'
local Window = require 'utils.api.window'

-- window interactions ---------------------------------------------------------

Hotkey.hotkey(
  'm',
  { name = 'Window > minimize (force)', fn = Window.force_minimize },
  { 'cmd' }
)
Hotkey.hotkey(
  'm',
  { name = 'Window > maximize', fn = Window.maximize },
  { 'cmd', 'shift' }
)
-- browser interactions -------------------------------------------------------

KeyMapper.new()
  :with_app('Brave Browser', 'Google Chrome')
  :with({
    { lhs = KeyCombo.new({ 'fn' }, 'h'), rhs = KeyCombo.new({ 'cmd' }, '[') },
    { lhs = KeyCombo.new({ 'fn' }, 'l'), rhs = KeyCombo.new({ 'cmd' }, ']') },
  })
  :bind()
