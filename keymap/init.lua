local Import = require 'toolbox.utils.import'
local Path = require 'toolbox.system.path'

-- recursively require all lua files in this dir
Import.require_for_init(Path.script_path(), 'keymap', function(fn, name)
  print('importing', name)
  return fn()
end)
