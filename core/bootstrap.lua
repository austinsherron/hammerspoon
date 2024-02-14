-- add lua toolbox to path
-- TODO: figure out a way to do this w/out hardcoding this path
local code_root = '/Users/austin/Workspace/workspace'

package.path = package.path .. ';' .. code_root .. '/lib/lua/?.lua'
package.path = package.path .. ';' .. code_root .. '/lib/lua/?/init.lua'

-- for console support
require 'hs.ipc'
