---@alias SpoonSpec { name: string, opts: table|nil }

--- Installs and activates spoons (i.e.: plugins/extensions).
---
---@class SpoonManager
local SpoonManager = {}

--- Loads the spoon w/ the provided name and options.
---
---@param name string: the name of the spoon
---@param opts table|nil: optional; spoon configuration options
function SpoonManager.load(name, opts)
  spoon.SpoonInstall:andUse(name, opts)
end

local function load_spoon(spec)
  SpoonManager.load(spec.name, spec.opts)
end

--- Installs and activates the spoons returned from the module at path.
---
--- TODO: add features:
---  1) cleanup unused packages
---
---@param path string: a lua import path whose module returns an array of SpoonSpecs
function SpoonManager.init(path)
  hs.loadSpoon 'SpoonInstall'

  foreach(require(path), load_spoon)
end

return SpoonManager
