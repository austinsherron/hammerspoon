local Hotkey = require 'utils.ctrl.hotkey'
local Quake = require 'utils.ctrl.quake'

local QK = Quake.get()

Hotkey.hotkey('F11', QK:for_binding 'WhatsApp')
Hotkey.hotkey('F12', QK:for_binding 'iTerm')
