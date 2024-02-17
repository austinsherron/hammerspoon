local Screen = require 'utils.api.screen'

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

local function log_move_mouse(current, target, direction, click)
  local w_or_wo = click == false and 'without' or 'with'
  LOGGER:debug(
    'moving mouse screen from %s to %s (%s) (%s click)',
    { current:name(), target:name(), direction, w_or_wo }
  )
end

local function to_rel_screen_center(get_screen, direction, click)
  local current = Mouse.current_screen()
  local target = get_screen(current)
  local center = Screen.center(target)

  log_move_mouse(current, target, direction, click)

  hs.mouse.absolutePosition(center)

  if click ~= false then
    Mouse.click(center)
  end
end

--- Moves the mouse to the center of the "prev" screen and optionally click.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse
function Mouse.prev_screen(click)
  to_rel_screen_center(function(screen)
    return screen:previous()
  end, 'prev', click)
end

--- Moves the mouse to the center of the "next" screen and optionally click.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse
function Mouse.next_screen(click)
  to_rel_screen_center(function(screen)
    return screen:next()
  end, 'next', click)
end

function Mouse.click(point)
  hs.eventtap.leftClick(point)
end

return Mouse
