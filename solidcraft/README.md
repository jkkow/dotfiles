# SolidCraft

This directory is the location for an explicitly exported SolidCraft settings
profile managed with Git. Export the profile below to create the JSON file.
SolidCraft continues to use its normal live settings directory; this is not a
symbolic link and the exported profile does not update automatically.

## Export on Windows

1. Open SolidCraft and configure the preferences and keyboard shortcuts.
2. Open **Preferences > General > Settings profiles**.
3. Enter a profile name that includes the SolidCraft version, then save it.
4. Select the profile and choose **Export...**. Save the JSON file in
   `%USERPROFILE%\.config\solidcraft\`, for example
   `personal.solidcraft-profile.json`.
5. Review the export for personal or machine-specific information, then inspect
   `git status --short` and `git diff -- solidcraft` from `~/.config`.

After changing a preference or shortcut, save the profile again and re-export it
to refresh the Git copy. Untracked files do not appear in `git diff` until added;
review their contents before staging. Commit only the intended files.

## Import on another computer

1. Install a compatible SolidCraft version and open **Preferences > General >
   Settings profiles**.
2. Choose **Import...** and select the exported `*.solidcraft-profile.json`.
3. Select the imported profile to apply it; importing alone does not apply it.
4. Check the shortcuts, interface and navigation. Some settings may be skipped
   if a version or computer does not support them.

Profiles include custom shortcuts, S box favorites, toolbar customization and
selected interface, navigation and sketch preferences. A separate shortcuts
JSON is only needed to manage those settings independently. Profiles exclude
graphics, device-specific 3D mouse settings, recent files and Assistant
settings; they are not complete backups of every preference.

## Live settings and local data

Windows documentation identifies `%APPDATA%\SolidCraft` as the settings
directory. On this computer the existing settings were found under
`%APPDATA%\SolidCraft\data\`: `app.ron` contains application preferences and UI
state, and `graphics.json` holds graphics startup settings. The actual location
may differ by release. Close SolidCraft before copying these files, review them
for machine-specific or private data, and back up the destination before any
restore. Do not assume that importing a profile restores graphics settings.

`%LOCALAPPDATA%\SolidCraft` contains local data such as recovery files, crash
reports and control-channel state. Keep control tokens and other runtime data
out of Git. Recovery and crash data may contain design information.

## References

- [Settings profiles](https://github.com/tangency-labs/solidcraft/blob/main/crates/ui-egui/src/settings_profiles.rs)
- [Settings and data locations](https://github.com/tangency-labs/solidcraft/blob/main/docs/book/src/guide/troubleshooting.md#reset-the-settings)
