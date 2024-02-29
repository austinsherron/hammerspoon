---- bootstrap -----------------------------------------------------------------

require 'core.bootstrap'

---- globals -------------------------------------------------------------------

require 'utils.globals' -- import globals before doing anything else

---- spoons --------------------------------------------------------------------

Safe.require 'core.spoons' -- load spoons (i.e.: plugins)

---- keymap --------------------------------------------------------------------

Safe.require 'keymap'

GetLogger('INIT'):info 'Hammerspoon initialization complete'
