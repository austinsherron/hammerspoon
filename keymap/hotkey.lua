local Hotkey = require 'utils.ctrl.hotkey'
local Quake = require 'utils.ctrl.quake'
local Shell = require 'toolbox.system.shell'

local HK = Hotkey.modal({ 'F1', 'F12' })
local QK = Quake.get()

local function incognito()
  Shell.run '/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --incognito'
end

-- launch/focus apps -----------------------------------------------------------

HK:with({
  { '1', '1Password' },
  { ',', 'System Settings' },
  { 'b', 'Brave Browser' },
  { 'c', 'Google Chrome' },
  { 'f', 'Finder' },
  { 'i', { name = 'Google Chrome incognito', fn = incognito } },
  { 'k', 'Bazecor' },
<<<<<<< Updated upstream
  { 'z', 'Zoom' },
=======
  { 'p', { name = 'Brave Browser Private', fn = brave_private } },
  { 'q', 'Quicktime' },
  { 's', 'Slace' },
  { 'z', 'zoom.us' },
>>>>>>> Stashed changes
})

-- toggle quake windows --------------------------------------------------------

HK:with({
  { 'd', { name = 'Quake > Discord', fn = QK:for_binding 'Discord' } },
  { 'h', { name = 'Quake > Hammerspoon', fn = QK:for_binding 'Hammerspoon' } },
  { 's', { name = 'Quake > Slack', fn = QK:for_binding 'Slack' } },
  { 't', { name = 'Quake > iTerm', fn = QK:for_binding 'Telegram' } },
  { 'w', { name = 'Quake > WhatsApp', fn = QK:for_binding 'WhatsApp' } },
})

HK:bind()
