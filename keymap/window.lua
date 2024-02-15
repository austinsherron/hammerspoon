local Hotkey = require 'utils.ctrl.hotkey'
local Window = require 'utils.api.window'

Hotkey.hotkey('m', Window.force_minimize, { 'cmd' })
Hotkey.hotkey('m', Window.maximize, { 'cmd', 'shift' })
