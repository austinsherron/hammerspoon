local Keys = require 'utils.api.keys'
local Num = require 'toolbox.core.num'
local Type = require 'toolbox.meta.type'

--- Models a single key.
---
---@class Key
---@field code integer: the key's keycode
local Key = {}
Key.__index = Key

--- Constructor
---
---@param key Key|string|integer: a representation of a key
---@return Key: a new instance
function Key.new(key)
  local code = nil

  if Type.is(key, Key) then
    code = key.code
  elseif String.is(key) then
    code = Keys.code(key --[[@as string]])
  elseif Num.isint(key) then
    code = key
  else
    Err.raise('invalid key=%s', key or 'nil')
  end

  return setmetatable({ code = code }, Key)
end

--- Checks if key is a valid type for a Key.
---
---@param o any: the object to check
---@return boolean: true if key is a valid type for a Key, false otherwise
function Key.is(o)
  return Type.is(o, Key) or String.is(o) or Num.isint(o)
end

--- Checks if l and r are equivalent keys, regardless of representation.
---
---@param l Key|string|integer: one of the "keys" to check
---@param r Key|string|integer: the other of the "keys" to check
---@return boolean: true if l and r are equivalent keys, false otherwise
function Key.same(l, r)
  return Key.new(l) == Key.new(r)
end

--- Checks if this Key and o are equal.
---
---@param o Key: the other key
---@return boolean: true if this Key and o are equal, false otherwise
function Key:__eq(o)
  return self.code == o.code
end

---@return string: a string representation of this instance
function Key:__tostring()
  return Keys.key(self.code)
end

return Key
