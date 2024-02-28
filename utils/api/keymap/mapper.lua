local Key = require 'utils.api.keymap.key'
local KeyCombo = require 'utils.api.keymap.keycombo'

local LOGGER = GetLogger 'KEYMAP'

---@note: must have one of rhs or swap
---@alias Swap { lhs: KeyCombo, swap: { [string]: string } }
---@alias KeyMapping { lhs: KeyCombo, rhs: KeyCombo }

--- Maps to/from arbitrary key combinations.
---
---@class KeyMapper
---@field private app_filter string
---@field private keymap KeyMapping[]
local KeyMapper = {}
KeyMapper.__index = KeyMapper

--- Constructor
---
---@param app_filter string|nil: the name of an app to which to apply bindings
---@return KeyMapper: a new instance
function KeyMapper.new(app_filter)
  return setmetatable({
    app_filter = app_filter,
    keymap = {},
  }, KeyMapper)
end

local function process_key_swap(key, old, new)
  if key == nil then
    return nil
  end

  return (Key.same(key, old)) and new or key
end

local function process_mods_swap(mods, old, new)
  if mods == nil then
    return nil
  end

  return map(mods, function(mod)
    return process_key_swap(mod, old, new)
  end)
end

local function process_swap(mapping)
  if mapping.rhs ~= nil then
    return mapping
  end

  local lhs = mapping.lhs
  local old, new = Table.get_only(mapping.swap)

  local key = process_key_swap(lhs.key, old, new)
  local mods = process_mods_swap(lhs.mods, old, new)

  local rhs = KeyCombo.new(mods, key ~= nil and Key.new(key) or nil)
  LOGGER:debug('processed swap=%s -> %s', { mapping.swap, rhs })
  return { lhs = lhs, rhs = rhs }
end

---@param keymap (Swap|KeyMapping)[]
---@return KeyMapping[]
local function process_swaps(keymap)
  return map(keymap, process_swap)
end

--- Adds bindings to the instance.
---
---@param keymap (Swap|KeyMapping)[]: an array of bindings
---@return KeyMapper: this instance
function KeyMapper:with(keymap)
  Array.appendall(self.keymap, process_swaps(keymap))
  return self
end

--- Adds an app filter to the instance.
---
---@param app_filter string: the name of an app to which to apply re-mapped bindings
---@return KeyMapper: this instance
function KeyMapper:with_app(app_filter)
  self.app_filter = app_filter
  return self
end

---@private
function KeyMapper:make_handler()
  return function(event)
    local app = hs.application.frontmostApplication()

    if self.app_filter ~= nil and app:name() ~= self.app_filter then
      return event
    end

    for _, binding in ipairs(self.keymap) do
      local lhs = binding.lhs
      local rhs = binding.rhs

      if lhs:matches(event) then
        LOGGER:debug('binding %s -> %s', { lhs, rhs })
        return rhs:toevent()
      end
    end

    return event
  end
end

---@private
function KeyMapper:handler()
  return function(ev)
    local ok, res = pcall(self:make_handler(), ev)

    if not ok then
      LOGGER:error('re-mapping failed: %s', { res })
      return true, { ev }
    end

    return true, { res }
  end
end

--- Binds this instance's keymap(s) using the provided events, or "keyDown" if none are
--- provided.
---
---@param eventtypes integer[]|nil: zero or more event types, as represented in
--- hs.eventtap.event.types
---@return hs.eventtap: the eventtap that's executing the bindings
function KeyMapper:bind(eventtypes)
  eventtypes = eventtypes or { hs.eventtap.event.types.keyDown }
  local eventtap = hs.eventtap.new(eventtypes, self:handler())

  LOGGER:info('binding keymap for app=%s', { self.app_filter })
  eventtap:start()

  return eventtap
end

return KeyMapper
