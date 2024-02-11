local Import = require 'toolbox.system.import'
local Path = require 'toolbox.system.path'

GetLogger():warn('script path=%s', { Path.script_path() })
