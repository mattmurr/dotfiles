local wezterm = require 'wezterm';

local config = wezterm.config_builder()

config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 14.0
config.send_composed_key_when_right_alt_is_pressed = true

return config
