--- API wrapper around hs.screen.
---
---@class Screen
local Screen = {}

--- Gets the absolute center of the provided screen.
---
---@param screen hs.screen: the screen of which to find the center
---@return hs.geometry: a point that is the absolute center of the provided screen
function Screen.center(screen)
  return screen:fullFrame().center
end

return Screen
