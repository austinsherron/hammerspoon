local Keys = {}

local CODES_TO_KEYS = Table.reverse_items(hs.keycodes.map)

--- Gets the keycode associated w/ the provided key.
---
---@param key string: the key for which to retrieve a code
---@return integer: the code that maps to key
---@error if key doesn't map to a keycode
function Keys.code(key)
  local keycode = hs.keycodes.map[key]

  if keycode == nil then
    Err.raise('key=%s is not recognized', key)
  end

  return keycode --[[@as integer]]
end

--- Gets the key associated w/ the provided keycode.
---
---@param code integer: the code for which to retrieve a key
---@return string: the key that maps to code
---@error if key doesn't map to a keycode
function Keys.key(code)
  local key = CODES_TO_KEYS[code]

  if key == nil then
    Err.raise('code=%s is not recognized', code)
  end

  return key --[[@as string]]
end

return Keys
