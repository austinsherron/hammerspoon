local Env = require 'toolbox.system.env'
local File = require 'toolbox.system.file'

local SPOON_INSTALL = Env.config_root_pub() .. '/hammerspoon/Spoons/SpoonInstall.spoon'

local SpoonManager = {}

function SpoonManager.load(name, opts)
  spoon.SpoonInstall:andUse(name, opts)
end

local function load_spoon(spec)
  SpoonManager.load(spec.name, spec.opts)
end

--- TODO: add features:
---  1) download SpoonInstall if it doesn't exist
---  2) cleanup unused packages
function SpoonManager.init(path)
  hs.loadSpoon 'SpoonInstall'

  foreach(require(path), load_spoon)
end

return SpoonManager
