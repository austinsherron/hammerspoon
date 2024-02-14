local Hotkey = require 'utils.ctrl.hotkey'
local Window = require 'utils.api.window'

Hotkey.hotkey('m', Window.maximize, { 'cmd', 'shift' })
