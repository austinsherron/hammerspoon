local Mouse = require 'utils.api.mouse'
local Screen = require 'utils.api.screen'
local Window = require 'utils.api.window'

local WindowDirection = Window.Direction

local LOGGER = GetLogger 'MOUSE'

--- Utilities for controlling the mouse/cursor.
---
---@class MouseCtrl
local MouseCtrl = {}

local function log_move_mouse(current, target, direction, type, click)
  local w_or_wo = click == false and 'without' or 'with'
  LOGGER:debug(
    'moving mouse %s from %s to %s (%s) (%s click)',
    { type, current, target, direction, w_or_wo }
  )
end

local function to_rel_center(current, target, get_center, direction, type, click)
  local center = get_center(target)

  hs.mouse.absolutePosition(center)
  local win_at_center = Window.at(center)
  local should_click = click ~= false
    and win_at_center ~= nil
    and not Window.is_focused(win_at_center)

  log_move_mouse(current, target, direction, type, should_click)

  if should_click then
    MouseCtrl.click(center)
  end
end

--- Moves the mouse to the center of the "previous" screen and optionally clicks.
---
--- NOTE: click=true results in a click only if the window under the cursor at its new
--- position isn't already focused.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse if the window under the cursor at its new position isn't already focused
function MouseCtrl.prev_screen(click)
  local current = Mouse.current_screen()
  to_rel_center(current, current:previous(), Screen.center, 'prev', 'screen', click)
end

--- Moves the mouse to the center of the "next" screen and optionally clicks.
---
--- NOTE: click=true results in a click only if the window under the cursor at its new
--- position isn't already focused.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse if the window under the cursor at its new position isn't already focused
function MouseCtrl.next_screen(click)
  local current = Mouse.current_screen()
  to_rel_center(current, current:next(), Screen.center, 'next', 'screen', click)
end

--- Moves the mouse to the center of the "previous" window and optionally clicks.
---
--- NOTE: click=true results in a click only if the window under the cursor at its new
--- position isn't already focused.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse if the window under the cursor at its new position isn't already focused
function MouseCtrl.prev_window(click)
  local current = Window.focused()
  local target = Window.first_to_the(WindowDirection.LEFT)

  if target ~= nil then
    to_rel_center(current, target, Window.center, 'prev', 'window', click)
  end
end

--- Moves the mouse to the center of the "next" window and optionally clicks.
---
--- NOTE: click=true results in a click only if the window under the cursor at its new
--- position isn't already focused.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse if the window under the cursor at its new position isn't already focused
function MouseCtrl.next_window(click)
  local current = Window.focused()
  local target = Window.first_to_the(WindowDirection.RIGHT)

  if target ~= nil then
    to_rel_center(current, target, Window.center, 'next', 'window', click)
  end
end

---@see hs.eventtap.leftClick.
function MouseCtrl.click(...)
  hs.eventtap.leftClick(...)
end

return MouseCtrl
