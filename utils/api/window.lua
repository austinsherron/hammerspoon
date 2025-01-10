local Spaces = require 'utils.api.spaces'
local Type = require 'toolbox.meta.type'

local RelativePosition = require('utils.api.screen').RelativePosition

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

--- Moves the focused window to the screen specified by where.
---
---@param where hs.screen|RelativePosition
function Window.move_to_screen(where)
  local window = hs.window.focusedWindow()

  if window == nil then
    return
  end

  local screen = nil

  if Type.is(where, hs.screen) then
    screen = where
  elseif RelativePosition:is_valid(where) then
    ---@diagnostic disable-next-line: undefined-field
    local window_screen = window:screen()
    screen = window_screen[where.fn](window_screen)
  else
    Err.raise('Window.move_to_screen: unrecognized screen identifier: %s', where)
  end

  if screen ~= nil then
    window:moveToScreen(screen)
  end
end

--- Moves the focused window to the space at index "space" for the window's current
--- screen.
---
---@param space integer: the index of the space; spaces are 1 indexed from left to right;
--- can be negative (i.e.: -1 == rightmost space)
---@param follow boolean|nil: optional, defaults to true; if true, the current space
--- changes w/ the window;
function Window.move_to_space(space, follow)
  local window = hs.window.focusedWindow()

  if window == nil then
    return
  end

  Spaces.move_window(space, window)

  if follow ~= false then
    Spaces.focus(space)
  end
end

return Window
