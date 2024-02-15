local Hotkey = require 'utils.ctrl.hotkey'
local Mouse = require 'utils.ctrl.mouse'

-- mouse bindings
Hotkey.hotkey('h', Mouse.prev_screen, { 'shift', 'alt' })
Hotkey.hotkey('l', Mouse.next_screen, { 'shift', 'alt' })
