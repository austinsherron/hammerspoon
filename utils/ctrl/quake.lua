local Mouse = require 'utils.api.mouse'
local Screen = require 'utils.api.screen'

local LOGGER = GetLogger 'QUAKE'
local QUAKE = nil -- NOTE: single, global instance

---@alias QuakeAppIdentifier { name: string, window: string|nil }

--- Parameterizes quake window appearance, toggling behavior, etc.
---
---@class QuakeWindowOpts
---@field maximize boolean|nil: optional, defaults to false; if true, the window will be
--- maximized when shown

--- Singleton utility that "quake-ifies" (i.e.: enables hotkey dropdown toggling)
--- arbitrary application windows.
---
---@class Quake
---@field private apps { [string]: hs.application }
local Quake = {}
Quake.__index = Quake

---@return hs.application|nil
local function find_app_by_name(app_name)
  LOGGER:debug('attempting to find app w/ name=%s', { app_name })
  return hs.appfinder.appFromName(app_name)
end

local function new(app_names)
  local apps = Table.to_dict(app_names or {}, function(app_name)
    return app_name, find_app_by_name(app_name)
  end)

  return setmetatable({ apps = apps }, Quake)
end

--- Gets (or constructs) the singleton Quake instance.
---
---@param app_names string[]|nil: array of app names for which to enable toggling
---@return Quake: a new instance
function Quake.get(app_names)
  if QUAKE == nil then
    QUAKE = new(app_names)
  end

  return QUAKE
end

local function open_app(app_name)
  LOGGER:debug('unable to find app, attempting to open app w/ name=%s', { app_name })
  hs.application.open(app_name)
end

---@return hs.application|nil
local function find_app_by_window(app_window)
  LOGGER:debug('attempting to find app w/ window=%s', { app_window })
  return hs.appfinder.appFromWindowTitle(app_window)
end

---@private
---@param app_name string
---@param app_window string|nil
---@return hs.application
function Quake:get_app(app_name, app_window)
  -- "cache miss"
  if self.apps[app_name] == nil then
    self.apps[app_name] = find_app_by_name(app_name)
  end

  -- maybe not running
  if self.apps[app_name] == nil then
    self.apps[app_name] = open_app(app_name)
  end

  -- can't find it and there's a window title, try that
  if self.apps[app_name] == nil and app_window ~= nil then
    self.apps[app_name] = find_app_by_window(app_window)
  end

  -- can't find it, fail
  if self.apps[app_name] == nil then
    error(fmt('unable to find app=%s', app_name))
  end

  return self.apps[app_name]
end

local function hide(app)
  local app_name = app:name()
  LOGGER:debug('hiding %s', { app_name })
  app:hide()
end

---@private
function Quake:hide_windows_on_current_screen(showing, mouse_screen)
  LOGGER:debug(
    'hiding quake windows on screen=%s before showing %s',
    { mouse_screen:name(), showing:name() }
  )

  for _, app in pairs(self.apps) do
    if app:name() ~= showing:name() and Screen.app_on_screen(app, mouse_screen) then
      LOGGER:debug('quake managed app on current screen: %s', { app:name() })
      hide(app)
    end
  end
end

local function evaluate_opts(win, opts)
  if opts.maximize ~= true then
    win:maximize()
  end
end

---@private
function Quake:focus(app, opts)
  local app_name = app:name()
  local win = app:mainWindow()

  if win == nil then
    LOGGER:warn('unable to find window for %s', { app_name })
    return
  end

  local mouse_screen = Mouse.current_screen()

  self:hide_windows_on_current_screen(app, mouse_screen)
  win:setFullscreen(false)
  hs.spaces.moveWindowToSpace(win:id(), hs.spaces.focusedSpace())
  win:moveToScreen(mouse_screen)

  evaluate_opts(win, opts)

  LOGGER:debug('focusing %s', { app_name })
  win:focus()
end

local function launch_if_necessary(app)
  if not app:isRunning() then
    LOGGER:debug('app=%s is not running; launching', { app:name() })
    hs.application.launchOrFocus(app:name())
    return true
  end

  return false
end

local function unminimize_if_necessary(app)
  local win = Table.safeget(app:allWindows(), 1)

  if win == nil or not win:isMinimized() then
    return false
  end

  LOGGER:debug('app=%s is minimized; unminimizing', { app:name() })
  win:unminimize()

  return true
end

---@private
function Quake:toggle(app_id, opts)
  local app_name = app_id.name
  local app = self:get_app(app_name, app_id.window)

  LOGGER:info('Starting quake toggle for app=%s', { app_name })

  if launch_if_necessary(app) then
    return
  end

  if unminimize_if_necessary(app) then
    return
  end

  if app:isFrontmost() then
    hide(app)
  else
    self:focus(app, opts)
  end

  LOGGER:info('Starting quake toggle for app=%s', { app_name })
end

--- Hides all quake windows.
---
---@param filter (fun(hs.application): boolean)|nil: optional; function for filtering
--- which quake windows to hide; accepts an application and returns true if that
--- applications quake window should be hidden
function Quake:hide_all(filter)
  filter = filter or Lambda.TRUE
  Stream.new(Table.values(self.apps)):filter(filter):foreach(hide)
end

--- Returns a function that, when bound to a hotkey, toggles the state of the app w/ the
--- provided name.
---
---@param app_id string|QuakeAppIdentifier: the name of or an identifier for the app for
--- which to enable toggling
---@param opts QuakeWindowOpts|nil: parameterizes quake window appearance, toggling
--- behavior, etc
---@return function: a toggle function for the app w/ the provided name
function Quake:for_binding(app_id, opts)
  app_id = String.is(app_id) and { name = app_id } or app_id

  return function()
    self:toggle(app_id, opts or {})
  end
end

--- Checks if the app w/ the provided name is managed by this instance.
---
---@param app_name string: the name of the app to check
---@return boolean: true if the app w/ the provided name is managed by this instance,
--- false otherwise
function Quake:is_managed(app_name)
  return self.apps[app_name] ~= nil
end

return Quake
