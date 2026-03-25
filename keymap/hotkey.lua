local Hotkey = require 'utils.ctrl.hotkey'
local Layout = require 'utils.ctrl.layout'
local Mouse = require 'utils.ctrl.mouse'
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
  { 'f', 'Finder' },
  { 'g', 'Google Chrome' },
  { 'i', { name = 'Google Chrome incognito', fn = incognito } },
  { 'k', 'Bazecor' },
  { 'p', { name = 'Brave Browser Private', fn = brave_private } },
  { 'q', 'Quicktime' },
  { 's', 'Slack' },
  { 't', 'TablePlus' },
  { 'z', 'Zoom' },
})

-- toggle quake windows --------------------------------------------------------

HK:with({
  { 'h', { name = 'Quake > Hammerspoon', fn = QK:for_binding 'Hammerspoon' } },
  { 'w', { name = 'Quake > WhatsApp', fn = QK:for_binding 'WhatsApp' } },
})

-- layouts ---------------------------------------------------------------------

HK:with({
  { '-', { name = 'Layout > horizontal tile', fn = Layout.tile_windows_horizontally } },
  { '\\', { name = 'Layout > vertical tile', fn = Layout.tile_windows_vertically } },
  { ';', { name = 'Layout > maximize all', fn = Layout.maximize_all_windows } },
  { '/', { name = 'Mouse > next window', fn = Mouse.next_window } },
  { '.', { name = 'Mouse > prev window', fn = Mouse.prev_window } },
  { ']', { name = 'Layout > swap right', fn = Layout.swap_window_to_right } },
  { '[', { name = 'Layout > swap left', fn = Layout.swap_window_to_left } },
})

HK:bind()
