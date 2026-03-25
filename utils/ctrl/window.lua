local Args = require 'toolbox.utils.args'
local Num = require 'toolbox.core.num'
local Window = require 'utils.api.window'

local WindowCtrl = {}

--- Maximizes the provided window, or the focused window of none is provided.
---
---@param window hs.window|nil: optional, defaults to the focused window; the window to
--- maximize
function WindowCtrl.maximize(window)
  window = window or Window.focused()
  window:maximize()
end

--- Minimizes the focused window.
---
---@param force boolean|nil: optional, defaults to false; if true, minimizes fullscreen
--- windows
function WindowCtrl.minimize(force)
  local window = Window.focused()

  if force == true and window:isFullScreen() then
    window:setFullScreen(false)
  end

  window:minimize()
end

--- Window.minimize w/ force == true.
---
---@see WindowCtrl.minimize
function WindowCtrl.force_minimize()
  WindowCtrl.minimize(true)
end

--- Sets the screen position and dimensions of the provided window.
---
---@param window hs.window: the window whose screen position and dimensions will be
--- updated
---@param x number: the x coordinate of the window's top left point
---@param y number: the y coordinate of the window's top left point
---@param w number: the window's width
---@param h number: the window's height
function WindowCtrl.set_frame(window, x, y, w, h)
  window:setFrame(hs.geometry.rect(x, y, w, h))
end

--- Swaps the screen positions of the provided windows.
---
---@param window_1 hs.window: the first window to swap
---@param window_2 hs.window: the second window to swap
function WindowCtrl.swap(window_1, window_2)
  local window_1_frame = window_1:frame()
  local window_2_frame = window_2:frame()

  WindowCtrl.set_frame(
    window_2,
    window_1_frame.x,
    window_1_frame.y,
    window_1_frame.w,
    window_1_frame.h
  )
  WindowCtrl.set_frame(
    window_1,
    window_2_frame.x,
    window_2_frame.y,
    window_2_frame.w,
    window_2_frame.h
  )
end

return WindowCtrl
