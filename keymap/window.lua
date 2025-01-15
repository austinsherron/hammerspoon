local Hotkey = require 'utils.ctrl.hotkey'
local Window = require 'utils.api.window'

local RelPos = require('utils.api.screen').RelativePosition

-- window interactions ---------------------------------------------------------

-- minimize/maximize

Hotkey.hotkey(
  'm',
  { name = 'Window > minimize (force)', fn = Window.force_minimize },
  { 'cmd' }
)
Hotkey.hotkey(
  'm',
  { name = 'Window > maximize', fn = Window.maximize },
  { 'cmd', 'shift' }
)

-- move to screen

Hotkey.hotkey('h', {
  name = 'Window > move screen left',
  fn = Lambda.make(Window.move_to_screen, RelPos.WEST),
}, { 'cmd', 'alt' })

Hotkey.hotkey('l', {
  name = 'Window > move screen right',
  fn = Lambda.make(Window.move_to_screen, RelPos.EAST),
}, { 'cmd', 'alt' })

Hotkey.hotkey('j', {
  name = 'Window > move screen down',
  fn = Lambda.make(Window.move_to_screen, RelPos.SOUTH),
}, { 'cmd', 'alt' })

Hotkey.hotkey('k', {
  name = 'Window > move screen up',
  fn = Lambda.make(Window.move_to_screen, RelPos.NORTH),
}, { 'cmd', 'alt' })

-- move to space

Hotkey.hotkey('1', {
  name = 'Window > move to space 1',
  fn = Lambda.make(Window.move_to_space, 1),
}, { 'cmd', 'ctrl' })

Hotkey.hotkey('2', {
  name = 'Window > move to space 2',
  fn = Lambda.make(Window.move_to_space, 2),
}, { 'cmd', 'ctrl' })

Hotkey.hotkey('3', {
  name = 'Window > move to space 3',
  fn = Lambda.make(Window.move_to_space, 3),
}, { 'cmd', 'ctrl' })

Hotkey.hotkey('4', {
  name = 'Window > move to space 4',
  fn = Lambda.make(Window.move_to_space, 4),
}, { 'cmd', 'ctrl' })

Hotkey.hotkey('5', {
  name = 'Window > move to space 5',
  fn = Lambda.make(Window.move_to_space, 5),
}, { 'cmd', 'ctrl' })

Hotkey.hotkey('6', {
  name = 'Window > move to space 6',
  fn = Lambda.make(Window.move_to_space, 6),
}, { 'cmd', 'ctrl' })

Hotkey.hotkey('7', {
  name = 'Window > move to space 7',
  fn = Lambda.make(Window.move_to_space, 7),
}, { 'cmd', 'ctrl' })

Hotkey.hotkey('8', {
  name = 'Window > move to space 8',
  fn = Lambda.make(Window.move_to_space, 8),
}, { 'cmd', 'ctrl' })

Hotkey.hotkey('9', {
  name = 'Window > move to space 9',
  fn = Lambda.make(Window.move_to_space, 9),
}, { 'cmd', 'ctrl' })
