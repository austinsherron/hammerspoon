local Lazy = require 'toolbox.utils.lazy'
local SpoonLogger = require 'utils.reporting.logger'

local logger = SpoonLogger.new(SpoonConfig)

local LOGGERS = {
  HOTKEY = Lazy.value(function()
    return logger:sub 'HOTKEY'
  end),
  INIT = Lazy.value(function()
    return logger:sub 'INIT'
  end),
  KEYMAP = Lazy.value(function()
    return logger:sub 'KEYMAP'
  end),
  MOUSE = Lazy.value(function()
    return logger:sub 'MOUSE'
  end),
  QUAKE = Lazy.value(function()
    return logger:sub 'QUAKE'
  end),
  SCREEN = Lazy.value(function()
    return logger:sub 'SCREEN'
  end),
  SPACES = Lazy.value(function()
    return logger:sub 'SPACES'
  end),
  SPOONS = Lazy.value(function()
    return logger:sub 'SPOONS'
  end),
  WATCHER = Lazy.value(function()
    return logger:sub 'WATCHER'
  end),
  WINDOW = Lazy.value(function()
    return logger:sub 'WINDOW'
  end),
  WINMGR = Lazy.value(function()
    return logger:sub 'WINMGR'
  end),
}

--- Gets the root logger instance or the scoped sub-logger instance for the provided
--- label.
---
---@param label string|nil: optional; the sub-logger to get
---@return SpoonLogger: the root logger instance, if label is nil, or the sub-logger
--- instance for the provided label
---@error if the provided label doesn't correspond to a known sub-logger
return function(label)
  if label == nil then
    return logger
  end

  if LOGGERS[label] == nil then
    error(string.format('No sub-logger=%s', label))
  end

  return LOGGERS[label] --[[@as SpoonLogger]]
end
