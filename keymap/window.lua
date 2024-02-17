local Hotkey = require 'utils.ctrl.hotkey'
local Window = require 'utils.api.window'

Hotkey.hotkey('m', { name = 'Window > minimize (force)', fn = Window.force_minimize }, { 'cmd' })
Hotkey.hotkey('m', { name = 'Window > maximize', fn = Window.maximize }, { 'cmd', 'shift' })
