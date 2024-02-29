local Class = require 'toolbox.meta.class'
local Key = require 'utils.api.keymap.key'
local KeyCombo = require 'utils.api.keymap.keycombo'

local LOGGER = GetLogger 'KEYMAP'

--- Models a KeyCombo in terms of which keys to replace in another KeyCombo.
---
---@class Swap
---@field private old string
---@field private nw string
local Swap = {}
Swap.__index = Swap

--- Constructor
---
---@param old string: the key in another KeyCombo to replace
---@param new string: the key w/ which to replace old
---@return Swap: a new instance
function Swap.new(old, new)
  return setmetatable({ old = old, nw = new }, Swap)
end

local function process_key_swap(key, old, new)
  if key == nil then
    return nil
  end

  return (Key.same(key, old)) and new or key
end

---@private
function Swap:process_key_swap(key)
  return process_key_swap(key, self.old, self.nw)
end

---@private
function Swap:process_mods_swap(mods)
  if mods == nil then
    return nil
  end

  return map(mods, function(mod)
    return process_key_swap(mod, self.old, self.nw)
  end)
end

--- Creates a new KeyCombo from the provided KeyCombo and this instance.
---
---@param lhs KeyCombo: the KeyCombo on which to base swaps
---@return KeyCombo: a new KeyCombo constructed from lhs and this instance
function Swap:to_keycombo(lhs)
  ---@diagnostic disable-next-line: invisible
  local key = self:process_key_swap(lhs.key)
  ---@diagnostic disable-next-line: invisible
  local mods = self:process_mods_swap(lhs.mods)

  local rhs = KeyCombo.new(mods, key ~= nil and Key.new(key) or nil)
  LOGGER:debug('processed swap=%s -> %s', { self, rhs })
  return rhs
end

---@return string: a string representation of this instance
function Swap:__tostring()
  return fmt('swap: %s -> %s', self.old, self.nw)
end

return Class.callable(Swap)
