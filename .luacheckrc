std = "lua5.4"

self = false

files["spec"].std = "+busted"

files[".luacheckrc"].ignore = {"111", "112", "131"}

max_line_length = 90

globals = {
  -- external globals
  'hs',
  'spoon',
  -- internal global logging utils
  'GetLogger',
  'GetNotify',
  -- internal global classes
  'Array',
  'Bool',
  'Dict',
  'Stream',
  'String',
  'Table',
  'Err',
  'Set',
  'Lazy',
  'Map',
  'OnErr',
  'Safe',
  -- internal global functions
  'filter',
  'fmt',
  'foreach',
  'map',
  'ternary',
  -- misc,
  "-"
}
