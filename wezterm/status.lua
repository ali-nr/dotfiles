-- Status bar configuration
local wezterm = require 'wezterm'
local M = {}

-- Dracula color palette
local colors = {
  purple = '#bd93f9',
  pink = '#ff79c6',
  green = '#50fa7b',
  cyan = '#8be9fd',
  foreground = '#f8f8f2',
}

-- Get current working directory from pane
local function get_cwd(pane)
  local cwd_uri = pane:get_current_working_dir()
  if not cwd_uri then
    return ''
  end

  local cwd
  if type(cwd_uri) == 'userdata' then
    cwd = cwd_uri.file_path
  else
    cwd = cwd_uri:sub(8):gsub('%%(%x%x)', function(hex)
      return string.char(tonumber(hex, 16))
    end)
  end

  -- Shorten home directory to ~
  local home = os.getenv('HOME')
  if home and cwd:sub(1, #home) == home then
    cwd = '~' .. cwd:sub(#home + 1)
  end

  return cwd
end

-- Get git branch for current directory
local function get_git_branch(cwd)
  if cwd == '' then
    return nil
  end

  local full_path = cwd:gsub('~', os.getenv('HOME') or '')
  local success, stdout = wezterm.run_child_process({
    'git', '-C', full_path, 'branch', '--show-current'
  })

  if success and stdout then
    local branch = stdout:gsub('%s+', '')
    if branch ~= '' then
      return branch
    end
  end

  return nil
end

-- Get battery icon based on charge level
local function get_battery_icon(charge)
  if charge >= 0.9 then
    return wezterm.nerdfonts.md_battery
  elseif charge >= 0.7 then
    return wezterm.nerdfonts.md_battery_70
  elseif charge >= 0.5 then
    return wezterm.nerdfonts.md_battery_50
  elseif charge >= 0.3 then
    return wezterm.nerdfonts.md_battery_30
  else
    return wezterm.nerdfonts.md_battery_20
  end
end

function M.setup()
  wezterm.on('update-status', function(window, pane)
    local cwd = get_cwd(pane)

    -- Left status: current working directory
    window:set_left_status(wezterm.format {
      { Foreground = { Color = colors.purple } },
      { Text = '  ' .. wezterm.nerdfonts.md_folder .. ' ' .. cwd .. ' ' },
    })

    -- Right status: git branch, battery, date/time
    local cells = {}

    -- Git branch
    local branch = get_git_branch(cwd)
    if branch then
      table.insert(cells, { Foreground = { Color = colors.pink } })
      table.insert(cells, { Text = wezterm.nerdfonts.dev_git_branch .. ' ' .. branch .. '  ' })
    end

    -- Battery
    for _, b in ipairs(wezterm.battery_info()) do
      local icon = get_battery_icon(b.state_of_charge)
      table.insert(cells, { Foreground = { Color = colors.green } })
      table.insert(cells, { Text = icon .. ' ' .. string.format('%.0f%%', b.state_of_charge * 100) .. '  ' })
    end

    -- Date
    table.insert(cells, { Foreground = { Color = colors.cyan } })
    table.insert(cells, { Text = wezterm.nerdfonts.md_calendar .. ' ' .. wezterm.strftime('%a %b %d') .. '  ' })

    -- Time
    table.insert(cells, { Foreground = { Color = colors.foreground } })
    table.insert(cells, { Text = wezterm.nerdfonts.md_clock .. ' ' .. wezterm.strftime('%H:%M') .. ' ' })

    window:set_right_status(wezterm.format(cells))
  end)
end

return M
