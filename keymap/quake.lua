local Hotkey = require 'utils.ctrl.hotkey'
local Quake = require 'utils.ctrl.quake'

local QK = Quake.get()

-- quake windows ---------------------------------------------------------------

-- NOTE: don't use F1/F12: those are the "hyper" keys (i.e.: used for hotkeys, etc.)

Hotkey.hotkey('F2', { name = 'Quake > Hide All', fn = Lambda.make(Quake.hide_all, QK) })
Hotkey.hotkey('F9', { name = 'Quake > Hammerspoon', fn = QK:for_binding 'Hammerspoon' })
Hotkey.hotkey('F10', { name = 'Quake > WhatsApp', fn = QK:for_binding 'WhatsApp' })
Hotkey.hotkey(
  'F11',
  { name = 'Quake > iTerm', fn = QK:for_binding('iTerm2', { maximize = true }) }
)
