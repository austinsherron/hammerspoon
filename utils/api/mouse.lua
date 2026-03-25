local LOGGER = GetLogger 'MOUSE'

--- Utilities for controlling the mouse/cursor.
---
---@class Mouse
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

---@return hs.geometry: the cursor's current coordinates
function Mouse.coordinates()
  return hs.mouse.absolutePosition()
end

return Mouse
