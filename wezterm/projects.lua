-- Recent directories picker using zsh-z history
--
-- Dracula color palette (for reference):
--   Background:  #282a36
--   Foreground:  #f8f8f2
--   Comment:     #6272a4
--   Cyan:        #8be9fd
--   Green:       #50fa7b
--   Orange:      #ffb86c
--   Pink:        #ff79c6
--   Purple:      #bd93f9
--   Red:         #ff5555
--   Yellow:      #f1fa8c

local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

-- Get all active session directories from current mux window
local function get_active_sessions(mux_window)
  local active_dirs = {}
  for _, tab in ipairs(mux_window:tabs()) do
    local active_pane = tab:active_pane()
    if active_pane then
      local cwd = active_pane:get_current_working_dir()
      if cwd then
        local path = cwd.file_path
        if path then
          active_dirs[path] = { tab = tab, tab_id = tab:tab_id() }
        end
      end
    end
  end
  return active_dirs
end

-- Read and parse ~/.z file (zsh-z format: path|frequency|timestamp)
local function get_recent_directories(mux_window)
  local home = os.getenv('HOME')
  local z_file = home .. '/.z'
  local directories = {}

  local file = io.open(z_file, 'r')
  if not file then
    return directories
  end

  local entries = {}
  for line in file:lines() do
    local path, freq, timestamp = line:match('(.+)|(%d+)|(%d+)')
    if path and freq and timestamp then
      table.insert(entries, {
        path = path,
        freq = tonumber(freq),
        timestamp = tonumber(timestamp),
      })
    end
  end
  file:close()

  -- Get active sessions
  local active_sessions = get_active_sessions(mux_window)

  -- Sort: active sessions first (by frequency), then inactive (by frequency)
  table.sort(entries, function(a, b)
    local a_active = active_sessions[a.path] ~= nil
    local b_active = active_sessions[b.path] ~= nil
    if a_active ~= b_active then
      return a_active
    end
    -- Both active or both inactive: sort by frequency (most used first)
    return a.freq > b.freq
  end)

  -- Track paths we've added to avoid duplicates
  local added_paths = {}

  -- Add home directory first if it has an active session
  if active_sessions[home] then
    table.insert(directories, {
      id = home,
      label = '●  ~',
    })
    added_paths[home] = true
  end

  -- Convert to choices format, limit to top 50
  for i, entry in ipairs(entries) do
    if #directories >= 50 then break end
    if added_paths[entry.path] then goto continue end

    -- Shorten home directory to ~
    local display_path = entry.path
    if display_path:sub(1, #home) == home then
      display_path = '~' .. display_path:sub(#home + 1)
    end

    -- Check if session is active
    local is_active = active_sessions[entry.path] ~= nil
    local indicator = is_active and '●' or '○'

    table.insert(directories, {
      id = entry.path,
      label = indicator .. '  ' .. display_path,
    })
    added_paths[entry.path] = true

    ::continue::
  end

  return directories, active_sessions
end

function M.setup()
  -- Event: open directory picker
  wezterm.on('trigger-project-picker', function(window, pane)
    local mux_window = window:mux_window()
    local choices, active_sessions = get_recent_directories(mux_window)

    if #choices == 0 then
      wezterm.log_error('No recent directories found in ~/.z')
      return
    end

    window:perform_action(
      act.InputSelector {
        title = '  Projects',
        choices = choices,
        fuzzy = true,
        fuzzy_description = 'Select a directory',
        action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
          if id then
            inner_window:perform_action(
              act.InputSelector {
                title = '  Open in...',
                choices = {
                  { id = 'tab', label = 'New tab' },
                  { id = 'same', label = 'This pane (cd)' },
                  { id = 'vsplit', label = 'Split horizontal' },
                  { id = 'hsplit', label = 'Split vertical' },
                },
                action = wezterm.action_callback(function(w, p, open_type, _)
                  if open_type == 'same' then
                    p:send_text('cd ' .. id .. '\n')
                  elseif open_type == 'tab' then
                    w:mux_window():spawn_tab { cwd = id }
                  elseif open_type == 'vsplit' then
                    p:split { direction = 'Right', cwd = id }
                  elseif open_type == 'hsplit' then
                    p:split { direction = 'Bottom', cwd = id }
                  end
                end),
              },
              inner_pane
            )
          end
        end),
      },
      pane
    )
  end)
end

function M.apply(config)
  -- Add keybinding: Ctrl+a then t for project picker
  -- This will be merged with existing keys in keys.lua
end

return M
