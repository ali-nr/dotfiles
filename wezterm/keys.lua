-- Key bindings configuration
local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

function M.apply(config)
  -- Leader key: Ctrl+a (like tmux)
  config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

  config.keys = {
    ----------------------------------------------------------------------------
    -- Pane Management
    ----------------------------------------------------------------------------
    -- Splitting
    {
      key = '|',
      mods = 'LEADER|SHIFT',
      action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      key = '-',
      mods = 'LEADER',
      action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },

    -- Navigation (vim-style)
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

    -- Navigation (arrow keys)
    { key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

    -- Navigation (by index)
    { key = 'F1', mods = 'NONE', action = act.ActivatePaneByIndex(0) },
    { key = 'F2', mods = 'NONE', action = act.ActivatePaneByIndex(1) },
    { key = 'F3', mods = 'NONE', action = act.ActivatePaneByIndex(2) },
    { key = 'F4', mods = 'NONE', action = act.ActivatePaneByIndex(3) },

    -- Resizing
    { key = 'H', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'J', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'K', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'L', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },

    -- Close & Zoom
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

    ----------------------------------------------------------------------------
    -- Tab Management
    ----------------------------------------------------------------------------
    { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },

    -- Project picker (recent directories from zsh-z)
    { key = 'Space', mods = 'LEADER', action = act.EmitEvent 'trigger-project-picker' },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },

    -- Quick tab switching
    { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
    { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
    { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
    { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
    { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
    { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
    { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
    { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
    { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },

    ----------------------------------------------------------------------------
    -- Copy & Search (keyboard-driven)
    ----------------------------------------------------------------------------
    { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
    { key = '/', mods = 'LEADER', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 's', mods = 'LEADER', action = act.QuickSelect },

    -- Open URLs with keyboard hints
    {
      key = 'o',
      mods = 'LEADER',
      action = act.QuickSelectArgs {
        label = 'open url',
        patterns = { 'https?://\\S+' },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.open_with(url)
        end),
      },
    },

    ----------------------------------------------------------------------------
    -- General
    ----------------------------------------------------------------------------
    -- Shift+Enter sends literal newline (for multi-line input in Claude Code, etc.)
    { key = 'Enter', mods = 'SHIFT', action = act.SendString '\n' },

    { key = 'P', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },

    { key = '+', mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
    { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },
  }

  ----------------------------------------------------------------------------
  -- Mouse Bindings
  ----------------------------------------------------------------------------
  -- Bypass tmux mouse reporting when Cmd is held
  config.bypass_mouse_reporting_modifiers = 'CMD'

  config.mouse_bindings = {
    -- Click selects text only
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    },
    -- Cmd-click opens links (bypasses tmux)
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CMD',
      action = act.OpenLinkAtMouseCursor,
    },
  }
end

return M
