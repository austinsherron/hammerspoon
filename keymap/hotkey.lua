local Hotkey = require 'utils.ctrl.hotkey'
local Quake = require 'utils.ctrl.quake'
local Shell = require 'toolbox.system.shell'

local HK = Hotkey.modal({ 'F1', 'F12' })
local QK = Quake.get()

local function chrome_incognito()
  Shell.run 'google-chrome-incognito'
end

local function brave_private()
  Shell.run 'brave-browser-private'
end

-- launch/focus apps -----------------------------------------------------------

HK:with({
  { '1', '1Password' },
  { ',', 'System Settings' },
  { 'b', 'Brave Browser' },
  { 'c', 'Google Chrome' },
  { 'd', 'Docker' },
  { 'f', 'Finder' },
  { 'i', { name = 'Google Chrome Incognito', fn = chrome_incognito } },
  { 'k', 'Bazecor' },
  { 'p', { name = 'Brave Browser Private', fn = brave_private } },
  { 'q', 'Quicktime' },
  { 'z', 'zoom.us' },
})

-- toggle quake windows --------------------------------------------------------

HK:with({
  { 'h', { name = 'Quake > Hammerspoon', fn = QK:for_binding 'Hammerspoon' } },
  { 't', { name = 'Quake > Telegram', fn = QK:for_binding 'Telegram' } },
  { 'w', { name = 'Quake > WhatsApp', fn = QK:for_binding 'WhatsApp' } },
})

HK:bind()
