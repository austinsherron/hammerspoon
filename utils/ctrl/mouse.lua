local Screen = require 'utils.api.screen'

--- Utilities for controlling the mouse/cursor.
---
---@class Mouse
local Mouse = {}

local function to_rel_screen_center(get_screen, click)
  local current = hs.mouse.getCurrentScreen()
  local screen = get_screen(current)
  local center = Screen.center(screen)

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
  end, click)
end

--- Moves the mouse to the center of the "next" screen and optionally click.
---
---@param click boolean|nil: optional, defaults to true; if true, left click after moving
--- the mouse
function Mouse.next_screen(click)
  to_rel_screen_center(function(screen)
    return screen:next()
  end, click)
end

function Mouse.click(point)
  hs.eventtap.leftClick(point)
end

return Mouse
