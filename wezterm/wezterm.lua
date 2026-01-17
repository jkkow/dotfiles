local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.default_prog = { "pwsh" }
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", scale = 1.03, weight = "Bold" },
	{ family = "D2CodingLigature Nerd Font", scale = 1.0, weight = "Bold" },
})
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"

-- Options: "AlwaysPrompt", "NeverPrompt", "PromptOnQuit"
config.window_close_confirmation = "NeverPrompt"

config.scrollback_lines = 3000
config.default_workspace = "home"
config.initial_cols = 120
config.initial_rows = 30
config.default_cursor_style = "BlinkingUnderline"
config.enable_tab_bar = true

config.background = {
	{
		-- background image
		source = {
			File = wezterm.config_dir .. "/images/dark-desert.jpg", -- The file located in the same directory
		},
		opacity = 1.0, -- Adjust the transparency (0.0 to 1.0)
		vertical_align = "Middle", -- Options: "Top", "Middle", "Bottom"
		horizontal_align = "Center", -- Options: "Left", "Center", "Right"
		hsb = { brightness = 0.1 },
	},
	{
		-- Add an overlay color to the background image
		source = {
			Color = "#0c2043",
		},
		width = "100%",
		height = "100%",
		opacity = 0.55,
	},
}

-- Dim inactive pane
config.inactive_pane_hsb = {
	saturation = 0.35,
	brightness = 0.5,
}

-- Tabs
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Launch menu
config.launch_menu = {
	{ label = "PowerShell", args = { "powershell.exe" } },
	{ label = "WSL: Ubuntu", args = { "wsl.exe", "--distribution", "Ubuntu" } },
}

-- keys
config.leader = { key = ";", mods = "CTRL", timeout_millisecond = 1000 }
config.keys = {
	-- New Tabs
	{
		key = "Enter",
		mods = "CTRL|SHIFT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- Pane keybinding
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = CurrentPaneDomain }),
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = CurrentPaneDomain }),
	},
	{
		key = "h",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "j",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
}

return config
