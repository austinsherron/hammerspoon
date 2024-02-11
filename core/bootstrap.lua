local code_root = os.getenv 'CODE_ROOT'

package.path = package.path .. ';' .. code_root .. '/lib/lua/?.lua'
package.path = package.path .. ';' .. code_root .. '/lib/lua/?/init.lua'
