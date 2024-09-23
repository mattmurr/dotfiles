local wezterm = require 'wezterm';

local config = wezterm.config_builder()

-- Custom config here
--
--
config.font = wezterm.font("Iosevka Term")
config.font_size = 14.0
config.send_composed_key_when_right_alt_is_pressed = true

return config
