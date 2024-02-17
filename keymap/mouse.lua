local Hotkey = require 'utils.ctrl.hotkey'
local Mouse = require 'utils.ctrl.mouse'

-- mouse bindings
Hotkey.hotkey(
  'h',
  { name = 'Mouse > prev screen', fn = Mouse.prev_screen },
  { 'shift', 'alt' }
)
Hotkey.hotkey(
  'l',
  { name = 'Mouse > next screen', fn = Mouse.next_screen },
  { 'shift', 'alt' }
)

