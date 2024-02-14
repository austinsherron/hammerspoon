--- API wrapper around hs.window.
---
---@class Window
local Window = {}

--- Maximizes the focused window.
function Window.maximize()
  hs.window.focusedWindow():maximize()
end

return Window
