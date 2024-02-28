local LogFormatter = require 'toolbox.log.formatter'
local LogLevel = require 'toolbox.log.level'
local Logger = require 'toolbox.log.logger'
local LoggerType = require 'toolbox.log.type'

--- Runtime logger for hammerspoon.
---
---@class SpoonLogger
---@field private logger Logger
---@field private level LogLevel
---@field private label string|nil
local SpoonLogger = {}
SpoonLogger.__index = SpoonLogger

-- TODO: figure out how to read log level from env
local function current_level(config)
  -- return config:log_level() or LogLevel.default()
  return LogLevel.DEBUG
end

--- Constructor
---
---@param config AppConfig: hammerspoon config object
---@param label string|nil: optional; an optional prefix label for logged messages
---@return SpoonLogger: a new instance
function SpoonLogger.new(config, label)
  local logger = Logger.new(LoggerType.HAMMERSPOON, current_level(config), label)

  return setmetatable({
    logger = logger,
    level = current_level(config),
    label = label,
  }, SpoonLogger)
end

--- Creates a new sub-logger from this instance using the provided label.
---
---@param label string: a prefix label for logged messages
---@return SpoonLogger: a new sub-logger instance w/ the provided label
function SpoonLogger:sub(label)
  return setmetatable({
    logger = self.logger:sub(label),
    level = self.level,
    label = label,
  }, SpoonLogger)
end

local function log_method(this, level)
  local method_name = string.lower(tostring(level))
  return this.logger[method_name]
end

local function notify(level, label, to_log, args, opts)
  local notify_opts = Table.combine({ endln = '' }, opts or {})
  print(LogFormatter.format(level, label, to_log, args, notify_opts))
end

---@private
function SpoonLogger:do_log(level, to_log, args, opts)
  opts = opts or {}

  if level:should_log(self.level) then
    notify(level, self.label, to_log, args, opts)
  end

  -- local method = log_method(self, level)
  -- method(self.logger, to_log, args, opts)
end

local function log_logger_failure(label, err)
  local ok, res = xpcall(
    notify,
    debug.traceback,
    LogLevel.ERROR,
    label,
    'unexpected logger failure: %s',
    { err or '?' }
  )

  if not ok then
    print('[ERROR] catastrophic logger failure: ' .. (res or '?'))
  end
end

---@private
function SpoonLogger:log(level, to_log, args, opts)
  local ok, res = pcall(SpoonLogger.do_log, self, level, to_log, args, opts)

  if ok then
    return
  end

  log_logger_failure(self.label, res)
end

--- Logs a trace level message.
---
---@param to_log any: the formattable string or object to log
---@param args any[]|nil: an array of objects to format into to_log
---@param opts LoggerOpts|nil: options that control logging behavior
function SpoonLogger:trace(to_log, args, opts)
  self:log(LogLevel.TRACE, to_log, args, opts)
end

--- Logs a debug level message.
---
---@param to_log any: the formattable string or object to log
---@param args any[]|nil: an array of objects to format into to_log
---@param opts LoggerOpts|nil: options that control logging behavior
function SpoonLogger:debug(to_log, args, opts)
  self:log(LogLevel.DEBUG, to_log, args, opts)
end

--- Logs an info level message.
---
---@param to_log any: the formattable string or object to log
---@param args any[]|nil: an array of objects to format into to_log
---@param opts LoggerOpts|nil: options that control logging behavior
function SpoonLogger:info(to_log, args, opts)
  self:log(LogLevel.INFO, to_log, args, opts)
end

--- Logs a warn level message.
---
---@param to_log any: the formattable string or object to log
---@param args any[]|nil: an array of objects to format into to_log
---@param opts LoggerOpts|nil: options that control logging behavior
function SpoonLogger:warn(to_log, args, opts)
  self:log(LogLevel.WARN, to_log, args, opts)
end

--- Logs an error level message.
---
---@param to_log any: the formattable string or object to log
---@param args any[]|nil: an array of objects to format into to_log
---@param opts LoggerOpts|nil: options that control logging behavior
function SpoonLogger:error(to_log, args, opts)
  self:log(LogLevel.ERROR, to_log, args, opts)
end

return SpoonLogger
