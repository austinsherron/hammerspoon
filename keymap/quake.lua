local Hotkey = require 'utils.ctrl.hotkey'
local Lambda = require 'toolbox.functional.lambda'
local Quake = require 'utils.ctrl.quake'

local QK = Quake.get()

-- quake windows ---------------------------------------------------------------

Hotkey.hotkey('F7', { name = 'Quake > Hide All', fn = Lambda.make(Quake.hide_all, QK) })
Hotkey.hotkey('F9', { name = 'Quake > WhatsApp', fn = QK:for_binding 'Slack' })
Hotkey.hotkey('F10', { name = 'Quake > WhatsApp', fn = QK:for_binding 'WhatsApp' })
Hotkey.hotkey('F11', { name = 'Quake > iTerm', fn = QK:for_binding 'iTerm2' })
