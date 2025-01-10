local Hotkey = require 'utils.ctrl.hotkey'
local Mouse = require 'utils.ctrl.mouse'

-- mouse movements -------------------------------------------------------------

Hotkey.hotkey(
  'h',
  { name = 'Mouse > left screen', fn = Mouse.left_screen },
  { 'shift', 'alt' }
)
Hotkey.hotkey(
  'l',
  { name = 'Mouse > right screen', fn = Mouse.right_screen },
  { 'shift', 'alt' }
)
