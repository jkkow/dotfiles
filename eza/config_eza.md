# Eza Configuration

This repo manages `eza` theme configuration through a symlink.

## Install eza

Ubuntu/Debian:

```bash
sudo apt update
sudo apt install -y eza
```

Fallback with Cargo:

```bash
cargo install eza
```

If you use Cargo, make sure `~/.cargo/bin` is in `PATH`.

## Configure theme

Create the config directory:

```bash
mkdir -p ~/.config/eza
```

Link the default theme:

```bash
ln -s ~/dotfiles/eza/themes/tokyonight.yml ~/.config/eza/theme.yml
```

Verify:

```bash
ls -l ~/.config/eza/theme.yml
```

## Change theme

Replace the symlink target:

```bash
rm -f ~/.config/eza/theme.yml
ln -s ~/dotfiles/eza/themes/catppuccin.yml ~/.config/eza/theme.yml
```

Available themes are in `eza/themes/`.

## Automated setup

Run the installer for this tool:

```bash
bash installation/install.sh eza
```

This checks installation, creates `~/.config/eza/`, links the theme file, and verifies the link.

## Troubleshooting

- `eza` not found: run `which eza` and reload shell (`source ~/.bashrc`).
- Theme not applied: verify the symlink path and target file.
- Wrong config path: check `EZA_CONFIG_DIR` and unset it if needed.
