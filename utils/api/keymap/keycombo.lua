local Args = require 'toolbox.utils.args'
local Key = require 'utils.api.keymap.key'

--- Models a key combination.
---
---@class KeyCombo
---@field private mods string[]|nil
---@field private key Key|nil
local KeyCombo = {}
KeyCombo.__index = KeyCombo

--- Constructor
---
---@param ... string[]|string|integer one or both of mods (string[]) and a key
--- (string|integer)
---@return KeyCombo: a new instance
function KeyCombo.new(...)
  local args = Args.filter_nil(...)
  local this = {}

  if Array.len(args) == 2 then
    this = { mods = args[1], key = Key.new(args[2]) }
  elseif Array.len(args) == 1 and Key.is(args[1]) then
    this = { key = Key.new(args[1]) }
  elseif Array.len(args) == 1 and Table.is(args[1]) then
    this = { mods = args[1] }
  else
    Err.raise('KeyCombo: invalid key combination=%s', { args })
  end

  return setmetatable(this, KeyCombo)
end

--- Checks if this instances matches the keys represented in the event.
---
---@param event hs.eventtap.event: the event to check
---@return boolean: true if this instances matches the keys represented in the event,
--- false otherwise
function KeyCombo:matches(event)
  local flags = event:getFlags()
  local code = event:getKeyCode()
  local key = code ~= nil and Key.new(code) or nil

  ---@diagnostic disable-next-line: need-check-nil, undefined-field
  return flags:containExactly(self.mods) and self.key == key
end

--- Creates an event from this instance.
---
---@return hs.eventtap.event: a event comprised of the constituents of this instance
function KeyCombo:toevent()
  local mods = self.mods
  local key = Table.safeget(self.key, 'code')

  return hs.eventtap.event.newKeyEvent(mods, key, true)
end

local function mods__tostring(mods)
  if Table.nil_or_empty(mods) then
    return ''
  end

  return fmt('[%s]', String.join(mods, '|'))
end

---@return string: a string representation of this instance
function KeyCombo:__tostring()
  local mods_str = self.mods == nil and '' or mods__tostring(self.mods)
  local key_str = self.key or ''
  local sep = (mods_str ~= '' and key_str ~= '') and ' + ' or ''

  return fmt('%s%s%s', mods_str, sep, key_str)
end

return setmetatable(KeyCombo, {
  __call = function(...) return KeyCombo.new(...) end
})
