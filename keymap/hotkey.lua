local Hotkey = require 'utils.ctrl.hotkey'
local Quake = require 'utils.ctrl.quake'
local Shell = require 'toolbox.system.shell'

local HK = Hotkey.modal({ 'F1', 'F10' })
local QK = Quake.get()

local function incognito()
  Shell.run '/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --incognito'
end

-- app bindings
HK:with({
  { '1', '1Password' },
  { ',', 'System Settings' },
  { 'b', 'Brave Browser' },
  { 'c', 'Google Chrome' },
  { 'h', 'Hammerspoon' },
  { 'i', incognito },
  { 'k', 'Bazecor' },
  { 't', QK:for_binding 'iTerm' },
  { 'w', QK:for_binding 'WhatsApp' },
  { 'z', 'Zoom' },
})

HK:bind()
