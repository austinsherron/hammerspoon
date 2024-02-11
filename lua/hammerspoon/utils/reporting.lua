local AppLogger = require 'toolbox.app.logger'
local LoggerType = require 'toolbox.log.type'

local logger = AppLogger.new(SpoonConfig, LoggerType.HAMMERSPOON)
local notify = logger.notify

local function getLogger()
  return logger
end

local function getNotify()
  return notify
end

return {
  GetLogger = getLogger,
  GetNotify = getNotify,
}
