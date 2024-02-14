-- single, global instance
local QUAKE = nil

--- Singleton utility that "quake-ifies" (i.e.: enables hotkey dropdown toggling)
--- arbitrary application windows.
---
---@class Quake
---@field private apps { [string]: hs.application }
local Quake = {}
Quake.__index = Quake

---@return hs.application
local function find_app(app_name)
  local app = hs.appfinder.appFromName(app_name)

  if app == nil then
    Err.raise('unable to find app for app_name=%s', app_name)
  end

  return app --[[@as hs.application]]
end

--- Constructor
---
---@param app_names string[]|nil: array of app names for which to enable toggling
---@return Quake: a new instance
local function new(app_names)
  local apps = Table.to_dict(app_names or {}, function(app_name)
    return app_name, find_app(app_name)
  end)

  return setmetatable({
    apps = apps,
    active = nil,
  }, Quake)
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

---@private
---@return hs.application
function Quake:get_app(app_name)
  if self.apps[app_name] == nil then
    self.apps[app_name] = find_app(app_name)
  end

  return self.apps[app_name] --[[@as hs.application]]
end

local function do_hide(app_name, app)
  print('hiding', app_name)
  app:hide()
end

---@private
function Quake:hide(app_name, app)
  local ok, _ = OnErr.as_bool(do_hide, app_name, app)

  if ok then
    self.active = nil
  end
end

local function do_focus(app_name, app)
  print('focusing', app_name)

  local win = app:mainWindow()

  win:setFullscreen(false)
  hs.spaces.moveWindowToSpace(win:id(), hs.spaces.focusedSpace())
  win:maximize()
  win:focus()
end

---@private
function Quake:focus(app_name, app)
  if self.active ~= nil then
    print(fmt('warning: active app=%s is not nil', app_name))
  end

  local ok, _ = OnErr.as_bool(do_focus, app_name, app)

  if ok then
    self.active = app_name
  end
end

---@private
function Quake:hide_active_if_necessary(app)
  if self.active ~= nil then
    print(fmt 'active=%s is not nil; hiding', self.active)
    self:hide(self.active, app)
  end
end

local function launch_if_necessary(app_name, app)
  if not app:isRunning() then
    print(fmt('app=%s is not running; launching', app_name))
    hs.application.launchOrFocus(app_name)
  end
end

local function unminimize_if_necessary(app)
  local win = app:mainWindow()

  print(fmt('app windows=%s', app:allWindows()))

  if win:isMinimized() then
    win:unminimize()
  end
end

---@private
function Quake:toggle(app_name)
  local app = self:get_app(app_name)

  self:hide_active_if_necessary(app)

  launch_if_necessary(app_name, app)
  unminimize_if_necessary(app)

  if app:isFrontmost() then
    self:hide(app_name, app)
  else
    self:focus(app_name, app)
  end
end

--- Returns a function that, when bound to a hotkey, toggles the state of the app w/ the
--- provided name.
---
---@param app_name string: the name of the app for which to enable toggling
---@return function: a toggle function for the app w/ the provided name
function Quake:for_binding(app_name)
  return function()
    self:toggle(app_name)
  end
end

return Quake
