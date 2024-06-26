-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:w
config.bidi_enabled = true
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.color_scheme = 'Catppuccin Mocha'
config.cursor_blink_rate = 1
config.hide_tab_bar_if_only_one_tab = true
-- and finally, return the configuration to wezterm
return config
