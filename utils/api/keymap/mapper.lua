local KeyCombo = require 'utils.api.keymap.keycombo'
local Swap = require 'utils.api.keymap.swap'
local Type = require 'toolbox.meta.type'

local LOGGER = GetLogger 'KEYMAP'

-- NOTE: this is intentionally exposed as a global; see note in KeyMapper.register fn docs
HANDLERS = {}

---@note: must have one of rhs or swap
---@alias MappedFnSpec { name: string, fn: function }
---@alias KeyMapping { lhs: KeyCombo, rhs: KeyCombo|MappedFnSpec|Swap}

--- Maps to/from arbitrary key combinations.
---
---@class KeyMapper
---@field private app_filter Set
---@field private key string
---@field private keymap KeyMapping[]
local KeyMapper = {}
KeyMapper.__index = KeyMapper

--- Constructor
---
---@param key string: uniquely identifies this instance
---@return KeyMapper: a new instance
function KeyMapper.new(key)
  return setmetatable({
    app_filter = Set.new(),
    key = key or '',
    keymap = {},
  }, KeyMapper)
end

local function process_swap(mapping)
  local lhs = mapping.lhs
  local rhs = mapping.rhs:to_keycombo(lhs)

  return { lhs = lhs, rhs = rhs }
end

local function rhs_is_fn(rhs)
  return Table.is(rhs, { 'name', 'fn' })
end

local function process_rhs(mapping)
  if Type.is(mapping.rhs, KeyCombo) then
    return mapping
  elseif rhs_is_fn(mapping.rhs) then
    return mapping
  elseif Type.is(mapping.rhs, Swap) then
    return process_swap(mapping)
  end

  Err.raise('unrecognized rhs in key binding: %s', mapping.rhs)
end

---@param keymap KeyMapping[]
---@return KeyMapping[]
local function process_rhss(keymap)
  return map(keymap, process_rhs)
end

--- Adds bindings to the instance.
---
---@param keymap (Swap|KeyMapping)[]: an array of bindings
---@return KeyMapper: this instance
function KeyMapper:with(keymap)
  Array.appendall(self.keymap, process_rhss(keymap))
  return self
end

--- Adds an app filter to the instance.
---
---@param ... string: the name(s) of app(s) to which to apply bindings
---@return KeyMapper: this instance
function KeyMapper:with_app(...)
  self.app_filter:addall(...)
  return self
end

local function handle_rhs(lhs, rhs)
  if Type.is(rhs, KeyCombo) then
    return rhs:toevent()
  elseif rhs_is_fn(rhs) then
    rhs.fn()
    return lhs:toevent()
  else
    Err.raise('unrecognized rhs in key binding: "%s"', rhs)
  end
end

local function log_binding_exec(lhs, rhs)
  local rhs_str = rhs_is_fn(rhs) and rhs.name or rhs
  LOGGER:debug('executing binding: %s -> %s', { lhs, rhs_str })
end

---@private
function KeyMapper:should_execute_binding(app)
  return Set.nil_or_empty(self.app_filter) or self.app_filter:contains(app:name())
end

---@private
function KeyMapper:make_handler()
  return function(event)
    local app = hs.application.frontmostApplication()

    if not self:should_execute_binding(app) then
      return event
    end

    for _, binding in ipairs(self.keymap) do
      local lhs = binding.lhs
      local rhs = binding.rhs

      if lhs:matches(event) then
        log_binding_exec(lhs, rhs)
        return handle_rhs(lhs, rhs)
      end
    end

    return event
  end
end

---@private
function KeyMapper:handler()
  return function(ev)
    local ok, res = xpcall(self:make_handler(), debug.traceback, ev)

    if not ok then
      LOGGER:error('mapping failed: %s', { res })
      return true, { ev }
    end

    return true, { res }
  end
end

--- NOTE: this method and the global table it mutates exist to overcome a hammerspoon bug,
--- as detailed here: https://github.com/Hammerspoon/hammerspoon/issues/1859
---
---@private
function KeyMapper:register(listener)
  HANDLERS[self.key] = listener
  return listener
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

  LOGGER:info('binding %s keymap for app(s)=%s', { self.key, self.app_filter:entries() })
  eventtap:start()

  return self:register(eventtap)
end

return KeyMapper
