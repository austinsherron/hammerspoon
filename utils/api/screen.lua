local Mouse = require 'utils.api.mouse'

local enum = require('toolbox.extensions.enum').enum

local LOGGER = GetLogger 'SCREEN'

--- Defines screen relative screen positions, i.e.: one screen's relative position to
--- another.
---
---@enum RelativePosition
local RelativePosition = enum({
  NORTH = { key = 'north', fn = 'toNorth' },
  SOUTH = { key = 'south', fn = 'toSouth' },
  EAST = { key = 'east', fn = 'toEast' },
  WEST = { key = 'west', fn = 'toWest' },
})

--- API wrapper around hs.screen.
---
---@class Screen
local Screen = {}

function Screen.current()
  local window = hs.window.focusedWindow()

  if window ~= nil then
    return window:screen()
  end

  -- TODO: this is defined in a ctrl, but should probably be in an api module
  return Mouse.current_screen()
end

--- Gets the "active" screen, i.e.: the screen w/ the focused window.
---
---@return hs.screen|nil: the screen w/ the focused window, or nil if it can't be found
function Screen.active()
  local window = hs.window.focusedWindow()

  if window ~= nil then
    LOGGER:debug('retrieved active window: %s', { window:title() })
    return window:screen()
  end
end

--- Gets all screens.
---
---@return hs.screen[]: an array of screens
function Screen.all()
  return hs.screen.allScreens() or {}
end

--- Checks if two screens are equal.
---
---@param l hs.screen|nil: screen to check
---@param r hs.screen|nil: other screen to check
---@return true if both screens are non-nil and equal to one another
function Screen.equals(l, r)
  return l ~= nil and r ~= nil and l:id() == r:id()
end

--- Gets the absolute center of the provided screen.
---
---@param screen hs.screen|nil: optional, the screen of which to find the center
---@return hs.geometry: a point that is the absolute center of the provided screen
function Screen.center(screen)
  screen = screen or Screen.active()

  if screen == nil then
    error 'Screen.center: unable to find screen'
  end

  return screen:fullFrame().center
end

local function wintoscreen(win)
  return win:screen()
end

local function get_screen_names(unique)
  return map(unique, function(screen)
    return screen:name()
  end)
end

function Screen.app_on_screen(app, screen)
  local windows = app:allWindows()

  if Array.nil_or_empty(windows) then
    return false
  end

  for _, window in ipairs(windows) do
    local window_screen = window:screen()

    if window_screen == nil then
      return false
    end

    if window_screen:id() == screen:id() then
      return true
    end
  end
end

--- Gets the (unique) screen(s) that contain windows of the provided app.
---
---@param app hs.application: the application for which to get screens
---@return hs.screen[]: an array of (unique) screens
function Screen.for_app(app)
  local screens = map(app:allWindows() or {}, wintoscreen)

  -- TODO: replace this w/ set w/ custom hash function
  local unique = {}
  local ids = Set.new()

  for _, screen in ipairs(screens) do
    if not ids:contains(screen:id()) then
      Array.append(unique, screen)
    end
  end

  local screen_names = get_screen_names(unique)
  LOGGER:debug('found screens for app=%s: %s', { app:name(), screen_names })

  return unique
end

--- Gets the only screen for the provided app.
---
---@param app hs.application: the app for which to get a screen
---@param strict boolean|nil: optional, defaults to false; if true, raise an error if a
--- screen can't be found
---@return hs.screen|nil: the only screen for the provided app, or nil if none exist and
--- strict == false
---@error if strict == true and a screen can't be found for the provided app
function Screen.only_for_app(app, strict)
  local screens = Screen.for_app(app)
  local name = app:name()

  if strict == true and Array.nil_or_empty(screens) then
    Err.raise('no screens found for app=%s', name)
  elseif strict ~= true and Array.nil_or_empty(screens) then
    LOGGER:warn('Screen.only_for_app: no screens found for app=%s', { name })
  elseif Array.len(screens) > 1 then
    Err.raise('%s > 1 screens found for app=%s', Array.len(screens), name)
  end

  return Table.safeget(screens, 1)
end

--- Finds all windows on the provided screen.
---
---@param screen hs.screen: the screen for which to find windows
---@return hs.window[]: an array of windows on the provided screen, if any
function Screen.windows_on_screen(screen)
  local filter = hs.window.filter.new():setDefaultFilter()
  return filter:setScreens(screen:id()):getWindows() or {}
end

--- Finds all apps on the provided screen.
---
---@param screen hs.screen: the screen for which to find apps
---@return hs.application[]: an array of apps on the provided screen, if any
function Screen.apps_on_screen(screen)
  return map(Screen.windows_on_screen(screen), function(w)
    return w:application()
  end)
end

---@note: so RelativePosition is publicly exposed
Screen.RelativePosition = RelativePosition

return Screen
