local Lambda = require 'toolbox.functional.lambda'
local Num = require 'toolbox.core.num'

-- TODO: I have to wonder if this really needs to be hardcoded, or if I can reference an
-- existing value
-- NOTE: the number of volume modulation "steps" when changing volume via volume buttons
local NUM_STEPS = 16

---@return hs.audiodevice
local function sys_output_device()
  return hs.audiodevice.defaultOutputDevice() --[[@as hs.audiodevice]]
end

--- Models a system volume level.
---
---@class VolumeLevel
---@field step integer: the volume level as expressed via discrete steps
---@field percentage integer: the volume level as expressed as a percentage
local VolumeLevel = {}
VolumeLevel.__index = VolumeLevel

local function percentage_to_step(percentage)
  return Num.floor(NUM_STEPS * (percentage / 100))
end

--- Constructs a volume level from the provided percentage.
---
---@param percentage number: a float that represents a system volume percentage
---@return VolumeLevel: a new instance
function VolumeLevel.from_percentage(percentage)
  return setmetatable({
    step = percentage_to_step(percentage),
    percentage = percentage,
  }, VolumeLevel)
end

local function step_to_percentage(step)
  return (100 / NUM_STEPS) * step
end

--- Constructs a volume level from the provided step.
---
---@param step number: an integer that represents a system volume step
---@return VolumeLevel: a new instance
function VolumeLevel.from_step(step)
  return setmetatable({
    step = step,
    percentage = step_to_percentage(step),
  }, VolumeLevel)
end

--- Constructs the current volume level.
---
---@return VolumeLevel: a new instance w/ the current system volume level
function VolumeLevel.current()
  local current = sys_output_device():volume() --[[@as number]]
  return VolumeLevel.from_percentage(current)
end

--- Custom addition metamethod for adding two volume levels.
---
---@param o VolumeLevel: the volume level to add to this instance
---@return VolumeLevel: a new volume level instance whose level is the sum of this
--- instance's and o's levels, w/ an upper bound of 100 percent
function VolumeLevel:__add(o)
  local new_percentage = Num.bounds(self.percentage + o.percentage, 0, 100)
  return VolumeLevel.from_percentage(new_percentage)
end

--- Custom subtraction metamethod for subtracting two volume levels.
---
---@param o VolumeLevel: the volume level to subtract from this instance
---@return VolumeLevel: a new volume level instance whose level is the absolute different
--- of this instance's and o's levels, w/ a lower bound of 0 percent
function VolumeLevel:__sub(o)
  local new_percentage = Num.bounds(self.percentage - o.percentage, 0, 100)
  return VolumeLevel.from_percentage(new_percentage)
end

--- Api for interacting w/ system volume controls
---
---@class Volume
local Volume = {}

--- Gets the current system volume level, either as expressed via "steps", i.e.: the
--- number of blocks displayed when modulating volume through a volume key, or as a number
--- b/w 0 and 100 (percentage).
---
---@param as_step boolean|nil: optional, defaults to true; controls volume output format,
--- i.e.: steps vs percentage
---@return number: the current system volume, expressed as integer steps, by default, or
--- as a percentage, if as_steps == false
function Volume.current(as_step)
  local level = VolumeLevel.current()
  return as_step == false and level.percentage or level.step
end

---@return boolean: true if the system volume is currently muted, false otherwise
function Volume.is_muted()
  return sys_output_device():muted() --[[@as boolean]]
end

--- Toggles the system mute state.
function Volume.toggle_mute()
  sys_output_device():setMuted(not Volume.is_muted())
end

--- Sets the system volume to the provided level.
---
---@param level VolumeLevel: the level to which to set the system volume
function Volume.set(level)
  sys_output_device():setVolume(level.percentage)
end

local function moduldate(steps, direction)
  local current = VolumeLevel.current()
  local diff = VolumeLevel.from_step(steps or 1)
  local updated = direction(current, diff)

  Volume.set(updated)
end

--- Increases the system volume by the provided number of steps.
---
---@param steps integer|nil; optional, defaults to 1; the number of steps by which to
--- increase the volume
function Volume.increase(steps)
  moduldate(steps, Lambda.ADD)
end

--- Decreases the system volume by the provided number of steps.
---
---@param steps integer|nil; optional, defaults to 1; the number of steps by which to
--- decrease the volume
function Volume.decrease(steps)
  moduldate(steps, Lambda.SUB)
end

return Volume
