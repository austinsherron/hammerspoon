local Hotkey = require("utils.ctrl.hotkey")
local Spaces = require("utils.api.spaces")

-- interactions ----------------------------------------------------------------

Hotkey.hotkey("=", {
  name = "Add space",
  fn = function()
    Spaces.add({ closeMC = true })
  end,
}, { "cmd", "shift" })

Hotkey.hotkey("1", {
  name = "Focus space 1",
  fn = function()
    Spaces.focus(1)
  end,
}, { "cmd", "alt" })

Hotkey.hotkey("2", {
  name = "Focus space 2",
  fn = function()
    Spaces.focus(2)
  end,
}, { "cmd", "alt" })

Hotkey.hotkey("3", {
  name = "Focus space 3",
  fn = function()
    Spaces.focus(3)
  end,
}, { "cmd", "alt" })

Hotkey.hotkey("4", {
  name = "Focus space 4",
  fn = function()
    Spaces.focus(4)
  end,
}, { "cmd", "alt" })

Hotkey.hotkey("5", {
  name = "Focus space 5",
  fn = function()
    Spaces.focus(5)
  end,
}, { "cmd", "alt" })

Hotkey.hotkey("6", {
  name = "Focus space 6",
  fn = function()
    Spaces.focus(6)
  end,
}, { "cmd", "alt" })
