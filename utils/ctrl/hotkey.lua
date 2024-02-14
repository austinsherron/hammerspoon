local ternary = require('toolbox.core.bool').ternary

--- Representation of a hotkey binding where each entry is:
---  1: the key to which to bind
---  2: a string app name (to launch/focus) or a function (to execute)
---  3: a string array of binding modifiers (i.e.: cmd, alt, etc.)
---@alias HotkeyBinding { [1]: string, [2]: string|function, [3]: string[]|nil }

--- Util for creating modal hotkeys.
---
---@class Hotkey
---@field private modals hs.hotkey.modal[]
---@field private bindings HotkeyBinding[]
local Hotkey = {}
Hotkey.__index = Hotkey

local function pressed(modal)
  return function()
    print 'hotkey pressed'
    modal:enter()
  end
end

local function released(modal)
  return function()
    print 'hotkey released'
    modal:exit()
  end
end

local function bind(key, mods)
  local modal = hs.hotkey.modal.new({}, nil)
  hs.hotkey.bind(mods or {}, key, pressed(modal), released(modal))
  return modal
end

--- Constructor
---
---@param keys string|string[]: the key/keycode that triggers the mode
---@param mods string[]|nil: optional; trigger modifier keys
---@return Hotkey: a new instance
function Hotkey.modal(keys, mods)
  keys = ternary(String.is(keys), { keys }, keys)

  local modals = map(keys, function(key)
    return bind(key, mods)
  end)

  return setmetatable({
    bindings = {},
    modals = modals,
  }, Hotkey)
end

local function launch_or_focus_app(app)
  return function()
    print('launching or focusing', app)
    hs.application.launchOrFocus(app)
  end
end

local function get_binding_fn(app)
  local fn = app

  if type(app) ~= 'function' then
    fn = launch_or_focus_app(app)
  end

  return fn
end

--- Binds key/mods to launch/focus the provided app or run the provided function.
---
---@param key string: the key that triggers app
---@param app string|function: a string application to launch/focus, or a function to
--- trigger
---@param mods string[]|nil: optional; trigger modifier keys
function Hotkey:bind_one(key, app, mods)
  local fn = get_binding_fn(app)

  print('binding', key, 'to', app)

  foreach(self.modals, function(modal)
    modal:bind(mods or {}, key, fn)
  end)
end

--- Binds the provided bindings.
---
---@see Hotkey.bind
---
---@param bindings HotkeyBinding[]: bindings to bind
function Hotkey:bind_all(bindings)
  foreach(bindings, function(b)
    self:bind_one(Table.unpack(b))
  end)
end

--- Buffers bindings in instance.
---
---@param bindings HotkeyBinding[]: the bindings to add to the instance
---@return Hotkey: this instance
function Hotkey:with(bindings)
  Array.appendall(self.bindings, bindings)
  return self
end

--- Binds buffered bindings.
---
---@return Hotkey: this instance
function Hotkey:bind()
  self:bind_all(self.bindings)
  return self
end

--- Binds a hot key.
---
---@param key string: the key that triggers app
---@param app string|function: a string application to launch/focus, or a function to
--- trigger
---@param mods string[]|nil: optional; trigger modifier keys
function Hotkey.hotkey(key, app, mods)
  local fn = get_binding_fn(app)

  print('binding', key, 'to', app)

  hs.hotkey.bind(mods or {}, key, nil, fn)
end

return Hotkey
