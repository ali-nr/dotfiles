-- Wezterm Configuration
-- https://wezfurlong.org/wezterm/
--
-- Modules are located in ~/.config/wezterm/

local wezterm = require 'wezterm'
local config = {}

-- Use config_builder for better error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Load modules
local appearance = require 'appearance'
local keys = require 'keys'
local status = require 'status'
local projects = require 'projects'

-- Apply configurations
appearance.apply(config)
keys.apply(config)
status.setup()
projects.setup()

return config
