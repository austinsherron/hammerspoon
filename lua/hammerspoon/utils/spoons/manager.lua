local SpoonManager = {}

function SpoonManager.load(name, opts)
  spoon.SpoonInstall:andUse(name, opts)
end

local function load_spoon(spec)
  SpoonManager.load(spec.name, spec.opts)
end

function SpoonManager.init(path)
  local spoons = require(path)

  foreach(spoons, load_spoon)
end

return SpoonManager
