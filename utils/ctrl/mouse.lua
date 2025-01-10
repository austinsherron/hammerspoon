local MouseApi = require 'utils.api.mouse'
local Screen = require 'utils.api.screen'

local LOGGER = GetLogger 'MOUSE'

--- Utilities for controlling the mouse/cursor.
---
---@class ctrl.Mouse
local Mouse = {}

local function log_move_mouse(current, target, direction, click)
  local current_name = current ~= nil and current:name() or '?'
  local target_name = target ~= nil and target:name() or '?'

  local w_or_wo = click == false and 'without' or 'with'
  LOGGER:debug(
    'moving mouse screen from %s to %s (%s) (%s click)',
    { current_name, target_name, direction, w_or_wo }
  )
end

local function to_rel_screen_center(get_screen, direction, click, backup)
  local current = MouseApi.current_screen()
  local target = get_screen(current)

  if target == nil and backup == nil then
    return LOGGER:warn 'unable to find mouse target screen'
  elseif target == nil then
    LOGGER:warn('unable to find mouse target screen; using backup=%s', { backup:name() })
  end

  local center = Screen.center(target)
  log_move_mouse(current, target, direction, click)

  hs.mouse.absolutePosition(center)

  if click ~= false then
    Mouse.click(center)
  end
end

--- Moves the mouse to the center of the "prev" screen and optionally clicks.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse
function Mouse.prev_screen(click)
  to_rel_screen_center(function(screen)
    return screen:previous()
  end, 'prev', click)
end

--- Moves the mouse to the center of the "next" screen and optionally clicks.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse
function Mouse.next_screen(click)
  to_rel_screen_center(function(screen)
    return screen:next()
  end, 'next', click)
end

--- Moves the mouse to the center of the "left" screen and optionally clicks. If no such
--- screen exists, centers the mouse on the current screen.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse
function Mouse.left_screen(click)
  to_rel_screen_center(function(screen)
    return screen:toWest()
  end, 'left', click, MouseApi.current_screen())
end

--- Moves the mouse to the center of the "right" screen and optionally clicks. If no such
--- screen exists, centers the mouse on the current screen.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse
function Mouse.right_screen(click)
  to_rel_screen_center(function(screen)
    return screen:toEast()
  end, 'right', click, MouseApi.current_screen())
end

--- Left clicks the mouse on the provided point.
---
---@param point hs.geometry: represents the point on a screen at which to click
function Mouse.click(point)
  hs.eventtap.leftClick(point)
end

return Mouse
