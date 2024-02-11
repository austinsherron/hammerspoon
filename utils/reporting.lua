local Lazy = require 'toolbox.utils.lazy'

local AppLogger = require 'toolbox.app.logger'
local LoggerType = require 'toolbox.log.type'

local logger = AppLogger.new(SpoonConfig, LoggerType.HAMMERSPOON)
local notify = logger.notify

local LOGGERS = {
  INIT = Lazy.value(function()
    return logger:sub 'INIT'
  end),
  SPOONS = Lazy.value(function()
    return logger:sub 'SPOONS'
  end),
}

--- Gets the root nvim logger instance or the scoped sub-logger instance for the provided
--- label.
---
---@param label string|nil: optional; the sub-logger to get
---@return AppLogger: the root nvim logger instance, if label is nil, or the sub-logger
--- instance for the provided label
---@error if the provided label doesn't correspond to a known sub-logger
local function getLogger(label)
  if label == nil then
    return logger
  end

  if LOGGERS[label] == nil then
    error(string.format('No sub-logger=%s', label))
  end

  return LOGGERS[label] --[[@as AppLogger]]
end

local function getNotify()
  return notify
end

return {
  GetLogger = getLogger,
  GetNotify = getNotify,
}
