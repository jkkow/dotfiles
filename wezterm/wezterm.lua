local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local is_windows = wezterm.target_triple:find("windows") ~= nil

config.default_prog = is_windows and { "pwsh" } or { "bash" }
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", scale = 1.03, weight = "Bold" },
	{ family = "D2KodingLigature Nerd Font", scale = 1.0, weight = "Bold" },
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

-- Windows-only polish: native title buttons, Mica backdrop, and smoother GPU rendering.
if is_windows then
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.win32_system_backdrop = "Mica"
	config.front_end = "WebGpu"
	config.max_fps = 120
	config.animation_fps = 60
end

-- Two-layer background: image layer first, then a color tint for readability.
config.background = {
	{
		-- The repository is cloned directly into the WezTerm config directory.
		source = {
			File = wezterm.config_dir .. "/images/dark-desert.jpg",
		},
		-- Force full-window coverage and prevent tiling.
		width = "100%",
		height = "100%",
		repeat_x = "NoRepeat",
		repeat_y = "NoRepeat",
		opacity = 1.0,
		vertical_align = "Middle", -- Options: "Top", "Middle", "Bottom"
		horizontal_align = "Center", -- Options: "Left", "Center", "Right"
		hsb = { brightness = 0.18 },
	},
	{
		-- Slight tint keeps text contrast stable over the wallpaper.
		source = {
			Color = "#0c2043",
		},
		width = "100%",
		height = "100%",
		opacity = 0.42,
	},
}

-- Dim inactive pane
config.inactive_pane_hsb = {
	saturation = 0.35,
	brightness = 0.5,
}

-- Tabs
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

if is_windows then
	config.launch_menu = {
		{ label = "PowerShell", args = { "powershell.exe" } },
		{ label = "WSL: Ubuntu", args = { "wsl.exe", "--distribution", "Ubuntu" } },
	}
end

-- Leader key style: press Ctrl+; first, then the action key.
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
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
}

return config
