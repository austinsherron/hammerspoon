local enum = require('toolbox.extensions.enum').enum

local LOGGER = GetLogger 'WINDOW'

--- API wrapper around hs.window.
---
---@class Window
local Window = {}

--- Checks if the provided window is the focused window.
---
---@param window hs.window: the window to check
---@return boolean: true if the provided window is the focused window, false otherwise
function Window.is_focused(window)
  return window:id() == Window.focused():id()
end

--- Gets the absolute center of the provided window.
---
---@param window hs.window: the window of which to find the center
---@return hs.geometry: a point that is the absolute center of the provided window
function Window.center(window)
  return window:frame().center
end

---@return hs.window: the focused window
function Window.focused()
  return hs.window.focusedWindow()
end

--- Maximizes the focused window.
function Window.maximize()
  Window.focused():maximize()
end

--- Minimizes the focused window.
---
---@param force boolean|nil: optional, defaults to false; if true, minimizes fullscreen
--- windows
function Window.minimize(force)
  local window = Window.focused()

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

--- Models possible directions of windows relative to another window.
---
---@enum WindowDirection
local WindowDirection = enum({
  UP = 'North',
  DOWN = 'South',
  LEFT = 'West',
  RIGHT = 'East',
})

---@note: So WindowDirection is publicly exposed
Window.Direction = WindowDirection

local function call_direction_method(window, direction, base_name, ...)
  local method_name = fmt('%s%s', base_name, direction)
  local method = window[method_name]

  if method == nil then
    LOGGER:error('hs.window:%s is not a valid method', { method_name })
    error(fmt('hs.window:%s is not a valid method', method_name))
  end

  LOGGER:debug('calling hs.window:%s', { method_name })
  return method(window, ...)
end

--- Gets windows in the provided direction relative to the focused window.
---
---@param direction WindowDirection: the direction, relative to the focused window, in
--- which to look for windows
---@return hs.window[]: an array of windows that are in the provided direction relative to
--- the focused window; the array will be empty if there are no such windows
function Window.s_to_the(direction)
  return call_direction_method(Window.focused(), direction, 'windowsTo')
end

--- Gets the first window, if any, in the provided direction relative to the focused
--- window.
---
---@param direction WindowDirection: the direction, relative to the focused window, in
--- which to look for windows
---@return hs.window|nil: the first window in the provided direction relative to the
--- focused window, or nil if no such window exists
function Window.first_to_the(direction)
  local windows = Window.s_to_the(direction)

  if Array.is_empty(windows) then
    return nil
  end

  return windows[1]
end

--- Gets the frontmost window at the provided point, if any.
---
---@param point hs.geometry: the point to check
---@return hs.window|nil: the frontmost window at the provided point, or nil if no such
--- window exists
function Window.at(point)
  for _, win in ipairs(hs.window.orderedWindows()) do
    if point:inside(win:frame()) then
      return win
    end
  end

  return nil
end

--- Focuses the next window in the provided direction relative to the focused window.
---
--- WARN: this function doesn't seem to work across screens. See
--- https://github.com/Hammerspoon/hammerspoon/issues/370.
---
---@param direction WindowDirection: the direction, relative to the focused window, in
--- which to shift focus
function Window.focus_to(direction)
  local in_direction = Window.first_to_the(direction)

  if in_direction ~= nil then
    in_direction:focus()
  end
end

return Window
