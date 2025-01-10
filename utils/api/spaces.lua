local Screen = require 'utils.api.screen'
local Type = require 'toolbox.meta.type'

local LOGGER = GetLogger 'SPACES'

--- API wrapper around hs.spaces.
---
---@class Spaces
local Spaces = {}

--- Parameterizes adding a space.
---
---@class AddSpaceOpts
---@field screen hs.screen|nil: optional, defaults to the active screen; the screen to
--- which to add a space
---@field closeMC boolean|nil: optional, defaults to false; if true, closes mission
--- control after adding a space

--- Adds a space to the provided screen, or the active screen, if none is provided.
---
---@param opts AddSpaceOpts|nil: optional; parameterizes adding a space
function Spaces.add(opts)
  opts = opts or {}

  local screen = opts.screen or Screen.active()
  local closeMC = opts.closeMC or false

  ---@diagnostic disable-next-line: need-check-nil
  local ok, err = hs.spaces.addSpaceToScreen(screen:id(), closeMC)

  if not ok or err ~= nil then
    Err.raise('Spaces.add: error adding space to screen: %s', err)
  end
end

function Spaces.remove() end

---@return number[]|nil
---@return string|nil
local function all()
  local screens = Screen.all()
  local spaces = {}

  for _, screen in ipairs(screens) do
    local screen_spaces, err = hs.spaces.spacesForScreen(screen)

    if screen_spaces == nil or err ~= nil then
      return nil, err
    end

    Array.appendall(spaces, screen_spaces)
  end

  return spaces, nil
end

--- Gets all spaces. If screens have separate spaces, retrieve the spaces for the provided
--- screen, or the active screen, if none is provided. If screens don't have spaces, gets
--- all spaces, regardless of the values of screen.
---
---@param screen hs.screen|string|nil: optional; if provided, retrieves spaces for this
--- screen
---@return number[]: ids of spaces
function Spaces.get_all(screen)
  screen = (screen == 'active') and Screen.active() or screen

  if screen ~= nil or not Type.is(screen, hs.screen) then
    Err.raise('Spaces.get_all: unreocgnized screen: %s', screen)
  end

  ---@diagnostic disable-next-line: unbalanced-assignments
  local spaces, err = (screen ~= nil) and hs.spaces.spacesForScreen(screen) or all()

  if spaces == nil or err ~= nil then
    Err.raise('Spaces.get_all: unable to get spaces: %s', err)
  end

  return spaces --[[@as table]]
end

--- Gets the id of the space at index "space".
---
---@see see Spaces.get_all
---@param space integer: the index of the space to retrieve; spaces are 1 indexed from
--- left to right; can be negative (i.e.: -1 == rightmost space)
---@param screen hs.screen|nil: optional, see Spaces.get_all for behavioral notes
---@return number: the id of the space at the provided index
function Spaces.get(space, screen)
  local spaces = Spaces.get_all(screen)

  if Array.len(spaces) <= space then
    Err.raise('Window.move_to_space: space %s does not exist', space)
  end

  return Array.index(spaces, space)
end

--- Focuses the provided space at index "space".
---
---@see see Spaces.get_all
---@param space integer: the index of the space to focus; spaces are 1 indexed from left
--- to right; can be negative (i.e.: -1 == rightmost space)
---@param screen hs.screen|nil: optional, see Spaces.get_all for behavioral notes
function Spaces.focus(space, screen)
  local space_id = Spaces.get(space, screen)
  local ok, err = hs.spaces.gotoSpace(space_id)

  if ok and err == nil then
    return
  end

  Err.log_and_raise(
    LOGGER,
    'Spaces.focus: error moving to space=%s: %s',
    { space, err or '?' }
  )
end

--- Moves window to the space at index "space" for the window's current screen.
---
---@param space integer: the index of the space; spaces are 1 indexed from left to right;
--- can be negative (i.e.: -1 == rightmost space)
---@param window hs.window: the window to move
function Spaces.move_window(space, window)
  local space_id = Spaces.get(space, window:screen())
  local ok, err = hs.spaces.moveWindowToSpace(window, space_id)

  if ok and err == nil then
    return
  end

  Err.log_and_raise(LOGGER, 'Spaces.move_window: unable to move window to space: %s', err)
end

return Spaces
