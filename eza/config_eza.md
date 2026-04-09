# Eza Configuration

Eza is a modern replacement for `ls` with improved defaults and performance. This guide covers installation and configuration on Linux/Ubuntu systems using dotfiles and symbolic links.

## Installation

### On Ubuntu/Debian (Recommended)

Using the system package manager is the simplest approach:

```bash
sudo apt update
sudo apt install eza
```

If eza is not available in your package repositories, use the fallback method below.

### Fallback: Using Rust (Cargo)

If eza is not available through apt:

```bash
cargo install eza
```

The eza binary will be installed to `~/.cargo/bin/eza`, which should be in your PATH if you've sourced `~/.cargo/env`.

## Configuration

### Set Configuration Directory

Eza looks for configuration files in `~/.config/eza/` by default. You can override this with the `$EZA_CONFIG_DIR` environment variable:

```bash
export EZA_CONFIG_DIR="$HOME/.config/eza"
```

### Create Configuration Directory

```bash
mkdir -p ~/.config/eza
```

### Set Up Theme Using Symbolic Link

Instead of copying the theme file, use a symbolic link to keep your configuration in sync with your dotfiles repository. This allows you to manage themes from a single location.

**Create the symlink:**

```bash
ln -s ~/dotfiles/eza/themes/tokyonight.yml ~/.config/eza/theme.yml
```

This command creates a symbolic link at `~/.config/eza/theme.yml` that points to the actual theme file in your dotfiles repository.

**Verify the symlink:**

```bash
ls -l ~/.config/eza/theme.yml
```

You should see output like:
```
lrwxrwxrwx 1 user user 48 Apr 8 15:00 ~/.config/eza/theme.yml -> ~/dotfiles/eza/themes/tokyonight.yml
```

### Available Themes

The following themes are available in the `themes/` directory:

- tokyonight.yml (default)
- catppuccin.yml
- dracula.yml
- gruvbox-dark.yml
- gruvbox-light.yml
- rose-pine.yml
- rose-pine-dawn.yml
- rose-pine-moon.yml
- solarized-dark.yml
- one_dark.yml
- frosty.yml
- black.yml
- white.yml
- default.yml

To use a different theme, update the symlink:

```bash
rm ~/.config/eza/theme.yml
ln -s ~/dotfiles/eza/themes/catppuccin.yml ~/.config/eza/theme.yml
```

## Automated Setup

For automated installation and symlink creation, use the included `install.sh` script in the dotfiles root directory:

```bash
cd ~/dotfiles
bash install.sh
```

This script will:
- Check for eza installation
- Create the `~/.config/eza/` directory
- Set up the tokyonight theme symlink automatically
- Validate the symlink is working correctly

## Troubleshooting

### Symlink Not Working

If eza doesn't recognize your theme, verify:

1. The symlink is correctly set up:
   ```bash
   ls -l ~/.config/eza/theme.yml
   ```

2. The target file exists:
   ```bash
   cat ~/.config/eza/theme.yml
   ```

3. Eza is reading the correct config directory:
   ```bash
   eza --config-dir
   ```

### Theme Not Applying

If eza runs but the theme doesn't apply:

1. Verify the theme file syntax is valid YAML
2. Restart your shell to reload environment variables
3. Check if there's an `EZA_CONFIG_DIR` environment variable overriding the default location

### Eza Command Not Found

After installation, you may need to:

1. Restart your shell or run `source ~/.bashrc`
2. Check that the installation succeeded: `which eza`
3. If using cargo, ensure `~/.cargo/bin` is in your PATH
