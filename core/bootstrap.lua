-- add lua toolbox to path
-- TODO: figure out a way to do this w/out hardcoding this path
local lua_tools = '/Users/austin/Workspace/workspace/lua-tools'

package.path = package.path .. ';' .. lua_tools .. '/lua/?.lua'
package.path = package.path .. ';' .. lua_tools .. '/lua/?/init.lua'

-- for console support
require 'hs.ipc'
