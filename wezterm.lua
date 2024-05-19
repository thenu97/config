local wezterm = require("wezterm")
local act = wezterm.action
local c = {}


if wezterm.config_builder then
  c = wezterm.config_builder()
  c:set_strict_mode(true)
end

c.keys = {
  {
    key = "-",
    mods = "ALT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "=",
    mods = "ALT",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
  { key = '{', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  {key="LeftArrow", mods="ALT", action=wezterm.action{SendString="\x1bb"}},
  -- Make Option-Right equivalent to Alt-f; forward-word
  {key="RightArrow", mods="ALT", action=wezterm.action{SendString="\x1bf"}},

  { 
    key = 't',
    mods = 'CMD',
    action = act.SpawnCommandInNewTab({ cwd = wezterm.home_dir }),
  },
  { 
    key = 'O', 
    mods = 'CTRL|SHIFT', 
    action = act.PromptInputLine { 
      description = 'Enter new name for tab', 
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
      },
   },
}

c.send_composed_key_when_left_alt_is_pressed = true
c.send_composed_key_when_right_alt_is_pressed = true
c.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte
c.default_prog = { '/opt/homebrew/bin/fish', '--interactive' }

return c

