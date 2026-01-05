-- Appearance configuration: fonts, colors, window settings
local wezterm = require 'wezterm'
local mux = wezterm.mux
local M = {}

-- Start maximized (not fullscreen) and show project picker after shell loads
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  local gui_window = window:gui_window()
  gui_window:maximize()

  -- Wait for shell to initialize, then show project picker
  wezterm.time.call_after(1.5, function()
    gui_window:perform_action(wezterm.action.EmitEvent 'trigger-project-picker', pane)
  end)
end)

function M.apply(config)
  ----------------------------------------------------------------------------
  -- Font
  ----------------------------------------------------------------------------
  config.font = wezterm.font_with_fallback {
    'JetBrainsMono Nerd Font Mono',
    'JetBrains Mono',
  }
  config.font_size = 16.0
  config.line_height = 1.2

  ----------------------------------------------------------------------------
  -- Color Scheme
  ----------------------------------------------------------------------------
  config.color_scheme = 'Dracula+'

  ----------------------------------------------------------------------------
  -- Window
  ----------------------------------------------------------------------------
  config.window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = '0.5cell',
  }

  -- Window decorations set below with tab bar config for drag support
  config.window_background_opacity = 1.0
  config.macos_window_background_blur = 20

  ----------------------------------------------------------------------------
  -- Tab Bar
  ----------------------------------------------------------------------------
  config.use_fancy_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = false
  config.tab_bar_at_bottom = true
  config.status_update_interval = 1000
  config.tab_max_width = 32

  -- Tab bar styling (controls status bar size)
  config.window_frame = {
    font = wezterm.font { family = 'JetBrainsMono Nerd Font Mono', weight = 'Bold' },
    font_size = 16.0,
  }

  config.window_decorations = 'RESIZE'

  -- Enable window dragging by clicking and holding anywhere
  config.mouse_bindings = {
    {
      event = { Drag = { streak = 1, button = 'Left' } },
      mods = 'SUPER',
      action = wezterm.action.StartWindowDrag,
    },
    {
      event = { Drag = { streak = 1, button = 'Left' } },
      mods = 'CTRL|SHIFT',
      action = wezterm.action.StartWindowDrag,
    },
  }

  ----------------------------------------------------------------------------
  -- Cursor
  ----------------------------------------------------------------------------
  config.default_cursor_style = 'BlinkingBar'
  config.cursor_blink_rate = 500
  config.cursor_blink_ease_in = 'Constant'
  config.cursor_blink_ease_out = 'Constant'

  ----------------------------------------------------------------------------
  -- Bell
  ----------------------------------------------------------------------------
  config.audible_bell = 'Disabled'
  config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = 'CursorColor',
  }

  ----------------------------------------------------------------------------
  -- Scrollback (1 million lines - essentially unlimited)
  ----------------------------------------------------------------------------
  config.scrollback_lines = 1000000
  config.enable_scroll_bar = true
  config.min_scroll_bar_height = '1.5cell'

  ----------------------------------------------------------------------------
  -- Pane Appearance
  ----------------------------------------------------------------------------
  -- Boost foreground brightness for better contrast
  config.colors = {
    split = '#bd93f9',
    foreground = '#f8f8f2',
    background = '#1a1a2e',
    scrollbar_thumb = '#bd93f9',  -- Purple scrollbar to match theme
  }

  -- Slightly boost text contrast
  config.foreground_text_hsb = {
    hue = 1.0,
    saturation = 1.0,
    brightness = 1.2,
  }

  -- Dim inactive panes so active pane stands out
  config.inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.6,
  }

  ----------------------------------------------------------------------------
  -- Performance
  ----------------------------------------------------------------------------
  config.front_end = 'WebGpu'
  config.webgpu_power_preference = 'HighPerformance'
end

return M
