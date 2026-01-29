local Hotkey = require 'utils.ctrl.hotkey'
local Quake = require 'utils.ctrl.quake'
local Shell = require 'toolbox.system.shell'

local HK = Hotkey.modal({ 'F1', 'F12' })
local QK = Quake.get()

local function incognito()
  Shell.run '/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --incognito'
end

local function brave_private()
  Shell.run 'brave-browser-private'
end

-- launch/focus apps -----------------------------------------------------------

HK:with({
  { '1', '1Password' },
  { ',', 'System Settings' },
  { 'b', 'Brave Browser' },
  { 'c', 'Cursor' },
  { 'd', 'TablePlus' },
  { 'f', 'Finder' },
  { 'g', 'Google Chrome' },
  { 'i', { name = 'Google Chrome incognito', fn = incognito } },
  { 'k', 'Bazecor' },
  { 'p', { name = 'Brave Browser Private', fn = brave_private } },
  { 'q', 'Quicktime' },
  { 's', 'Slack' },
  { 'z', 'Zoom' },
})

-- toggle quake windows --------------------------------------------------------

HK:with({
  { 'h', { name = 'Quake > Hammerspoon', fn = QK:for_binding 'Hammerspoon' } },
  { 'w', { name = 'Quake > WhatsApp', fn = QK:for_binding 'WhatsApp' } },
})

HK:bind()
