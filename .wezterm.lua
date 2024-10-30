local wezterm = require 'wezterm';

local config = wezterm.config_builder()

config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 3000 }
config.keys = {
  {
    key = '%',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
    key = '"',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection 'Left'
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection 'Right'
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection 'Down'
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection 'Up'
  },
  {
    key = 'z',
    mods = 'LEADER',
    action = wezterm.action.TogglePaneZoomState,
  }
}

config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 14.0
config.send_composed_key_when_right_alt_is_pressed = true

return config
