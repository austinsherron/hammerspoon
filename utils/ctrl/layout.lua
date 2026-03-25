local Mouse = require 'utils.api.mouse'
local Window = require 'utils.api.window'
local WindowCtrl = require 'utils.ctrl.window'

local WindowDirection = Window.Direction

local LOGGER = GetLogger 'WINDOW'

local Layout = {}

local function log_tiling_action(windows)
  local window_titles = Stream.new(windows)
    :filter(function(w)
      return w:title()
    end)
    :collect(function(ws)
      return String.join(ws, ', ')
    end)

  LOGGER:debug(
    'Tiling %s windows horizontally: %s',
    { Array.len(windows), window_titles }
  )
end

--- Tiles horizontally (i.e.: left to right) visible windows on the current screen.
function Layout.tile_windows_horizontally()
  local screen = Mouse.current_screen()
  local windows = Window.s_on_screen(screen)

  if Array.is_empty(windows, false) then
    LOGGER:debug 'No windows to horizontally'
    return
  end

  local num_win = Array.len(windows)
  local frame = screen:frame()
  local width = frame.w / num_win

  log_tiling_action(windows)

  for i, win in ipairs(windows) do
    WindowCtrl.set_frame(win, frame.x + (i - 1) * width, frame.y, width, frame.h)
  end
end

--- Tiles vertically (i.e.: top to bottom) visible windows on the current screen.
function Layout.tile_windows_vertically()
  local screen = Mouse.current_screen()
  local windows = Window.s_on_screen(screen)

  if Array.is_empty(windows, false) then
    LOGGER:debug 'No windows to vertically'
    return
  end

  local num_win = Array.len(windows)
  local frame = screen:frame()
  local height = frame.h / num_win

  log_tiling_action(windows)

  for i, win in ipairs(windows) do
    WindowCtrl.set_frame(win, frame.x, frame.y + (i - 1) * height, frame.w, height)
  end
end

--- Swaps the focused window with the first window in the provided direction, if any.
---
---@param direction WindowDirection: the direction in which to look for windows to swap
function Layout.swap_window_to(direction)
  local window = Window.focused()
  local in_direction = Window.first_to_the(direction)

  if in_direction == nil then
    return
  end

  WindowCtrl.swap(window, in_direction)
end

--- Swaps the focused window with the first window to the left, if any.
function Layout.swap_window_to_left()
  Layout.swap_window_to(WindowDirection.LEFT)
end

--- Swaps the focused window with the first window to the right, if any.
function Layout.swap_window_to_right()
  Layout.swap_window_to(WindowDirection.RIGHT)
end

--- Maximizes all visible windows on the current screen.
function Layout.maximize_all_windows()
  local windows = Window.s_on_screen()

  for _, window in ipairs(windows) do
    WindowCtrl.maximize(window)
  end
end
return Layout
