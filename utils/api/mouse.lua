local LOGGER = GetLogger 'MOUSE'

--- Utilities for getting info about the mouse/cursor.
---
---@class api.Mouse
local Mouse = {}

---@return hs.screen: the screen where the mouse is
function Mouse.current_screen()
  local current = hs.mouse.getCurrentScreen()

  if current == nil then
    error "unexpected error getting the cursor's current screen"
  end

  LOGGER:trace('current screen=%s', { current:name() })
  return current
end

return Mouse
