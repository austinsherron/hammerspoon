local Keys = {}

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

return Keys
