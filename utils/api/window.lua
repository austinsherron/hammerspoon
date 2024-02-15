--- API wrapper around hs.window.
---
---@class Window
local Window = {}

--- Maximizes the focused window.
function Window.maximize()
  hs.window.focusedWindow():maximize()
end

--- Minimizes the focused window.
---
---@param force boolean|nil: optional, defaults to false; if true, minimizes fullscreen
--- windows
function Window.minimize(force)
  local window = hs.window.focusedWindow()

  if window == nil then
    return
  end

  if force == true and window:isFullScreen() then
    window:setFullScreen(false)
  end

  window:minimize()
end

--- Window.minimize w/ force == true.
---
---@see Window.minimize
function Window.force_minimize()
  Window.minimize(true)
end

return Window
